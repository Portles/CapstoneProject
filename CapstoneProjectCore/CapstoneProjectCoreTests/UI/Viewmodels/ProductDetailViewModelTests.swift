////
////  ProductDetailViewModelTests.swift
////  CapstoneProjectUI
////
////  Created by Nizamet Özkan on 18.10.2024.
////
//
//import XCTest
//import Combine
//@testable import CapstoneProjectData
//@testable import CapstoneProjectUI
//
//class ProductDetailViewModelTests: XCTestCase {
//    
//    var viewModel: ProductDetailViewModel!
//    var mockNetworkManager: MockNetworkManager!
//    
//    override func setUp() {
//        super.setUp()
//        mockNetworkManager = MockNetworkManager()
//        viewModel = ProductDetailViewModel(networkManager: mockNetworkManager)
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        mockNetworkManager = nil
//        super.tearDown()
//    }
//    
//    func testAddToBasketSuccess() {
//        // Given
//        mockNetworkManager.stubbedAddToBasketResult = (.success(true), ())
//        
//        // When
//        let product = Product(id: 1, name: "Test Product", image: "image.png", category: "Test Category", price: 1000, brand: "Test Brand")
//        viewModel.addToBasket(product: product, orderCount: 2)
//        
//        // Then
//        XCTAssertTrue(mockNetworkManager.invokedAddToBasket)
//        XCTAssertEqual(mockNetworkManager.invokedAddToBasketCount, 1)
//    }
//    
//    func testAddToBasketFailureInvalidResponse() {
//        // Given
//        mockNetworkManager.stubbedAddToBasketResult = (.failure(.invalidResponse), ())
//        
//        // When
//        let product = Product(id: 1, name: "Test Product", image: "image.png", category: "Test Category", price: 100, brand: "Test Brand")
//        viewModel.addToBasket(product: product, orderCount: 2)
//        
//        // Then
//        XCTAssertTrue(mockNetworkManager.invokedAddToBasket)
//        XCTAssertEqual(mockNetworkManager.invokedAddToBasketCount, 1)
//    }
//    
//    func testAddToBasketFailureInvalidData() {
//        // Given
//        mockNetworkManager.stubbedAddToBasketResult = (.failure(.invalidData), ())
//        
//        // When
//        let product = Product(id: 1, name: "Test Product", image: "image.png", category: "Test Category", price: 100, brand: "Test Brand")
//        viewModel.addToBasket(product: product, orderCount: 2)
//        
//        // Then
//        XCTAssertTrue(mockNetworkManager.invokedAddToBasket)
//        XCTAssertEqual(mockNetworkManager.invokedAddToBasketCount, 1)
//    }
//    
//    func testAddToBasketFailureInvalidURL() {
//        // Given
//        mockNetworkManager.stubbedAddToBasketResult = (.failure(.invalidURL), ())
//        
//        // When
//        let product = Product(id: 1, name: "Test Product", image: "image.png", category: "Test Category", price: 100, brand: "Test Brand")
//        viewModel.addToBasket(product: product, orderCount: 2)
//        
//        // Then
//        XCTAssertTrue(mockNetworkManager.invokedAddToBasket)
//        XCTAssertEqual(mockNetworkManager.invokedAddToBasketCount, 1)
//    }
//    
//    func testAddToBasketFailureInvalidMessage() {
//        // Given
//        mockNetworkManager.stubbedAddToBasketResult = (.failure(.message(DummyErrorCode.dummy)), ())
//        
//        // When
//        let product = Product(id: 1, name: "Test Product", image: "image.png", category: "Test Category", price: 100, brand: "Test Brand")
//        viewModel.addToBasket(product: product, orderCount: 2)
//        
//        // Then
//        XCTAssertTrue(mockNetworkManager.invokedAddToBasket)
//        XCTAssertEqual(mockNetworkManager.invokedAddToBasketCount, 1)
//    }
//}
//
//fileprivate enum DummyErrorCode: Error {
//    case dummy
//}
