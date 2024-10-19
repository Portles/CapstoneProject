//
//  ProfileViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 17.10.2024.
//

import Foundation
import CapstoneProjectData

final class ProfileViewModel {
    var performingSomething: Bool = true {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .performingSomethingChanged, object: nil)
            }
        }
    }
    
    @Published private(set) var isLoggedIn: Bool?
    @Published private(set) var userModel: UserModel?
    
    func checkLoginStatus() {
        if AppleSignInFirebaseAuth.shared.isUserLoggedIn() {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func getUser() {
        FirebaseManager.fetchCurrentUserData { [weak self] model, error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "Fetch user data error")
                return
            }
            
            if let model {
                self?.userModel = model
            }
        }
    }
}
