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
    
    var performingSomething: Bool = false {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .performingSomethingChanged, object: nil)
            }
        }
    }
    
    @Published private(set) var cartProducts: [CartProduct] = []
    
    private var rawCartProducts: [CartProduct] = []
    
    init() {
        getCartItems()
    }
    
    func getCartItems() {
        performingSomething = true
        
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
            guard rawCartProduct.name == cartProduct.name, rawCartProduct.price == cartProduct.price, rawCartProduct.image == cartProduct.image, rawCartProduct.category == cartProduct.category, rawCartProduct.brand == cartProduct.brand else {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.performingSomething = false
        }
        self.cartProducts = mergedProducts
    }
    
    func confirmPurchases() {
        if !rawCartProducts.isEmpty {
            saveUserPurchases()
        }
    }
    
    private func saveUserPurchases() {
        FirebaseManager.fetchCurrentUserData { [weak self] model, error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "Fetch user error")
                return
            }
            
            guard let model else {
                debugPrint("Fetch user data error")
                return
            }
            
            self?.saveBuyHistory(userData: model)
        }
    }
    
    private func saveBuyHistory(userData: UserModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        let buyHistory = BuyHistory(id: userData.uid, buyerName: userData.fullName ?? "Unknown name", buyDate: dateString, buyyedProducts: cartProducts)
        
        FirebaseManager.saveBuyHistory(buyHistory) { [weak self] error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "save buy history error")
                return
            }
            
            debugPrint("Buyyed products saved successfully")
            self?.clearCart()
        }
    }
    
    private func clearCart() {
        for rawCartProduct in rawCartProducts {
            networkManager.removeFromCart(rawCartProduct.cartId) { [weak self] result in
                switch result {
                case .success(_):
                    if self?.rawCartProducts.last?.cartId == rawCartProduct.cartId {
                        self?.getCartItems()
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
