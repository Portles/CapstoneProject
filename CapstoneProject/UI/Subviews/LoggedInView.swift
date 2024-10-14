//
//  LoggedInView.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 15.10.2024.
//

import UIKit
import FirebaseAuth

protocol LoggedInViewDelegate: AnyObject {
    func logoutButtonTapped()
}

class LoggedInView: UIView {
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nonceKeyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Nonce Key:"
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nonceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameKeyLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.text = "Name:"
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: LoggedInViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let logoutButtonAction: UIAction = UIAction { [weak self] _ in
            if AppleSignInFirebaseAuth.shared.logOutUser() {
                self?.delegate?.logoutButtonTapped()
            }
        }
        
        logoutButton.addAction(logoutButtonAction, for: .touchUpInside)
        
        
        [logoutButton, nonceLabel, nonceKeyLabel, nameLabel, nameKeyLabel].forEach(addSubview)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with user: User) {
        nonceLabel.text = user.refreshToken
        nameLabel.text = user.displayName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 75),
            logoutButton.heightAnchor.constraint(equalToConstant: 16),
            
            nonceKeyLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10),
            nonceKeyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nonceKeyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nonceLabel.topAnchor.constraint(equalTo: nonceKeyLabel.bottomAnchor, constant: 10),
            nonceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nonceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nameKeyLabel.topAnchor.constraint(equalTo: nonceLabel.bottomAnchor, constant: 20),
            nameKeyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameKeyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameKeyLabel.heightAnchor.constraint(equalToConstant: 36),
            
            nameLabel.topAnchor.constraint(equalTo: nonceLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
