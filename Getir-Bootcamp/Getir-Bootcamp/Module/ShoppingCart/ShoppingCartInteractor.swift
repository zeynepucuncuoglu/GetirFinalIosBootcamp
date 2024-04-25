//
//  ShoppingCartInteractor.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 25.04.2024.
//

import Foundation
protocol ShoppingCartInteractorProtocol: AnyObject {
    func fetchProducts()
}

protocol ShoppingCartInteractorOutputProtocol: AnyObject {
    func fetchHorizontalProductsOutput(suggestedProductsResult: [SuggestedProducts])
}

final class ShoppingCartInteractor {
    weak var output: ShoppingCartInteractorOutputProtocol?
}

extension ShoppingCartInteractor: ShoppingCartInteractorProtocol {
    func fetchProducts() {
        let productRepository = ProductRepository()

        productRepository.fetchHorizontalProducts { [weak self] (suggestedProducts, suggestedProductsError) in
            guard let self = self else { return }
            
            if let suggestedProducts = suggestedProducts {
                self.output?.fetchHorizontalProductsOutput(suggestedProductsResult: suggestedProducts)
            } else if let error = suggestedProductsError {
                print("Error fetching horizontal products: \(error.localizedDescription)")

            }
        }
    }
}
