//
//  CartViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

import Foundation
import Combine

final class CartViewModel {
    private let networkManager: NetworkManager = NetworkManager()
    
    @Published private(set) var cartProducts: [CartProduct] = []
    
    init() {
        getCartItems()
    }
    
    private func getCartItems() {
        networkManager.fetchBasket { result in
            switch result {
            case .success(let basketItems):
                DispatchQueue.main.async { [weak self] in
                    self?.cartProducts = basketItems
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func calculateTotal() -> String {
        var total: Int = 0
        
        cartProducts.forEach { product in
            total += product.price * product.orderCount
        }
        
        return "\(total)TL"
    }
    
    func removeCartItem(_ cartId: Int) {
        networkManager.removeFromCart(cartId) { [weak self] result in
            switch result {
            case .success(_):
                self?.getCartItems()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
