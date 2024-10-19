//
//  ProductResponse.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

struct ProductResponse: Decodable {
    public let products: [Product]
    public let success: Int
    
    enum CodingKeys: String, CodingKey {
        case products = "urunler"
        case success = "success"
    }
}
