//
//  ProductDetailViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel = ProductDetailViewModel()
    
    private let product: Product
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .extraLargeTitle)
        label.text = "Product Detail"
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .systemGray5
        button.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
        button.clipsToBounds = true
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        label.text = "Product Name"
        return label
    }()
    
    private let buyView: BuyView = {
        let stepper: BuyView = BuyView()
        return stepper
    }()
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil ,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        labelName.text = product.name
        NetworkManager.fetchImages(imageEndpoint: product.image, { result in
            switch result {
                case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
        
        let buttonAction: UIAction = UIAction(handler: { [unowned self] _ in
            viewModel.addToBasket(product: self.product, orderCount: buyView.counter)
        })
        
        let dismissButtonAction: UIAction = UIAction(handler: { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        buyView.buttonAddToCart.addAction(buttonAction, for: .touchUpInside)
        dismissButton.addAction(dismissButtonAction, for: .touchUpInside)

        view.addSubview(labelTitle)
        view.addSubview(dismissButton)
        view.addSubview(imageView)
        view.addSubview(labelName)
        view.addSubview(buyView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        labelTitle.frame = CGRect(x: 16, y: view.safeAreaInsets.top + 32, width: view.width - 32, height: 42)
        dismissButton.frame = CGRect(x: view.width - 50, y: view.safeAreaInsets.top + 32, width: 40, height: 40)
        imageView.frame = CGRect(x: 16, y: labelTitle.bottom + 32, width: view.width - 32, height: view.width)
        labelName.frame = CGRect(x: 16, y: imageView.bottom + 16, width: view.width - 32, height: 42)
        buyView.frame = CGRect(x: 16, y: labelName.bottom + 16, width: view.width - 32, height: 106)
    }
}
