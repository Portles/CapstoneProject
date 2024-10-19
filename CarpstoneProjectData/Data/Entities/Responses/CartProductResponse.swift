//
//  CartProductResponse.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

struct CartProductResponse: Decodable {
    public let products: [CartProduct]
    public let success: Int
    
    enum CodingKeys: String, CodingKey {
        case products = "urunler_sepeti"
        case success = "success"
    }
}
