//
//  BuyHistory.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 15.10.2024.
//

public struct BuyHistory: Codable {
    public let id: String
    public let buyerName: String
    public let buyDate: String
    public let buyyedProducts: [CartProduct]
    
    public init(id: String, buyerName: String, buyDate: String, buyyedProducts: [CartProduct]) {
        self.id = id
        self.buyerName = buyerName
        self.buyDate = buyDate
        self.buyyedProducts = buyyedProducts
    }
}
