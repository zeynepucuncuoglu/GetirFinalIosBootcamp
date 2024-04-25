//
//  ShoppingCartMapper.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 25.04.2024.
//

import Foundation

protocol ShoppingCartMapperProtocol {
   
    func mapHorizontalProducts(_ suggestedProducts: [Product]) -> [HorizontalProduct]
}

class ShoppingCartMapper: ShoppingCartMapperProtocol {
    func mapHorizontalProducts(_ suggestedProducts: [Product]) -> [HorizontalProduct] {
        var horizontalProducts: [HorizontalProduct] = []
        for product in suggestedProducts {
            let imageURL: URL
            if let unwrappedURL = product.imageURL {
                imageURL = unwrappedURL
            } else {
                imageURL = URL(string: "https://example.com/default_image.jpg")!
            }
            
            let horizontalProduct = HorizontalProduct(id: product.id ?? "",
                                                      name: product.name ?? "",
                                                      imageURL: imageURL,
                                                      price: product.price ?? 0,
                                                      priceText: product.priceText ?? "")
            
            
            horizontalProducts.append(horizontalProduct)
        }
        
        return horizontalProducts
    }
}
