//
//  ProfileViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//

import UIKit
import FirebaseAuth
import CapstoneProjectData

public protocol ProfileViewControllerInterface: AnyObject, Alertable {
    func configureUI()
    func setConstraints()
    
    func getSelf() -> (any AppleSignInDelegate)?
    
    func setLoggedView()
    func setLogoutedView()
}

final public class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModelInterface
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .secondarySystemBackground
        activityIndicator.layer.zPosition = 999
        activityIndicator.layer.opacity = 0.4
        return activityIndicator
    }()
    
    private let loginToSeeView: LoginToSeeView = LoginToSeeView()
    
    private let loggedInView: LoggedInView = LoggedInView()
    
    public init(viewModel: ProfileViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLAyoutSubviews()
    }
}

extension ProfileViewController: ProfileViewControllerInterface {
    public func getSelf() -> (any AppleSignInDelegate)? {
        self
    }
    
    public func setConstraints() {
        activityIndicator.center = view.center
        activityIndicator.frame = view.bounds
    }
    
    public func setLoggedView() {
        loggedInView.delegate = self
        viewModel.getUser()
        
        view.addSubview(loggedInView)
        loggedInView.frame = view.bounds
        loggedInView.getLatestPurchase()
    }
    
    public func setLogoutedView() {
        view.addSubview(loginToSeeView)
        loginToSeeView.frame = view.bounds
    }
    
    public func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(activityIndicator)
    }
}

extension ProfileViewController: LoggedInViewDelegate, NavigationControllerDelegate {
    func didTapBuyButton() {
        changeSelectedIndex(0)
    }
    
    func logoutButtonTapped() {
        setLogoutedView()
        loggedInView.removeFromSuperview()
    }
}

extension ProfileViewController: AppleSignInDelegate {
    public func appleSignInDidComplete(user: FirebaseAuth.User) {
        setLoggedView()
        loginToSeeView.removeFromSuperview()
    }
    
    public func appleSignInDidFail(error: any Error) {
        debugPrint(error.localizedDescription)
    }
}
