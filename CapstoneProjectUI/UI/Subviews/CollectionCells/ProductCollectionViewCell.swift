//
//  ProductCollectionViewCell.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import UIKit
import CapstoneProjectData

final class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    func configure(name: String, price: Int, imageName: String) {
        labelName.text = name
        labelPrice.text = "\(price) TL"
        
        setImage(imageName)
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
