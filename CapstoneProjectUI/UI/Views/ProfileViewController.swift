//
//  ProfileViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//

import UIKit
import FirebaseAuth
import CapstoneProjectData

final class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel = ProfileViewModel()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .secondarySystemBackground
        activityIndicator.layer.zPosition = 999
        activityIndicator.layer.opacity = 0.4
        return activityIndicator
    }()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(performingSomethingChanged), name: .performingSomethingChanged, object: nil)
        
        view.addSubview(activityIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.performingSomething = true
        }
        AppleSignInManager.shared.delegate = self
        checkLoginStatus()
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.performingSomething = false
        }
    }
    
    @objc private func performingSomethingChanged() {
        let isLoading = viewModel.performingSomething
        activityIndicator.isHidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.center = view.center
        activityIndicator.frame = view.bounds
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
    func didTapBuyButton() {
        self.navigationController?.tabBarController?.selectedIndex = 0
    }
    
    func logoutButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.performingSomething = true
        }
        setLogoutedView()
        loggedInView.removeFromSuperview()
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.performingSomething = false
        }
    }
}

extension ProfileViewController: AppleSignInDelegate {
    func appleSignInDidComplete(user: FirebaseAuth.User) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.performingSomething = true
        }
        setLoggedView()
        loginToSeeView.removeFromSuperview()
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.performingSomething = false
        }
    }
    
    func appleSignInDidFail(error: any Error) {
        debugPrint(error.localizedDescription)
    }
}
