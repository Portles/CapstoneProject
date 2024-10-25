//
//  ProfileViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 17.10.2024.
//

import Foundation
import CapstoneProjectData

final class ProfileViewModel {
    private var isLoggedIn: Bool?
    private var userModel: UserModel?
    
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
