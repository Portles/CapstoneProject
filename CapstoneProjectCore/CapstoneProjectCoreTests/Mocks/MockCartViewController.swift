//
//  MockCartViewController.swift
//  CapstoneProjectCoreTests
//
//  Created by Nizamet Özkan on 27.10.2024.
//

import CapstoneProjectUI

class MockCartViewController: CartViewControllerInterface {

    var invokedConfigureUIElements = false
    var invokedConfigureUIElementsCount = 0

    func configureUIElements() {
        invokedConfigureUIElements = true
        invokedConfigureUIElementsCount += 1
    }

    var invokedShowConfirmPurchasesAlert = false
    var invokedShowConfirmPurchasesAlertCount = 0

    func showConfirmPurchasesAlert() {
        invokedShowConfirmPurchasesAlert = true
        invokedShowConfirmPurchasesAlertCount += 1
    }

    var invokedReloadTableView = false
    var invokedReloadTableViewCount = 0

    func reloadTableView() {
        invokedReloadTableView = true
        invokedReloadTableViewCount += 1
    }

    var invokedSetContraints = false
    var invokedSetContraintsCount = 0

    func setContraints() {
        invokedSetContraints = true
        invokedSetContraintsCount += 1
    }

    var invokedSetButtonsEnability = false
    var invokedSetButtonsEnabilityCount = 0
    var invokedSetButtonsEnabilityParameters: (state: Bool, opacity: Float)?
    var invokedSetButtonsEnabilityParametersList = [(state: Bool, opacity: Float)]()

    func setButtonsEnability(state: Bool, opacity: Float) {
        invokedSetButtonsEnability = true
        invokedSetButtonsEnabilityCount += 1
        invokedSetButtonsEnabilityParameters = (state, opacity)
        invokedSetButtonsEnabilityParametersList.append((state, opacity))
    }

    var invokedHandleError = false
    var invokedHandleErrorCount = 0
    var invokedHandleErrorParameters: Error?
    var invokedHandleErrorParametersList = [Error]()

    func handleError(_ error: Error) {
        invokedHandleError = true
        invokedHandleErrorCount += 1
        invokedHandleErrorParameters = error
        invokedHandleErrorParametersList.append(error)
    }

    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (message: String?, Void)?
    var invokedShowAlertParametersList = [(message: String?, Void)]()

    func showAlert(_ message: String?) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (message, ())
        invokedShowAlertParametersList.append((message, ()))
    }
}
