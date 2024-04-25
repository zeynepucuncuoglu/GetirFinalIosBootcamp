//
//  ProductDetailPresenter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.
//
import UIKit

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad(with product: Product)
    func updateTotalPrice()
    func quantityChanged(value: Int)
    func displayDetails()
    
}

final class ProductDetailPresenter {
    unowned var view: ProductDetailViewControllerProtocol!
    var product : Product?
    let router: ProductDetailRouterProtocol
    
    init(view: ProductDetailViewControllerProtocol, router: ProductDetailRouterProtocol) {
        self.view = view
        self.router = router
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func updateTotalPrice() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("Calculating total price")
            let totalPrice = BasketManager.shared.getTotalPrice()
            
            view.setTotalPrice(totalPrice)
            print(totalPrice)
        }
    }
    
    func quantityChanged(value: Int) {
        guard let product = product else { return }
        product.quantity = value
        BasketManager.shared.updateQuantity(for: product.id!, newQuantity: value)
    }

   
    func displayDetails() {
        print("gidim")
        let url = product?.imageURL

         DispatchQueue.global().async {
             // Fetch Image Data
             if let data = try? Data(contentsOf: url!) {
                 DispatchQueue.main.async {
                     // Create Image and Update Image View
                     self.view?.setImage(UIImage(data: data)!)
                 }
             }
         }
        view?.setNameLabel(product?.name ?? "")
        view?.setPriceLabel(product?.priceText ?? "")
        view.setupStepperValue(value: (product?.quantity)!)
    }
    
    func viewDidLoad(with product: Product) {
        self.product = product
        displayDetails()
        updateTotalPrice()
    }
}

