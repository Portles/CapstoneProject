//
//  ProductDetailViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation
import CapstoneProjectData
import Combine

final class ProductDetailViewModel: Errorable {
    private let networkManager: NetworkManagerProtocol
    
    @Published private(set) var imageData: Data?
    @Published private(set) var message: String?
    
    var performingSomething: Bool {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .performingSomethingChanged, object: nil)
            }
        }
    }
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(),
        performingSomething: Bool = false) {
        self.networkManager = networkManager
        self.performingSomething = performingSomething
    }
    
    func addToBasket(product: Product, orderCount: Int) {
        performingSomething = true
        
        let productRequest: ProductRequest = ProductRequest(
            name: product.name,
            image: product.image,
            category: product.category,
            price: product.price,
            brand: product.brand,
            orderCount: orderCount
        )
        
        debugPrint("Adding Basket Request Triggered")
        
        networkManager.addToBasket(product: productRequest) { [weak self] result in
            switch result {
                case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.performingSomething = false
                    self?.message = "Successfully added to basket"
                }
            case .failure:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.performingSomething = false
                    self?.message = "Failed to add to basket"
                }
            }
        }
    }
    
    func getImage(imageEndpoint: String) {
        Task {
            do {
                let imageData = try await networkManager.fetchImages(imageEndpoint: imageEndpoint)
                
                self.imageData = imageData
            } catch {
                handleError(error)
            }
        }
    }
}
