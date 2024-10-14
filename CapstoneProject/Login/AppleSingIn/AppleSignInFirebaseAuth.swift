//
//  AppleSignInFirebaseAuth.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//


import Foundation
import FirebaseAuth

public class AppleSignInFirebaseAuth {
    public static let shared = AppleSignInFirebaseAuth()
    
    private init() {}
    
    public func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    public func logOutUser() -> Bool {
        if isUserLoggedIn() {
            try? Auth.auth().signOut()
            return true
        }
        return false
    }
}
