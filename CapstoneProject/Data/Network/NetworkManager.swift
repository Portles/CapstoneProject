//
//  NetworkManager.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation.NSURL
import UIKit.UIImage

final class NetworkManager {
    private let decoder: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
    
    func fetchProducts(_ result: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php") else {
            result(.failure(.invalidURL))
            return
        }
        
        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                result(.failure(.invalidResponse))
                return
            }
            
            do {
                let productResponse: ProductResponse = try self.decoder.decode(ProductResponse.self, from: data)
                result(.success(productResponse.products))
            } catch {
                debugPrint(error.localizedDescription)
                result(.failure(.invalidData))
            }
        }.resume()
    }
    
    static func fetchImages(imageEndpoint: String, _ result: @escaping (Result<Data, NetworkError>) -> Void) -> Void {
        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(imageEndpoint)") else {
            result(.failure(.invalidURL))
            return
        }
        
        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                result(.failure(.invalidResponse))
                return
            }
            
            result(.success(data))
            
        }.resume()
    }
    
}
