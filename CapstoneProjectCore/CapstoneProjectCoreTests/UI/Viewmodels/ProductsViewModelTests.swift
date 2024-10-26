////
////  ProductsViewModelTests.swift
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
//class ProductsViewModelTests: XCTestCase {
//    
//    var viewModel: ProductsViewModel!
//    var mockNetworkManager: MockNetworkManager!
//    var cancellables: Set<AnyCancellable>!
//    
//    override func setUp() {
//        super.setUp()
//        mockNetworkManager = MockNetworkManager()
//        viewModel = ProductsViewModel(networkManager: mockNetworkManager)
//        cancellables = []
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        mockNetworkManager = nil
//        cancellables = nil
//        super.tearDown()
//    }
//    
//    func test_getProducts_success() {
//        // Given
//        let expectedProducts: [Product] = [
//            Product(id: 1, name: "someName1", image: "someImage1.some", category: "someCategory1", price: 1000, brand: "someBrand1"),
//            Product(id: 2, name: "someName2", image: "someImage2.some", category: "someCategory2", price: 2000, brand: "someBrand2")
//        ]
//        mockNetworkManager.stubbedFetchProductsResult = (.success(expectedProducts), ())
//        var receivedProducts: [Product] = []
//        let expectation = self.expectation(description: "Products getted")
//        
//        // When
//        viewModel.$products
//            .dropFirst()
//            .sink { products in
//                receivedProducts = products
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        viewModel.getProducts()
//        
//        // Then
//        waitForExpectations(timeout: 1.0)
//        XCTAssertTrue(mockNetworkManager.invokedFetchProducts)
//        XCTAssertEqual(mockNetworkManager.invokedFetchProductsCount, 2)
//        XCTAssertEqual(receivedProducts, expectedProducts)
//    }
//    
//    func test_getProducts_failure() {
//        // Given
//        let expectedError = NetworkError.invalidData
//        mockNetworkManager.stubbedFetchProductsResult = (.failure(expectedError), ())
//        
//        // When
//        viewModel.$products
//            .dropFirst()
//            .sink { products in
//                XCTAssertTrue(products.isEmpty)
//            }
//            .store(in: &cancellables)
//        
//        viewModel.getProducts()
//        
//        // Then
//        XCTAssertTrue(mockNetworkManager.invokedFetchProducts)
//        XCTAssertEqual(mockNetworkManager.invokedFetchProductsCount, 2)
//    }
//}
