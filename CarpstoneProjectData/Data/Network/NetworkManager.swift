//
//  NetworkManager.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation.NSURL

public protocol NetworkManagerProtocol {
    func fetchProducts(_ completion: @escaping (Result<[Product], NetworkError>) -> Void)
    static func fetchImages(imageEndpoint: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void)
    func addToBasket(product: ProductRequest, _ completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func fetchBasket(_ completion: @escaping (Result<[CartProduct], NetworkError>) -> Void)
    func removeFromCart(_ cartId: Int, _ completion: @escaping (Result<Bool, NetworkError>) -> Void)
}

final public class NetworkManager: NetworkManagerProtocol {
    private let decoder: JSONDecoder = {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
    
    public init() { }
    
    public func fetchProducts(_ completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = URL(string: URLEndpoints.fetchProducts.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let productResponse: ProductResponse = try self.decoder.decode(ProductResponse.self, from: data)
                completion(.success(productResponse.products))
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    public static func fetchImages(imageEndpoint: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void) -> Void {
        guard let url = URL(string: "\(URLEndpoints.fetchImages.rawValue)\(imageEndpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
    
    // Here is some response maybe will be added later
    public func addToBasket(product: ProductRequest, _ completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let url = URL(string: URLEndpoints.addToBasket.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = product.responseString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard response != nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard data != nil else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
    
    public func fetchBasket(_ completion: @escaping (Result<[CartProduct], NetworkError>) -> Void) {
        guard let url = URL(string: URLEndpoints.fectBasket.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "kullaniciAdi=nizamet_ozkan".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let productResponse: CartProductResponse = try self.decoder.decode(CartProductResponse.self, from: data)
                completion(.success(productResponse.products))
            } catch {
                debugPrint(error.localizedDescription)
                completion(.success([]))
            }
        }.resume()
    }
    
    public func removeFromCart(_ cartId: Int, _ completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let url = URL(string: URLEndpoints.removeFromBasket.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "sepetId=\(cartId)&kullaniciAdi=nizamet_ozkan".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error != nil else {
                debugPrint(error?.localizedDescription ?? "weird error")
                completion(.success(false))
                return
            }
            
            guard response != nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard data != nil else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
}
