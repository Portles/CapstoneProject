//
//  ProductDetailViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation
import CapstoneProjectData
import UIKit.UIImage

public protocol ProductDetailViewModelInterface: Errorable {
    var view: ProductDetailViewControllerInterface? { get set }
    var productName: String { get }
    
    func addToBasket(orderCount: Int)
    func getImage() async -> UIImage
    func viewDidLoad()
    func viewDidLayoutSubviews()
}

final public class ProductDetailViewModel {
    private let networkManager: NetworkManagerProtocol
    private let main: DispatchQueueInterface
    
    weak public var view: ProductDetailViewControllerInterface?
    
    private let product: Product
    
    private var imageData: Data?
    
    init(product: Product, networkManager: NetworkManagerProtocol,
         main: DispatchQueueInterface = DispatchQueue.main) {
        self.product = product
        self.networkManager = networkManager
        self.main = main
    }
}

extension ProductDetailViewModel: ProductDetailViewModelInterface {
    public var productName: String {
        product.name
    }
    
    public func viewDidLoad() {
        view?.configureUIElement()
    }
    
    public func viewDidLayoutSubviews() {
        view?.setConstraints()
    }
    
    public func addToBasket(orderCount: Int) {
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
            case .success(_):
                self?.main.asyncAfter(delay: 1) {
                    self?.view?.showAlert("Yey")
                }
            case .failure(let error):
                self?.main.asyncAfter(delay: 1) {
                    self?.handleError(error)
                }
            }
        }
    }
    
    public func getImage() async -> UIImage {
        return await withCheckedContinuation { continuation in
            Task {
                do {
                    let imageData = try await self.networkManager.fetchImages(imageEndpoint: product.image)
                    
                    if let uiImage = UIImage(data: imageData) {
                        continuation.resume(returning: uiImage)
                    }
                } catch {
                    handleError(error)
                }
            }
        }
    }
}
