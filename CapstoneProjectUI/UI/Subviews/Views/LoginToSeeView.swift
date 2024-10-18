//
//  LoginToSeeView.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//

import UIKit

final class LoginToSeeView: UIView {
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private let eyeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "eye.slash"))
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login to see your profile or purchase"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: AppleSignInButton = {
        let button: AppleSignInButton = AppleSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [blurEffectView, eyeImageView, titleLabel, loginButton].forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            eyeImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            eyeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
}
