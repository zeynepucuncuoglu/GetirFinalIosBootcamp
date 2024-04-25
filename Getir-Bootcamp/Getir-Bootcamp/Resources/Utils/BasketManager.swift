//
//  BasketManager.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.
//

import Foundation


class BasketManager {
    static let shared = BasketManager()
    
    internal private(set) var basket: [Product] = []
    
    func addToBasket(product: Product) {
        basket.append(product)
    }
    
    func removeFromBasket(at index: Int) {
        basket.remove(at: index)
    }
    
    func updateQuantity(for productId: String, newQuantity: Int) {
           if let productIndex = basket.firstIndex(where: { $0.id == productId }) {
               basket[productIndex].quantity = newQuantity
           }
       }

    
    func getTotalPrice() -> Double {
        return basket.reduce(0) { $0 + (($1.price ?? 0) * Double($1.quantity ?? 0)) }
    }
    
    func getBasket() -> [Product] {
        return basket
    }
    func addProducts(_ products: [Product]) {
        basket.append(contentsOf: products)
    }

}
