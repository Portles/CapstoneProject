//
//  AppleSignInDelegate.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//


import Foundation
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import UIKit
import CryptoKit

public protocol AppleSignInDelegate: AnyObject {
    func appleSignInDidComplete(user: User)
    func appleSignInDidFail(error: Error)
}

public class AppleSignInManager: NSObject {
    
    public static let shared = AppleSignInManager()
    
    private override init() {
        super.init()
    }
    
    public weak var delegate: AppleSignInDelegate?
    
    private var currentNonce: String?
    
    public func performAppleSignIn(from viewController: UIViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        if let nonce = randomNonceString() {
            currentNonce = nonce
            request.nonce = sha256(nonce)
        }
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

extension AppleSignInManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                delegate?.appleSignInDidFail(error: NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid nonce"]))
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                delegate?.appleSignInDidFail(error: NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"]))
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                delegate?.appleSignInDidFail(error: NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to serialize token"]))
                return
            }
            
            let providerID: AuthProviderID = AuthProviderID.apple
            
            let credential = OAuthProvider.credential(providerID: providerID,
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    self?.delegate?.appleSignInDidFail(error: error)
                    return
                }
                guard let user = authResult?.user else {
                    self?.delegate?.appleSignInDidFail(error: NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get user"]))
                    return
                }
                
                if authResult?.additionalUserInfo?.isNewUser == true {
                    self?.saveAppleUserData(appleIDCredential: appleIDCredential, user: user)
                }
                
                self?.delegate?.appleSignInDidComplete(user: user)
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.appleSignInDidFail(error: error)
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
    
    private func saveAppleUserData(appleIDCredential: ASAuthorizationAppleIDCredential, user: User) {
        let db = Firestore.firestore()
        
        var userData: [String: Any] = [:]
        
        if let fullName = appleIDCredential.fullName {
            let name = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
            userData["fullName"] = name
        }
        
        if let email = appleIDCredential.email {
            userData["email"] = email
        }
        db.collection("users").document(user.uid).setData(userData, merge: true) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data successfully saved.")
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String? {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    return 0
                }
                return random
            }
            
            for random in randoms {
                if remainingLength == 0 {
                    break
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
