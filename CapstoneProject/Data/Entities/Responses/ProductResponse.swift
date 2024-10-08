//
//  ProductResponse.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

struct ProductResponse: Codable {
    let products: [Product]
    let success: Int
    
    enum CodingKeys: String, CodingKey {
        case products = "urunler"
        case success = "success"
    }
}
