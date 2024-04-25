//
//  ProductListPresenter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import Foundation

protocol ProductListPresenterProtocol: AnyObject{
    func viewDidLoad()
    func ProductDetail(_ index: Int) -> Product?
    func mapProducts(_ products: [Product], _ sugesstedProducts: [Product])
    func didSelectProduct(product: Product)
    func tappedBasketButton()
    
}

final class ProductListPresenter {
    unowned var view: ProductListViewControllerProtocol!
    let router: ProductListRouterProtocol!
    let interactor: ProductListInteractorProtocol!
    let mapper: ProductListMapperProtocol!
    
    private var products: [VerticalProduct] = []
    private var suggestedProducts: [HorizontalProduct] = []
    
    private var verticalProductsFetched = false
    private var horizontalProductsFetched = false
    
    
    init(view: ProductListViewControllerProtocol!,
         router: ProductListRouterProtocol!,
         interactor: ProductListInteractorProtocol!,
         mapper: ProductListMapperProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        self.mapper = mapper
    }
}

extension ProductListPresenter: ProductListPresenterProtocol {
    func didSelectProduct(product: Product) {
        router.navigate(.detail(with: product))
    }
    
    func tappedBasketButton() {
        router.navigate(.basket)
        print("presenter tapped")
    }
    
    private func checkProductsFetched() {
        if verticalProductsFetched && horizontalProductsFetched {
            mapProducts(products, suggestedProducts)
            print("oldu")
        }
    }
    
    
    func viewDidLoad() {
        fetchProducts()
        print("viewdidloaddım")
    }
    
    
    func ProductDetail(_ index: Int) -> Product? {
        return nil
    }
    
    private func fetchProducts(){
        //TODO: LOADING EKLE
        interactor.fetchProducts()
    }
    
    func mapProducts(_ products: [Product], _ sugesstedProducts: [Product]) {
        print("map pro")
        let verticalProducts = mapper.mapVerticalProducts(products)
        let horizontalProducts = mapper.mapHorizontalProducts(sugesstedProducts)
        view.updateProducts(verticalProducts, horizontalProducts)
        let allProducts = verticalProducts + horizontalProducts
        BasketManager.shared.addProducts(allProducts)
        
    }
}

extension ProductListPresenter: ProductListInteractorOutputProtocol {
    func fetchHorizontalProductsOutput(suggestedProductsResult: [SuggestedProducts]) {
        for suggestedProducts in suggestedProductsResult {
            if let suggestedProducts = suggestedProducts.products {
                self.suggestedProducts = suggestedProducts
                horizontalProductsFetched = true
                checkProductsFetched()
                
            }
        }
    }
    
    func fetchVerticalProductsOutput(productsResult: [Products]) {
        for products in productsResult {
            if let products = products.products {
                self.products = products
                verticalProductsFetched = true
                checkProductsFetched()
                
            }
        }
    }
}


