//
//  Item.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 6.10.2024.
//

public struct Product: Decodable {
    public let id: Int
    public let name: String
    public let image: String
    public let category: String
    public let price: Int
    public let brand: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "ad"
        case image = "resim"
        case category = "kategori"
        case price = "fiyat"
        case brand = "marka"
    }
}
