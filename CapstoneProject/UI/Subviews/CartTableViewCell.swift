//
//  CartTableViewCell.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

import UIKit.UITableViewCell

protocol CartTableViewCellDelegate {
    func didTapRemoveButton(_ cartId: Int)
}

final class CartTableViewCell: UITableViewCell {
    static let identifier: String = "CartTableViewCell"
    
    var delegate: CartTableViewCellDelegate?
    
    private var cartId: Int?
    
    private let productImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.text = "Cart Product Name"
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.text = "0TL"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .right
        label.text = "Count: 1"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let removeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.layer.masksToBounds = true
        
        let removeAction: UIAction = UIAction { [weak self] _ in
            if let cartId = self?.cartId {
                self?.delegate?.didTapRemoveButton(cartId)
            }
        }
        
        removeButton.addAction(removeAction, for: .touchUpInside)
        
        contentView.addSubview(blurEffectView)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(removeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurEffectView.frame = contentView.frame
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 125),
            
            nameLabel.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20),
            
            priceLabel.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -20),
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20),
            
            countLabel.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: -20),
            countLabel.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -20),
            
            removeButton.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 20),
            removeButton.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: -20)
        ])
    }
    
    func configure(cartId: Int, imageName: String, name: String, price: Int, count: Int) {
        self.cartId = cartId
        NetworkManager.fetchImages(imageEndpoint: imageName) { result in
            switch result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async { [weak self] in
                        self?.productImageView.image = image
                    }
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        nameLabel.text = name
        priceLabel.text = "\(price)TL"
        countLabel.text = "Count: \(count)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        countLabel.text = nil
    }
}
