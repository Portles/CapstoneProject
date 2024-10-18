//
//  NoLatestPurchaseView.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 17.10.2024.
//

import UIKit

protocol NoLatestPurchaseViewDelegate: AnyObject {
    func goBuyButtonTapped()
}

class NoLatestPurchaseView: UIView {
    private let noLatestPurchaseLabel: UILabel = {
        let label = UILabel()
        label.text = "No Latest Purchase"
        label.font = .systemFont(ofSize: 26, weight: .bold, width: .standard)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noLatestPurchaseImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(systemName: "cart")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let goBuyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go Buy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: NoLatestPurchaseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let goBuyAction: UIAction = UIAction { [weak self] _ in
            self?.delegate?.goBuyButtonTapped()
        }
        
        goBuyButton.addAction(goBuyAction, for: .touchUpInside)
        
        [noLatestPurchaseLabel, noLatestPurchaseImageView, goBuyButton].forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            noLatestPurchaseLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noLatestPurchaseLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            
            noLatestPurchaseImageView.bottomAnchor.constraint(equalTo: noLatestPurchaseLabel.topAnchor),
            noLatestPurchaseImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noLatestPurchaseImageView.widthAnchor.constraint(equalToConstant: 57),
            noLatestPurchaseImageView.heightAnchor.constraint(equalToConstant: 52),
            
            goBuyButton.topAnchor.constraint(equalTo: noLatestPurchaseLabel.bottomAnchor, constant: 10),
            goBuyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            goBuyButton.heightAnchor.constraint(equalToConstant: 46),
            goBuyButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
