//
//  ProductListRouter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import Foundation

enum ProductListRoutes {
    case detail(with: Product)
    case basket
}

protocol ProductListRouterProtocol: AnyObject {
    func navigate(_ route: ProductListRoutes)
}

final class ProductListRouter {
    
    weak var viewController: ProductListViewController?
    
    static func createModule() -> ProductListViewController {
        let view = ProductListViewController()
        let interactor = ProductListInteractor()
        let router = ProductListRouter()
        let mapper = ProductListMapper()
        let presenter = ProductListPresenter(view: view, router: router, interactor: interactor, mapper: mapper)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        
        return view
    }
}

extension ProductListRouter: ProductListRouterProtocol {
    func navigate(_ route: ProductListRoutes) {
        switch route {
        case .detail(let product):
            print("detail ekranına geçildi")
            let productDetailVC = ProductDetailRouter.createModule(product: product)
            viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
        case .basket:
            print("cart ekranına geçildi")
            let shoppingCartVC = ShoppingCartRouter.createModule()
            viewController?.navigationController?.pushViewController(shoppingCartVC, animated: true)
        }
    }
}

