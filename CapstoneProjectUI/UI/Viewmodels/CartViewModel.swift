//
//  CartViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

import CapstoneProjectData
import UIKit.UIImage

public protocol CartViewModelInterface: Errorable {
    var view: CartViewControllerInterface? { get set }
    var total: String { get }
    var cellLenght: CGFloat { get }
    var cartProductCount: Int { get }
    
    func viewDidLoad()
    func viewDidAppear()
    func viewDidLayoutSubviews()
    
    func saveUserPurchases()
    func getCartProducts() -> [CartProduct]?
    func getCartItem(_ index: Int) -> CartProduct?
    func removeCartItem(_ cartProduct: CartProduct)
    func getImage(_ endpoint: String) async -> UIImage?
}

final public class CartViewModel {
    private let networkManager: NetworkManagerInterface
    
    public weak var view: CartViewControllerInterface?
    private let main: DispatchQueueInterface
    
    private var cartProducts: [CartProduct]?
    private var rawCartProducts: [CartProduct] = []
    
    public init(networkManager: NetworkManagerInterface = NetworkManager(),
         main: DispatchQueueInterface = DispatchQueue.main) {
        self.networkManager = networkManager
        self.main = main
    }
    
    private func getCartItems() {
        networkManager.fetchBasket { [weak self] result in
            switch result {
            case .success(let basketItems):
                self?.successGetCartItems(basketItems)
            case .failure(let error):
                self?.failureGetCartItems(error)
            }
        }
    }
    
    private func successGetCartItems(_ basketItems: [CartProduct]) {
        rearangeDuplicatedItems(basketItems)
        view?.setButtonsEnability(state: true, opacity: 1.0)
    }
    
    private func failureGetCartItems(_ error: Error) {
        rearangeDuplicatedItems([])
        view?.setButtonsEnability(state: false, opacity: 0.7)
        view?.handleError(error)
    }
}

extension CartViewModel: CartViewModelInterface {
    public func getCartProducts() -> [CartProduct]? {
        cartProducts
    }
    
    public var total: String {
        calculateTotal()
    }
    
    public var cartProductCount: Int {
        cartProducts?.count ?? 0
    }
    
    public var cellLenght: CGFloat {
        128
    }
    
    public func viewDidLayoutSubviews() {
        view?.setContraints()
    }
    
    public func getImage(_ endpoint: String) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            Task {
                do {
                    let imageData = try await networkManager.fetchImages(imageEndpoint: endpoint)
                    
                    continuation.resume(returning: UIImage(data: imageData))
                } catch {
                    view?.handleError(error)
                }
            }
        }
    }
    
    public func getCartItem(_ index: Int) -> CartProduct? {
        cartProducts?[safe: index]
    }
    
    public func viewDidLoad() {
        view?.configureUIElements()
    }
    
    public func viewDidAppear() {
        getCartItems()
        view?.reloadTableView()
    }
    
    private func calculateTotal() -> String {
        var total: Int = 0
        
        cartProducts?.forEach { product in
            total += product.price * product.orderCount
        }
        
        return "\(total)TL"
    }
    
    public func removeCartItem(_ cartProduct: CartProduct) {
        let cartIdsToRemove: [Int] = rawCartProducts.compactMap { rawCartProduct in
            guard rawCartProduct == cartProduct else {
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
    }
    
    public func saveUserPurchases() {
        guard !rawCartProducts.isEmpty else { return }
        
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
    
    public func saveBuyHistory(userData: UserModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        let buyHistory = BuyHistory(id: userData.uid, buyerName: userData.fullName ?? "Unknown name", buyDate: dateString, buyyedProducts: cartProducts ?? [])
        
        FirebaseManager.saveBuyHistory(buyHistory) { [weak self] error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "Save buy history error")
                return
            }
            
            self?.clearCart()
        }
    }
    
    public func clearCart() {
        for rawCartProduct in rawCartProducts {
            networkManager.removeFromCart(rawCartProduct.cartId) { [weak self] result in
                switch result {
                case .success(_):
                    if self?.rawCartProducts.last?.cartId == rawCartProduct.cartId {
                        self?.getCartItems()
                    }
                case .failure(let error):
                    self?.view?.handleError(error)
                }
            }
        }
    }
}
