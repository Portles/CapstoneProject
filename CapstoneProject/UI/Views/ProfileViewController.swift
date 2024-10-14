//
//  ProfileViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
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
        } else {
            setLogoutedView()
        }
    }
    
    private func setLoggedView() {
        loggedInView.delegate = self
        if let user: User = AppleSignInFirebaseAuth.shared.getCurrentUser() {
            loggedInView.configure(with: user)
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
