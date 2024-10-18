//
//  ProductViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation
import Combine
import CapstoneProjectData

final class ProductsViewModel {
    private let networkManager: NetworkManagerProtocol
    
    @Published private(set) var products: [Product] = []
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
        getProducts()
    }
    
    func getProducts() {
        networkManager.fetchProducts { result in
            switch result {
            case .success(let products):
                self.products = products
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
