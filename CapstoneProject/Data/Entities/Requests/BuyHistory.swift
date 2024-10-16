//
//  BuyHistory.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 15.10.2024.
//

struct BuyHistory: Codable {
    let id: String
    let buyerName: String
    let buyDate: String
    let buyyedProducts: [CartProduct]
}
