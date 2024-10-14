//
//  LogInViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    private let titleLable: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Login To Continue"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appleSignInButton: AppleSignInButton = {
        let button: AppleSignInButton = AppleSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLable)
        view.addSubview(appleSignInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLable.heightAnchor.constraint(equalToConstant: 64),
            
            appleSignInButton.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            appleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            appleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}

extension LoginViewController: AppleSignInDelegate {
    func appleSignInDidComplete(user: FirebaseAuth.User) {
        self.dismiss(animated: true)
    }
    
    func appleSignInDidFail(error: any Error) {
        debugPrint(error.localizedDescription)
    }
}
