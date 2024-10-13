//
//  ProductViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation
import Combine
import CapstoneData

final class ProductsViewModel {
    private let networkManager: NetworkManager = NetworkManager()
    
    @Published private(set) var products: [Product] = []
    
    init() {
        getProducts()
    }
    
    func getProducts() {
        networkManager.fetchProducts { result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async { [weak self] in
                    self?.products = products
                }
            case .failure:
                break
            }
        }
    }
    
    func reArrangeProduct(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ product: Product) {
        products.remove(at: sourceIndexPath.row)
        products.insert(product, at: destinationIndexPath.row)
    }
}
