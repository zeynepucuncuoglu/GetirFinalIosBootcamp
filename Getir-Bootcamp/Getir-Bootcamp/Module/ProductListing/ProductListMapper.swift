//
//  ProductListMapper.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 17.04.2024.
//

import Foundation

protocol ProductListMapperProtocol {
    func mapVerticalProducts(_ products: [Product]) -> [VerticalProduct]
    func mapHorizontalProducts(_ suggestedProducts: [Product]) -> [HorizontalProduct]
}

class ProductListMapper: ProductListMapperProtocol {
    func mapVerticalProducts(_ products: [Product]) -> [VerticalProduct] {
        var verticalProducts: [VerticalProduct] = []
        
        for product in products {
            let imageURL: URL
            if let unwrappedURL = product.imageURL {
                imageURL = unwrappedURL
            } else {
                imageURL = URL(string: "https://example.com/default_image.jpg")!
            }
            
            let verticalProduct = VerticalProduct(id: product.id ?? "",
                                                  name: product.name ?? "",
                                                  imageURL: imageURL,
                                                  price: product.price ?? 0,
                                                  priceText: product.priceText ?? "")
            
            verticalProducts.append(verticalProduct)
        }
        
        return verticalProducts
    }
    
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
