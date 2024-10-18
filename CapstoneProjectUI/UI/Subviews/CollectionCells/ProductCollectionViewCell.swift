//
//  ProductCollectionViewCell.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import UIKit
import CapstoneProjectData

final class ProductCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ProductCollectionViewCell"
    
    private let cellView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.opacity = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelName: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelPrice: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .systemOrange
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellView)
        addSubview(imageView)
        addSubview(labelName)
        addSubview(labelPrice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, price: Int, imageName: String) {
        labelName.text = name
        labelPrice.text = "\(price) TL"
        
        setImage(imageName)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            
            imageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            labelName.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            labelName.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            
            labelPrice.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
            labelPrice.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            labelPrice.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
        ])
    }
    
    private func setImage(_ imageName: String) {
        NetworkManager.fetchImages(imageEndpoint: imageName) { [weak self] result in
            switch result {
                case .success(let uiImage):
                if let image = UIImage(data: uiImage) {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = image
                    }
                }
            case .failure:
                return
            }
        }
    }
}
