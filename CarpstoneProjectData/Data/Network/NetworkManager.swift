//
//  NetworkManager.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 7.10.2024.
//

import Foundation.NSURL

public protocol NetworkManagerProtocol {
    func fetchProducts(_ completion: @escaping (Result<[Product], NetworkError>) -> Void)
    func fetchImages(imageEndpoint: String) async throws -> Data
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
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard error == nil else {
                completion(.failure(.message(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let productResponse: ProductResponse = try self.decoder.decode(ProductResponse.self, from: data)
                if productResponse.success == 1 {
                    completion(.success(productResponse.products))
                } else {
                    completion(.failure(.invalidData))
                }
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    public func fetchImages(imageEndpoint: String) async throws -> Data {
        guard let url = URL(string: "\(URLEndpoints.fetchImages.rawValue)\(imageEndpoint)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, 200...299  ~= response.statusCode else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
    
    public func fetchImages(imageEndpoint: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: "\(URLEndpoints.fetchImages.rawValue)\(imageEndpoint)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard error == nil else {
                completion(.failure(.message(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
    
    public func addToBasket(product: ProductRequest, _ completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let url = URL(string: URLEndpoints.addToBasket.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = product.responseString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard error == nil else {
                completion(.failure(.message(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let messageResponse: MessageResponse = try self.decoder.decode(MessageResponse.self, from: data)
                debugPrint(messageResponse)
                if messageResponse.success == 1 {
                    completion(.success(true))
                } else {
                    completion(.failure(.invalidData))
                }
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(.invalidData))
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
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard error == nil else {
                completion(.failure(.message(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let productResponse: CartProductResponse = try self.decoder.decode(CartProductResponse.self, from: data)
                
                if productResponse.success == 1 {
                    completion(.success(productResponse.products))
                } else {
                    completion(.failure(.invalidData))
                }
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(.invalidData))
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
            guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard error == nil else {
                completion(.failure(.message(error)))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let messageResponse: MessageResponse = try self.decoder.decode(MessageResponse.self, from: data)
                debugPrint(messageResponse)
                if messageResponse.success == 1 {
                    completion(.success(true))
                } else {
                    completion(.failure(.invalidData))
                }
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}
