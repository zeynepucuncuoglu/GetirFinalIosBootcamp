//
//  ProductListingEntity.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import Foundation

class SuggestedProducts: Decodable {
    let id: String?
    let name: String?
    let products: [HorizontalProduct]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case products
    }
}

class Products: Decodable {
    let id: String?
    let name: String?
    let products: [VerticalProduct]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case products
    }
}


class Product: Decodable,Hashable {
    let id: String?
    let name: String?
    let imageURL: URL?
    let price: Double?
    let priceText: String?
    var quantity: Int?

    init(id: String, name: String, imageURL: URL, price: Double, priceText: String, quantity: Int = 0) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.priceText = priceText
        self.quantity = quantity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(imageURL)
        hasher.combine(price)
        hasher.combine(priceText)
        hasher.combine(quantity)
    }

    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.imageURL == rhs.imageURL &&
               lhs.price == rhs.price &&
               lhs.priceText == rhs.priceText &&
               lhs.quantity == rhs.quantity
    }
}

class VerticalProduct: Product {
    var attribute: String?
    var thumbnailURL: URL?

    override init(id: String, name: String, imageURL: URL, price: Double, priceText: String, quantity: Int = 0) {
        super.init(id: id, name: name, imageURL: imageURL, price: price, priceText: priceText, quantity: quantity)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attribute = try container.decodeIfPresent(String.self, forKey: .attribute)
        self.thumbnailURL = try container.decodeIfPresent(URL.self, forKey: .thumbnailURL)
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case attribute
        case thumbnailURL
    }
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(attribute)
        hasher.combine(thumbnailURL)
    }

    static func ==(lhs: VerticalProduct, rhs: VerticalProduct) -> Bool {
        return lhs.attribute == rhs.attribute &&
               lhs.thumbnailURL == rhs.thumbnailURL &&
               lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.imageURL == rhs.imageURL &&
               lhs.price == rhs.price &&
               lhs.priceText == rhs.priceText &&
               lhs.quantity == rhs.quantity
    }
}

class HorizontalProduct: Product {
    var shortDescription: String?

    override init(id: String, name: String, imageURL: URL, price: Double, priceText: String, quantity: Int = 0) {
        super.init(id: id, name: name, imageURL: imageURL, price: price, priceText: priceText, quantity: quantity)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case shortDescription
    }
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(shortDescription)
    }

    static func ==(lhs: HorizontalProduct, rhs: HorizontalProduct) -> Bool {
        return lhs.shortDescription == rhs.shortDescription &&
               lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.imageURL == rhs.imageURL &&
               lhs.price == rhs.price &&
               lhs.priceText == rhs.priceText &&
               lhs.quantity == rhs.quantity
    }
}


