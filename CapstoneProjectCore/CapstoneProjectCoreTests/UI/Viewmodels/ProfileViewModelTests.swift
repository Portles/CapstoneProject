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

    func testPerformingSomethingNotification() {
        // Given
        _ = self.expectation(forNotification: .performingSomethingChanged, object: nil, handler: nil)

        // When
        viewModel.performingSomething = false

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertFalse(viewModel.performingSomething)
    }
}
