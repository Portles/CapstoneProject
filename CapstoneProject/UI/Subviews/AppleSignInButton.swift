//
//  AppleSignInButton.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 14.10.2024.
//


import UIKit
import AuthenticationServices

protocol AppleSignInButtonDelegate: AnyObject {
    func didSignIn()
}

public class AppleSignInButton: UIButton {
    weak var delegate: AppleSignInButtonDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.setTitle(" Sign in with Apple ", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .black
        self.layer.cornerRadius = 8
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        guard let topViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        AppleSignInManager.shared.performAppleSignIn(from: topViewController)
        
        delegate?.didSignIn()
    }
}
