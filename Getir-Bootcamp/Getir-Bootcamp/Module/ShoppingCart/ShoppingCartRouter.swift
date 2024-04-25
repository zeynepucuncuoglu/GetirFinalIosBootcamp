//
//  ShoppingCartRouter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.
//

enum ShoppingCartRoutes{
    case ProductListView
}
protocol ShoppingCartRouterProtocol: AnyObject {
func navigate(_ route: ShoppingCartRoutes)
}

final class ShoppingCartRouter {
weak var viewController: ShoppingCartViewController?

static func createModule() -> ShoppingCartViewController {
    let view = ShoppingCartViewController()
    let router = ShoppingCartRouter()
    let interactor = ShoppingCartInteractor()
    let mapper = ShoppingCartMapper()
    let presenter = ShoppingCartPresenter(view: view, router: router, interactor: interactor, mapper: mapper)
    
    view.presenter = presenter
    router.viewController = view
    interactor.output = presenter
    
    return view
}
}

extension ShoppingCartRouter: ShoppingCartRouterProtocol {

func navigate(_ route: ShoppingCartRoutes) {
    switch route {
    case .ProductListView:
        viewController?.navigationController?.popViewController(animated: true)
    }
}

}
