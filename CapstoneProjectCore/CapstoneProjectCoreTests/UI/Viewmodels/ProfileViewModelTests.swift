//
//  ProfileViewModelTests.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 18.10.2024.
//

import XCTest
@testable import CapstoneProjectUI

class ProfileViewModelTests: XCTestCase {
    
    var viewModel: ProfileViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ProfileViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testPerformingSomethingChangedNotification() {
        let expectation = self.expectation(forNotification: .performingSomethingChanged, object: nil, handler: nil)
        
        viewModel.performingSomething = false
        
        wait(for: [expectation], timeout: 1.0)
    }
}
