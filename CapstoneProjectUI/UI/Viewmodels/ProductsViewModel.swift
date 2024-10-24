//
//  ProductViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation
import Combine
import CapstoneProjectData
import UIKit.UIImage

public protocol ProductsViewModelInterface: AnyObject, Errorable {
    var view: ProductsViewControllerInterface? { get set }
    var productCount: Int { get }
    
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func getProduct(index: Int) -> Product?
    func reArrangeProduct(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ product: Product)
    func getProductImage(_ imageName: String) async -> UIImage
}

final public class ProductsViewModel {
    private let networkManager: NetworkManagerProtocol
    
    weak public var view: ProductsViewControllerInterface?
    
    private var products: [Product]?
    
    public init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    private func getProductsSuccess(_ products: [Product]) {
        setProducts(products)
        reloadCollectionView()
    }
    
    private func setProducts(_ products: [Product]) {
        self.products = products
    }
    
    private func reloadCollectionView() {
        view?.reloadCollectionViewData()
    }
}

extension ProductsViewModel: ProductsViewModelInterface {
    public var productCount: Int {
        products?.count ?? 0
    }
    
    public func viewDidLoad() {
        view?.configureUIElements()
        getProducts()
    }
    
    public func viewDidLayoutSubviews() {
        view?.setConstraints()
    }
    
    public func getProduct(index: Int) -> Product? {
        guard let product = products?[safe: index] else { return nil }
        return product
    }
    
    public func reArrangeProduct(_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ product: Product) {
        products?.remove(at: sourceIndexPath.row)
        products?.insert(product, at: destinationIndexPath.row)
    }
    
    public func getProductImage(_ imageName: String) async -> UIImage {
        return await withCheckedContinuation { continuation in
            Task {
                do {
                    let imageData = try await self.networkManager.fetchImages(imageEndpoint: imageName)
                    
                    if let uiImage = UIImage(data: imageData) {
                        continuation.resume(returning: uiImage)
                    }
                } catch {
                    handleError(error)
                }
            }
        }
    }
    
    func getProducts() {
        networkManager.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.getProductsSuccess(products)
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
}
