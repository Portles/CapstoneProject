//
//  ProfileViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//

import UIKit
import FirebaseAuth
import CapstoneProjectData

final public class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel = ProfileViewModel()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .secondarySystemBackground
        activityIndicator.layer.zPosition = 999
        activityIndicator.layer.opacity = 0.4
        return activityIndicator
    }()
    
    private let loginToSeeView: LoginToSeeView = LoginToSeeView()
    
    private let loggedInView: LoggedInView = LoggedInView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(performingSomethingChanged), name: .performingSomethingChanged, object: nil)
        
        view.addSubview(activityIndicator)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
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
    
    override public func viewDidLayoutSubviews() {
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
        viewModel.performingSomething = true
        setLogoutedView()
        loggedInView.removeFromSuperview()
        viewModel.performingSomething = false
    }
}

extension ProfileViewController: AppleSignInDelegate {
    public func appleSignInDidComplete(user: FirebaseAuth.User) {
        viewModel.performingSomething = true
        setLoggedView()
        loginToSeeView.removeFromSuperview()
        viewModel.performingSomething = false
    }
    
    public func appleSignInDidFail(error: any Error) {
        debugPrint(error.localizedDescription)
    }
}
