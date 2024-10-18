//
//  ProductsViewModelTests.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 18.10.2024.
//

import XCTest
import Combine
@testable import CapstoneProjectData
@testable import CapstoneProjectUI

class ProductsViewModelTests: XCTestCase {
    
    var viewModel: ProductsViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = ProductsViewModel(networkManager: mockNetworkManager)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_getProducts_success() {
        // Given
        let expectedProducts: [Product] = [
            Product(id: 1, name: "someName1", image: "someImage1.some", category: "someCategory1", price: 1000, brand: "someBrand1"),
            Product(id: 2, name: "someName2", image: "someImage2.some", category: "someCategory2", price: 2000, brand: "someBrand2")
        ]
        mockNetworkManager.stubbedFetchProductsResultResult = (.success(expectedProducts), ())
        var receivedProducts: [Product] = []
        let expectation = self.expectation(description: "Products getted")
        
        // When
        viewModel.$products
            .dropFirst()
            .sink { products in
                receivedProducts = products
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.getProducts()
        
        // Then
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(mockNetworkManager.invokedFetchProducts)
        XCTAssertEqual(mockNetworkManager.invokedFetchProductsCount, 2)
        XCTAssertEqual(receivedProducts, expectedProducts)
    }
    
    func test_getProducts_failure() {
        // Given
        let expectedError = NetworkError.invalidData
        mockNetworkManager.stubbedFetchProductsResultResult = (.failure(expectedError), ())
        
        // When
        viewModel.$products
            .dropFirst()
            .sink { products in
                XCTAssertTrue(products.isEmpty)
            }
            .store(in: &cancellables)
        
        viewModel.getProducts()
        
        // Then
        XCTAssertTrue(mockNetworkManager.invokedFetchProducts)
        XCTAssertEqual(mockNetworkManager.invokedFetchProductsCount, 2)
    }
    
    func test_reArrangeProduct() {
        // Given
        let expectedProducts: [Product] = [
            Product(id: 1, name: "someName1", image: "someImage1.some", category: "someCategory1", price: 1000, brand: "someBrand1"),
            Product(id: 2, name: "someName2", image: "someImage2.some", category: "someCategory2", price: 2000, brand: "someBrand2")
        ]
        mockNetworkManager.stubbedFetchProductsResultResult = (.success(expectedProducts), ())
        var receivedProducts: [Product] = []
        let expectation = self.expectation(description: "Products loaded")
        var isFulfilled = false
        
        viewModel.$products
            .dropFirst()
            .sink { products in
                receivedProducts = products
                if !isFulfilled {
                    expectation.fulfill()
                    isFulfilled = true
                }
            }
            .store(in: &cancellables)
        
        viewModel.getProducts()
        
        // When
        viewModel.reArrangeProduct(IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0), receivedProducts[0])
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.products[0], expectedProducts[1])
        XCTAssertEqual(viewModel.products[1], expectedProducts[0])
    }
}
