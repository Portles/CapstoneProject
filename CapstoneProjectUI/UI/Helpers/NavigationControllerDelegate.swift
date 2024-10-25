//
//  NavigationControllerDelegate.swift
//  CapstoneProjectUI
//
//  Created by Nizamet Özkan on 26.10.2024.
//

import UIKit.UIViewController

public protocol NavigationControllerDelegate {
    func changeSelectedIndex(_ index: Int)
}

public extension NavigationControllerDelegate where Self: UIViewController {
    func changeSelectedIndex(_ index: Int) {
        self.navigationController?.tabBarController?.selectedIndex = index
    }
}
