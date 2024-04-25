//
//  SplashRouter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import Foundation
import UIKit

enum SplashRoutes {
    case ProductListingScreen
}

protocol SplashRouterProtocol {
    func navigate(_ route: SplashRoutes)
}
final class SplashRouter {
    weak var viewController: SplashViewController?
    
    static func createModule() -> SplashViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        
        let presenter = SplashPresenter(view: view, router: router, interactor: interactor)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

extension SplashRouter: SplashRouterProtocol {
    func navigate(_ route: SplashRoutes) {
        switch route {
        case .ProductListingScreen:
            //TODO: nav to product list
            print("Product list ekranına geçildi")
            guard let window = viewController?.view.window else { return }
            let productListingVC = ProductListRouter.createModule()
            let navigationController = UINavigationController(rootViewController: productListingVC)
            window.rootViewController = navigationController
            
        }
    }
    
    
}
