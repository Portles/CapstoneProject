//
//  UserModel.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 15.10.2024.
//

import Foundation

public struct UserModel {
    public let uid: String
    public let fullName: String?
    public let email: String?

    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.fullName = data["fullName"] as? String
        self.email = data["email"] as? String
    }
}
