//
//  ProductDetailRouter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.
//

import Foundation
protocol ProductDetailRouterProtocol: AnyObject {

}

final class ProductDetailRouter {
    weak var viewController: ProductDetailViewController?
    
    static func createModule(product: Product) -> ProductDetailViewController {
        let view = ProductDetailViewController()
        let router = ProductDetailRouter()
        let presenter = ProductDetailPresenter(view: view, router: router)
        
        view.presenter = presenter
        router.viewController = view
    
        presenter.viewDidLoad(with: product)
        
        return view
    }
}

extension ProductDetailRouter: ProductDetailRouterProtocol {

}
