//
//  ProductDetailViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation

final class ProductDetailViewModel {
    private let networkManager: NetworkManager = NetworkManager()
    
    var performingSomething: Bool = false {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .performingSomethingChanged, object: nil)
            }
        }
    }
    
    func addToBasket(product: Product, orderCount: Int) {
        performingSomething = true
        
        let productRequest: ProductRequest = ProductRequest(name: product.name, image: product.image, category: product.category, price: product.price, brand: product.brand, orderCount: orderCount)
        
        print("Adding Basket Request Triggered")
        
        networkManager.addToBasket(product: productRequest) { [weak self] result in
            switch result {
                case .success:
                DispatchQueue.main.async {
                    self?.performingSomething = false
                }
                print("Added to basket successfully")
            case .failure:
                DispatchQueue.main.async {
                    self?.performingSomething = false
                }
                print("Failed to add to basket")
            }
        }
    }
}
