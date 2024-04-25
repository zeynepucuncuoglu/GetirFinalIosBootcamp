//
//  ProductRepository.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import Foundation

protocol ProductRepositoryProtocol {
    func fetchVerticalProducts(completion: @escaping ([Products]?, Error?) -> Void)
    func fetchHorizontalProducts(completion: @escaping ([SuggestedProducts]?, Error?) -> Void)
}

final class ProductRepository: ProductRepositoryProtocol {

    func fetchHorizontalProducts(completion: @escaping ([SuggestedProducts]?, Error?) -> Void) {
        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/suggestedProducts") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching horizontal products: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, error)
                return
            }
            
            do {
                let SuggestedProducts = try JSONDecoder().decode([SuggestedProducts].self, from: data)
                completion(SuggestedProducts, nil)
            } catch {
                print("Error decoding horizontal products: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func fetchVerticalProducts(completion: @escaping ([Products]?, Error?) -> Void) {
        guard let url = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/products") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching vertical products: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, error)
                return
            }
            
            do {
                let Products = try JSONDecoder().decode([Products].self, from: data)
                completion(Products, nil)
            } catch {
                print("Error decoding vertical products: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
