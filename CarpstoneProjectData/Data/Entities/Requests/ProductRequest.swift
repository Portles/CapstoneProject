//
//  ProductRequest.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

public struct ProductRequest {
    private let name: String
    private let image: String
    public let category: String
    private let price: Int
    public let brand: String
    private let orderCount: Int
    private let userName: String = "nizamet_ozkan"
    
    public init(name: String, image: String, category: String, price: Int, brand: String, orderCount: Int) {
        self.name = name
        self.image = image
        self.category = category
        self.price = price
        self.brand = brand
        self.orderCount = orderCount
    }
}

extension ProductRequest {
    var responseString: String { "ad=\(self.name)&resim=\(self.image)&kategori=\(self.category)&fiyat=\(self.price)&marka=\(self.brand)&siparisAdeti=\(self.orderCount)&kullaniciAdi=nizamet_ozkan"
    }
}
