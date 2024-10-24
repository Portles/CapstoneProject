//
//  Alertable.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 25.10.2024.
//

import UIKit

public protocol Alertable {
    func showAlert(_ message: String?)
}

public extension Alertable where Self: UIViewController {
    func showAlert(_ message: String?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
