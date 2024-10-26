//
//  NetworkError.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

public enum NetworkError: Error, Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidURL
    case message(_ error: Error?)
    case invalidResponse
    case invalidData
}
