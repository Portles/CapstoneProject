//
//  ProductRequest.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

struct ProductRequest {
    let name: String
    let image: String
    let category: String
    let price: Int
    let brand: String
    let orderCount: Int
    let userName: String = "nizamet_ozkan"
    
    init(name: String, image: String, category: String, price: Int, brand: String, orderCount: Int) {
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
