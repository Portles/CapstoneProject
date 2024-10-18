//
//  MockNetworkManager.swift
//  CapstoneProjectData
//
//  Created by Nizamet Özkan on 18.10.2024.
//

import CapstoneProjectData
import Foundation

class MockNetworkManager: NetworkManagerProtocol {
    static func fetchImages(imageEndpoint: String, _ result: @escaping (Result<Data, CapstoneProjectData.NetworkError>) -> Void) {
        result(.success(Data()))
    }
    
    var invokedFetchProducts = false
    var invokedFetchProductsCount = 0
    var stubbedFetchProductsResultResult: (Result<[Product], NetworkError>, Void)?

    func fetchProducts(_ completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        invokedFetchProducts = true
        invokedFetchProductsCount += 1
        if let result = stubbedFetchProductsResultResult {
            completion(result.0)
        }
    }

    var invokedAddToBasket = false
    var invokedAddToBasketCount = 0
    var invokedAddToBasketParameters: (product: ProductRequest, Void)?
    var invokedAddToBasketParametersList = [(product: ProductRequest, Void)]()
    var stubbedAddToBasketResultResult: (Result<Bool, NetworkError>, Void)?

    func addToBasket(product: ProductRequest, _ completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        invokedAddToBasket = true
        invokedAddToBasketCount += 1
        invokedAddToBasketParameters = (product, ())
        invokedAddToBasketParametersList.append((product, ()))
        if let result = stubbedAddToBasketResultResult {
            completion(result.0)
        }
    }

    var invokedFetchBasket = false
    var invokedFetchBasketCount = 0
    var stubbedFetchBasketResultResult: (Result<[CartProduct], NetworkError>, Void)?

    func fetchBasket(_ completion: @escaping (Result<[CartProduct], NetworkError>) -> Void) {
        invokedFetchBasket = true
        invokedFetchBasketCount += 1
        if let result = stubbedFetchBasketResultResult {
            completion(result.0)
        }
    }

    var invokedRemoveFromCart = false
    var invokedRemoveFromCartCount = 0
    var invokedRemoveFromCartParameters: (cartId: Int, Void)?
    var invokedRemoveFromCartParametersList = [(cartId: Int, Void)]()
    var stubbedRemoveFromCartResultResult: (Result<Bool, NetworkError>, Void)?

    func removeFromCart(_ cartId: Int, _ completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        invokedRemoveFromCart = true
        invokedRemoveFromCartCount += 1
        invokedRemoveFromCartParameters = (cartId, ())
        invokedRemoveFromCartParametersList.append((cartId, ()))
        if let result = stubbedRemoveFromCartResultResult {
            completion(result.0)
        }
    }
}
