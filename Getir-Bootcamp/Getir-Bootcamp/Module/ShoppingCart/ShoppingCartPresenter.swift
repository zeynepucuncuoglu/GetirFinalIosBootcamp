
//  ShoppingCartPresenter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.

import Foundation

protocol ShoppingCartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func checkout()
    func mapSugesstedProducts( _ sugesstedProducts: [Product])
}

final class ShoppingCartPresenter {
    unowned var view: ShoppingCartViewControllerProtocol!
    let router: ShoppingCartRouterProtocol
    let interactor: ShoppingCartInteractorProtocol
    let mapper: ShoppingCartMapperProtocol!
    
    private var suggestedProducts: [HorizontalProduct] = []
    private var basketProducts: [Products] = []

    init(view: ShoppingCartViewControllerProtocol,
         router: ShoppingCartRouterProtocol,
         interactor: ShoppingCartInteractorProtocol,
         mapper: ShoppingCartMapperProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.mapper = mapper
    }
    
    private func fetchProducts(){
        //TODO: LOADING EKLE
        interactor.fetchProducts()
    }
}

extension ShoppingCartPresenter: ShoppingCartPresenterProtocol {
    func mapSugesstedProducts( _ sugesstedProducts: [Product]) {
        let sugesstedProd = mapper.mapHorizontalProducts(sugesstedProducts)
        view.displaySuggestedProducts(sugesstedProd)
    }
    
    
    func viewDidLoad() {
        // Fetch and display products from the cart
        let products = BasketManager.shared.getBasket()
        view.displayCartItems(products)
    }

    func checkout() {
        // Perform checkout logic here
        let totalPrice = BasketManager.shared.getTotalPrice()
        let successMessage = "Checkout successful! Total amount: \(totalPrice)"
//        BasketManager.shared.basket.removeAll()
        view.displaySuccessMessage(successMessage)
        // Navigate back to product listing screen
        router.navigate(.ProductListView)
    }
}

extension ShoppingCartPresenter: ShoppingCartInteractorOutputProtocol {
    func fetchHorizontalProductsOutput(suggestedProductsResult: [SuggestedProducts]) {
        for suggestedProducts in suggestedProductsResult {
            if let suggestedProducts = suggestedProducts.products {
                self.suggestedProducts = suggestedProducts
                mapSugesstedProducts(suggestedProducts)
            }
        }
    }
    
}
