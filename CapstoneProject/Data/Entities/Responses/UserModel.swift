//
//  UserModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 15.10.2024.
//

import Foundation

struct UserModel {
    let uid: String
    let fullName: String?
    let email: String?

    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.fullName = data["fullName"] as? String
        self.email = data["email"] as? String
    }
}
