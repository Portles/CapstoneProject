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
    
    private let stepper: ProductStepper = {
        let stepper = ProductStepper()
        return stepper
    }()
    
    private let buttonAddToCart: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
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
            viewModel.addToBasket(product: self.product, orderCount: stepper.currentValue)
        })
        
        buttonAddToCart.addAction(buttonAction, for: .touchUpInside)

        view.addSubview(labelTitle)
        view.addSubview(imageView)
        view.addSubview(labelName)
        view.addSubview(stepper)
        view.addSubview(buttonAddToCart)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        labelTitle.frame = CGRect(x: 16, y: view.safeAreaInsets.top + 32, width: view.width - 32, height: 42)
        imageView.frame = CGRect(x: 16, y: labelTitle.bottom + 32, width: view.width - 32, height: view.width)
        labelName.frame = CGRect(x: 16, y: imageView.bottom + 16, width: view.width - 32, height: 42)
        stepper.frame = CGRect(x: 16, y: labelName.bottom + 16, width: view.width - 32, height: 42)
        buttonAddToCart.frame = CGRect(x: 16, y: stepper.bottom + 16, width: view.width - 32, height: 42)
    }
}
