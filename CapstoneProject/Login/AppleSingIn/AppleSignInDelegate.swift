//
//  AppleSignInDelegate.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//


import Foundation
import AuthenticationServices
import FirebaseAuth
import UIKit

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
    
    public func performAppleSignIn(from viewController: UIViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
}

extension AppleSignInManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = randomNonceString() else {
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
                if let user = authResult?.user {
                    self?.delegate?.appleSignInDidComplete(user: user)
                }
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.appleSignInDidFail(error: error)
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
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
