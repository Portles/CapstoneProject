//
//  CartProduct.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

public struct CartProduct: Codable {
    public let cartId: Int
    public let name: String
    public let image: String
    public let category: String
    public let price: Int
    public let brand: String
    public var orderCount: Int
    private let username: String
    
    enum CodingKeys: String, CodingKey {
        case cartId = "sepetId"
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
        case orderCount = "siparisAdeti"
        case username = "kullaniciAdi"
    }
}
