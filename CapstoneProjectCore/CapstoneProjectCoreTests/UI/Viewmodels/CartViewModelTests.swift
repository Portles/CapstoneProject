//
//  CartViewModelTests.swift
//  CapstoneProjectCore
//
//  Created by Nizamet Özkan on 20.10.2024.
//


import XCTest
import CapstoneProjectData
import Combine
@testable import CapstoneProjectUI

class CartViewModelTests: XCTestCase {
    
    var viewModel: CartViewModelInterface!
    var mockNetworkManager: MockNetworkManager!
    var mockView: MockCartViewController!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = CartViewModel(networkManager: mockNetworkManager)
        mockView = MockCartViewController()
        viewModel.view = mockView
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        mockView = nil
        super.tearDown()
    }
    
    func test_viewDidAppear_ResultIsSuccess_InvokesNeccessaryMethods() {
        // Given
        let expectedCartProducts: [CartProduct] = [CartProduct(cartId: 0, name: "name", image: "image", category: "category", price: 1, brand: "brand", orderCount: 1)]
        mockNetworkManager.stubbedFetchBasketResult = (.success(expectedCartProducts), ())
        
        // When
        viewModel.viewDidAppear()
        
        // Then
        XCTAssertEqual(mockNetworkManager.invokedFetchBasket, true)
        XCTAssertEqual(mockNetworkManager.invokedFetchBasketCount, 1)
        
        XCTAssertEqual(mockView.invokedSetButtonsEnability, true)
        XCTAssertEqual(mockView.invokedSetButtonsEnabilityCount, 1)
        XCTAssertTrue(mockView.invokedSetButtonsEnabilityParameters! == (true, 1.0))
        
        XCTAssertEqual(mockView.invokedReloadTableView, true)
        XCTAssertEqual(mockView.invokedReloadTableViewCount, 1)
        
        XCTAssertEqual(viewModel.getCartProducts(), expectedCartProducts)
        XCTAssertEqual(viewModel.cartProductCount, 1)
    }
    
    func test_viewDidAppear_ResultIsFailure_InvokesNeccessaryMethods() {
        // Given
        mockNetworkManager.stubbedFetchBasketResult = (.failure(.invalidData), ())
        
        // When
        viewModel.viewDidAppear()
        
        // Then
        XCTAssertEqual(mockNetworkManager.invokedFetchBasket, true)
        XCTAssertEqual(mockNetworkManager.invokedFetchBasketCount, 1)
        
        XCTAssertEqual(mockView.invokedSetButtonsEnability, true)
        XCTAssertEqual(mockView.invokedSetButtonsEnabilityCount, 1)
        XCTAssertTrue(mockView.invokedSetButtonsEnabilityParameters! == (false, 0.7))
        
        XCTAssertEqual(mockView.invokedHandleError, true)
        XCTAssertEqual(mockView.invokedHandleErrorCount, 1)
        XCTAssertEqual(mockView.invokedHandleErrorParameters as? NetworkError, NetworkError.invalidData)
        
        XCTAssertEqual(viewModel.getCartProducts(), [])
        XCTAssertEqual(viewModel.cartProductCount, 0)
    }
    
    func test_ViewDidLoad_InvokesNeccessaryMethods() {
        // Given
        XCTAssertEqual(mockView.invokedConfigureUIElements, false)
        XCTAssertEqual(mockView.invokedConfigureUIElementsCount, 0)
        
        // When
        viewModel.viewDidLoad()
        
        // Then
        XCTAssertEqual(mockView.invokedConfigureUIElements, true)
        XCTAssertEqual(mockView.invokedConfigureUIElementsCount, 1)
    }
    
//    func testGetCartItemsSuccess() {
//        // Given
//        let expectedProducts = [
//            CartProduct(cartId: 1, name: "Product1", image: "image1.png", category: "category2", price: 100, brand: "Category1", orderCount: 1),
//            CartProduct(cartId: 2, name: "Product2", image: "image2.png", category: "category2", price: 200, brand: "Category2", orderCount: 2)
//        ]
//        mockNetworkManager.stubbedFetchBasketResult = (.success(expectedProducts), ())
//        
//        let expectation = XCTestExpectation(description: "Cart products should be updated")
//        
//        // When
//        viewModel.getCartItems()
//        
//        // Then
//        viewModel.$cartProducts
//            .sink { cartProducts in
//                if !cartProducts.isEmpty {
//                    XCTAssertEqual(cartProducts.count, 2)
//                    XCTAssertEqual(cartProducts[0].name, "Product1")
//                    XCTAssertEqual(cartProducts[1].name, "Product2")
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 1.0)
//    }
//    
//    func testRemoveCartItem() {
//        // Given
//        let productToRemove = CartProduct(cartId: 1, name: "Product1", image: "image1.png", category: "category2", price: 100, brand: "Category1", orderCount: 1)
//        mockNetworkManager.stubbedRemoveFromCartResult = (.success(true), ())
//        
//        let expectation = XCTestExpectation(description: "Cart item should be removed")
//        
//        // When
//        viewModel.removeCartItem(productToRemove)
//        
//        // Then
//        viewModel.$cartProducts
//            .sink { cartProducts in
//                if cartProducts.isEmpty {
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 1.0)
//    }
//    
//    func testCalculateTotal() {
//        // Given
//        let products = [
//            CartProduct(cartId: 1, name: "Product1", image: "image1.png", category: "category2", price: 100, brand: "Category1", orderCount: 1),
//            CartProduct(cartId: 2, name: "Product2", image: "image2.png", category: "category2", price: 200, brand: "Category2", orderCount: 2)
//        ]
//        mockNetworkManager.stubbedFetchBasketResult = (.success(products), ())
//        
//        // When
//        viewModel.getCartItems()
//        
//        // Then
//        XCTAssertEqual(viewModel.total, "500TL")
//    }
//    
//    func testConfirmPurchasesSuccess() {
//        // Given
//        let products = [
//            CartProduct(cartId: 1, name: "Product1", image: "image1.png", category: "category2", price: 100, brand: "Category1", orderCount: 1),
//            CartProduct(cartId: 2, name: "Product2", image: "image2.png", category: "category2", price: 200, brand: "Category2", orderCount: 2)
//        ]
//        mockNetworkManager.stubbedFetchBasketResult = (.success(products), ())
//        mockNetworkManager.stubbedRemoveFromCartResult = (.success(true), ())
//        
//        let expectation = XCTestExpectation(description: "Purchase confirmation should succeed")
//        
//        // When
//        viewModel.getCartItems()
//        viewModel.confirmPurchases()
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            XCTAssertEqual(self.viewModel.message, "Purchase completed Thank you")
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 2.0)
//    }
//    
//    func testConfirmPurchasesFailure() {
//        // Given
//        let products = [
//            CartProduct(cartId: 1, name: "Product1", image: "image1.png", category: "category2", price: 100, brand: "Category1", orderCount: 1)
//        ]
//        mockNetworkManager.stubbedFetchBasketResult = (.success(products), ())
//        mockNetworkManager.stubbedRemoveFromCartResult = (.failure(.invalidResponse), ())
//        
//        let expectation = XCTestExpectation(description: "Purchase confirmation should fail")
//        
//        // When
//        viewModel.getCartItems()
//        viewModel.confirmPurchases()
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            XCTAssertEqual(self.viewModel.message, "Purchase could not be completed, try again.")
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 2.0)
//    }
}
