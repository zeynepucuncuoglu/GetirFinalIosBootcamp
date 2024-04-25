//
//  ProductListInteractor.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import Foundation

protocol ProductListInteractorProtocol: AnyObject {
    func fetchProducts()
}

protocol ProductListInteractorOutputProtocol: AnyObject {
    func fetchVerticalProductsOutput(productsResult: [Products])
    func fetchHorizontalProductsOutput(suggestedProductsResult: [SuggestedProducts])
}

final class ProductListInteractor {
    weak var output: ProductListInteractorOutputProtocol?
}

extension ProductListInteractor: ProductListInteractorProtocol {
    func fetchProducts() {
        let productRepository = ProductRepository()
        
        // Create a DispatchGroup
        let group = DispatchGroup()
        
        // Fetch vertical products
        group.enter()
        productRepository.fetchVerticalProducts { [weak self] (products, productsError) in
            defer { group.leave() }
            guard let self = self else { return }
            
            if let products = products {
                self.output?.fetchVerticalProductsOutput(productsResult: products)
            } else if let error = productsError {
                print("Error fetching vertical products: \(error.localizedDescription)")
            }
        }
        
        // Fetch horizontal products
        group.enter()
        productRepository.fetchHorizontalProducts { [weak self] (suggestedProducts, suggestedProductsError) in
            defer { group.leave() }
            guard let self = self else { return }
            
            if let suggestedProducts = suggestedProducts {
                self.output?.fetchHorizontalProductsOutput(suggestedProductsResult: suggestedProducts)
            } else if let error = suggestedProductsError {
                print("Error fetching horizontal products: \(error.localizedDescription)")
            }
        }
        
        
        group.notify(queue: .main) {
            
        }
    }
}
