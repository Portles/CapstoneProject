//
//  LatestPurchasesTableViewCell.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

import UIKit.UITableViewCell

final class LatestPurchasesTableViewCell: UITableViewCell {
    static let identifier: String = "LatestPurchasesTableViewCell"
    
    private let countLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        label.text = "2X"
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        blurEffectView.layer.cornerRadius = 12
        blurEffectView.layer.masksToBounds = true
        
        contentView.addSubview(blurEffectView)
        
        contentView.addSubview(countLabel)
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            countLabel.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: 30),
            countLabel.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor),
            
            productImageView.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor, constant: -40),
            productImageView.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 125),
            productImageView.heightAnchor.constraint(equalToConstant: 125),
            
            nameLabel.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: -20),
            
            priceLabel.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -20),
            priceLabel.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor, constant: -20)
        ])
    }
    
    func configure(imageName: String, name: String, price: Int, count: Int) {
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
        priceLabel.text = "Piece: \(price)TL"
        countLabel.text = "\(count)X"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
}
