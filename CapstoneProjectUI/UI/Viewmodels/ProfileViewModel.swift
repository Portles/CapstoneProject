//
//  ProfileViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 17.10.2024.
//

import Foundation
import CapstoneProjectData

public protocol ProfileViewModelInterface {
    var isLoggedIn: Bool { get }
    var userModel: UserModel? { get }
    
    func viewDidLoad()
    func viewDidAppear()
    func viewDidLAyoutSubviews()
    func getUser()
}

final public class ProfileViewModel {
    public var isLoggedIn: Bool {
        AppleSignInFirebaseAuth.shared.isUserLoggedIn()
    }
    
    public var userModel: UserModel?
    
    public weak var view: ProfileViewControllerInterface?
    
    public init() {
        
    }
    
    private func setAppleSignInDelegate(_ delegate: (any AppleSignInDelegate)?) {
        AppleSignInManager.shared.delegate = delegate
    }
    
    private func checkLoginStatus() {
        isLoggedIn ? view?.setLoggedView() : view?.setLogoutedView()
    }
    
    private func succesFetchUserData(_ model: UserModel?) {
        setUserModel(model)
        view?.setLoggedView()
    }
    
    private func failureFetchUserData(_ error: Error?) {
        view?.showAlert(error?.localizedDescription)
        view?.setLogoutedView()
    }
    
    private func setUserModel(_ model: UserModel?) {
        self.userModel = model
    }
}

extension ProfileViewModel: ProfileViewModelInterface {
    public func viewDidLoad() {
        view?.configureUI()
        setAppleSignInDelegate(view?.getSelf())
    }
    
    public func viewDidAppear() {
        checkLoginStatus()
    }
    
    public func viewDidLAyoutSubviews() {
        view?.setConstraints()
    }
    
    public func getUser() {
        FirebaseManager.fetchCurrentUserData { [weak self] model, error in
            guard error == nil else {
                self?.failureFetchUserData(error)
                return
            }
            
            self?.succesFetchUserData(model)
        }
    }
}
