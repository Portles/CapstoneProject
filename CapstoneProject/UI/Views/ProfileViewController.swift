//
//  ProfileViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//

import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    private let loginToSeeView: LoginToSeeView = {
       let view = LoginToSeeView()
        return view
    }()
    
    private let loggedInView: LoggedInView = {
        let view = LoggedInView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppleSignInManager.shared.delegate = self
        checkLoginStatus()
        super.viewDidAppear(animated)
    }
    
    private func checkLoginStatus() {
        if AppleSignInFirebaseAuth.shared.isUserLoggedIn() {
            setLoggedView()
            loggedInView.getLatestPurchase()
        } else {
            setLogoutedView()
        }
    }
    
    private func setLoggedView() {
        loggedInView.delegate = self
        FirebaseManager.fetchCurrentUserData { [weak self] model, error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "Fetch user data error")
                return
            }
            
            if let model {
                self?.loggedInView.configure(with: model)
            }
        }
        
        view.addSubview(loggedInView)
        loggedInView.frame = view.bounds
    }
    
    private func setLogoutedView() {
        view.addSubview(loginToSeeView)
        loginToSeeView.frame = view.bounds
    }
}

extension ProfileViewController: LoggedInViewDelegate {
    func logoutButtonTapped() {
        setLogoutedView()
        loggedInView.removeFromSuperview()
    }
}

extension ProfileViewController: AppleSignInDelegate {
    func appleSignInDidComplete(user: FirebaseAuth.User) {
        setLoggedView()
        loginToSeeView.removeFromSuperview()
    }
    
    func appleSignInDidFail(error: any Error) {
        debugPrint(error.localizedDescription)
    }
}
