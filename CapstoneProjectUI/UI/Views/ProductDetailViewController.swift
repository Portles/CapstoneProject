//
//  ProductDetailViewController.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import UIKit
import CapstoneProjectData

public protocol ProductDetailViewControllerInterface: AnyObject, Errorable, Alertable {
    func configureUIElement()
    func setConstraints()
}

final public class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModelInterface
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .secondarySystemBackground
        activityIndicator.layer.zPosition = 999
        activityIndicator.layer.opacity = 0.4
        return activityIndicator
    }()
    
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
    
    private var imageView: UIImageView = {
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
    
    init(viewModel: ProductDetailViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil ,bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    private func setImageView(_ uiImage: UIImage?) {
        imageView.image = uiImage
    }
}

extension ProductDetailViewController: ProductDetailViewControllerInterface {
    public func configureUIElement() {
        view.backgroundColor = .systemBackground
        
        labelName.text = viewModel.productName
        
        let buttonAction: UIAction = UIAction(handler: { [weak self] _ in
            if let counter = self?.buyView.counter {
                self?.viewModel.addToBasket(orderCount: counter)
            }
        })
        
        let dismissButtonAction: UIAction = UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        
        buyView.buttonAddToCart.addAction(buttonAction, for: .touchUpInside)
        dismissButton.addAction(dismissButtonAction, for: .touchUpInside)
        
        Task.detached { [weak self] in
            guard let self else { return }
            
            let uiImage = await self.viewModel.getImage()
            
            return await MainActor.run {
                self.setImageView(uiImage)
            }
        }
        
        view.addSubview(activityIndicator)
        view.addSubview(labelTitle)
        view.addSubview(dismissButton)
        view.addSubview(imageView)
        view.addSubview(labelName)
        view.addSubview(buyView)
    }
    
    public func setConstraints() {
        activityIndicator.center = view.center
        activityIndicator.frame = view.bounds
        
        labelTitle.frame = CGRect(x: 16, y: view.safeAreaInsets.top + 32, width: view.width - 32, height: 42)
        dismissButton.frame = CGRect(x: view.width - 50, y: view.safeAreaInsets.top + 32, width: 40, height: 40)
        imageView.frame = CGRect(x: 16, y: labelTitle.bottom + 32, width: view.width - 32, height: view.width)
        labelName.frame = CGRect(x: 16, y: imageView.bottom + 16, width: view.width - 32, height: 42)
        buyView.frame = CGRect(x: 16, y: labelName.bottom + 16, width: view.width - 32, height: 142)
    }
}
