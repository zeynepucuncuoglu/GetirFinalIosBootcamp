//
//  ProductCellPresenter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 17.04.2024.
//

import Foundation
import UIKit

protocol ProductCellPresenterProtocol: AnyObject{
    func load()
}

final class ProductCellPresenter {
    weak var view: ProductCellProtocol?
    private let product: VerticalProduct
    private var imageLoadingTask: URLSessionDataTask?
    
    init(view: ProductCellProtocol? = nil, product: VerticalProduct) {
            self.view = view
            self.product = product
        }
    
}

extension ProductCellPresenter: ProductCellPresenterProtocol{

    func load() {
         // Set static information
         view?.setNameLabel(product.name ?? "")
         view?.setPriceLabel(product.priceText ?? "")
         view?.setAttributeLabel(product.attribute ?? "")
         view?.setStepperLabelValue(product.quantity ?? 0)

        let url = product.imageURL

         DispatchQueue.global().async {
             // Fetch Image Data
             if let data = try? Data(contentsOf: url!) {
                 DispatchQueue.main.async {
                     // Create Image and Update Image View
                     self.view?.setImage(UIImage(data: data)!)
                 }
             }
         }
     }
}
