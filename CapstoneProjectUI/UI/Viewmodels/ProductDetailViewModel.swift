//
//  ProductDetailViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation
import CapstoneProjectData
import Combine

final class ProductDetailViewModel {
    private let networkManager: NetworkManagerProtocol
    
    @Published private(set) var imageData: Data = Data()
    
    var performingSomething: Bool = false {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .performingSomethingChanged, object: nil)
            }
        }
    }
    
    init(performingSomething: Bool = false, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        self.performingSomething = performingSomething
    }
    
    func addToBasket(product: Product, orderCount: Int) {
        performingSomething = true
        
        let productRequest: ProductRequest = ProductRequest(name: product.name, image: product.image, category: product.category, price: product.price, brand: product.brand, orderCount: orderCount)
        
        print("Adding Basket Request Triggered")
        
        networkManager.addToBasket(product: productRequest) { [weak self] result in
            switch result {
                case .success:
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    self?.performingSomething = false
                }
                print("Added to basket successfully")
            case .failure:
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    self?.performingSomething = false
                }
                print("Failed to add to basket")
            }
        }
    }
    
    func getImage(imageEndpoint: String) {
        NetworkManager.fetchImages(imageEndpoint: imageEndpoint, { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageData = imageData
            case .failure(let error):
                print(error)
            }
        })
    }
}
