//
//  ProfileViewModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 17.10.2024.
//

import Foundation

final class ProfileViewModel {
    var performingSomething: Bool = true {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .performingSomethingChanged, object: nil)
            }
        }
    }
}
