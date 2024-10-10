//
//  ProductDetailViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

final class ProductDetailViewModel {
    let networkManager: NetworkManager = NetworkManager()
    
    init() {
        
    }
    
    func addToBasket(product: Product, orderCount: Int) {
        let productRequest: ProductRequest = ProductRequest(name: product.name, image: product.image, category: product.category, price: product.price, brand: product.brand, orderCount: orderCount)
        
        networkManager.addToBasket(product: productRequest) { result in
            switch result {
                case .success:
                print("Added to basket successfully")
            case .failure:
                print("Failed to add to basket")
            }
        }
    }
}
