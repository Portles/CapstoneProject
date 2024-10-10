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
    
    private var rawCartProducts: [CartProduct] = []
    
    init() {
        getCartItems()
    }
    
    private func getCartItems() {
        networkManager.fetchBasket { [weak self] result in
            switch result {
            case .success(let basketItems):
                self?.rearangeDuplicatedItems(basketItems)
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
    
    func removeCartItem(_ cartProduct: CartProduct) {
        let cartIdsToRemove: [Int] = rawCartProducts.compactMap { rawCartProduct in
            guard rawCartProduct.name == cartProduct.name, rawCartProduct.price == cartProduct.price, rawCartProduct.image == cartProduct.image, rawCartProduct.category == cartProduct.category else {
                return nil
            }
            
            return rawCartProduct.cartId
        }
        
        for cartId in cartIdsToRemove {
            networkManager.removeFromCart(cartId) { [weak self] result in
                switch result {
                case .success(_):
                    if cartIdsToRemove.last == cartId {
                        self?.getCartItems()
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    private func rearangeDuplicatedItems(_ cartProducts: [CartProduct]) {
        var mergedProducts: [CartProduct] = []
        
        rawCartProducts = cartProducts
        
        for product in cartProducts {
            if let index = mergedProducts.firstIndex(where: {
                $0.name == product.name &&
                $0.image == product.image &&
                $0.category == product.category &&
                $0.price == product.price &&
                $0.brand == product.brand
            }) {
                mergedProducts[index].orderCount += product.orderCount
            } else {
                mergedProducts.append(product)
            }
        }
        
        self.cartProducts = mergedProducts
        
        debugPrint(rawCartProducts)
    }
}
