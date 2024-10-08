//
//  Item.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 6.10.2024.
//

struct Product: Decodable {
    let id: Int
    let name: String
    let image: String
    let category: String
    let price: Int
    let brand: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
    }
}
