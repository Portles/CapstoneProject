//
//  CartProduct.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

struct CartProduct: Decodable {
    let cartId: Int
    let name: String
    let image: String
    let category: String
    let price: Int
    let brand: String
    let orderCount: Int
    let username: String
    
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
