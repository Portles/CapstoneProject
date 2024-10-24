//
//  CartProduct.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 8.10.2024.
//

public struct CartProduct: Codable, Equatable {
    public static func == (lhs: CartProduct, rhs: CartProduct) -> Bool {
        lhs.name == rhs.name
        && lhs.image == rhs.image
        && lhs.category == rhs.category
        && lhs.price == rhs.price
        && lhs.brand == rhs.brand
        && lhs.orderCount == rhs.orderCount
    }
    
    public let cartId: Int
    public let name: String
    public let image: String
    public let category: String
    public let price: Int
    public let brand: String
    public var orderCount: Int
    private let username: String
    
    public init(cartId: Int, name: String, image: String, category: String, price: Int, brand: String, orderCount: Int) {
        self.cartId = cartId
        self.name = name
        self.image = image
        self.category = category
        self.price = price
        self.brand = brand
        self.orderCount = orderCount
        self.username = "nizamet_ozkan"
    }
    
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
