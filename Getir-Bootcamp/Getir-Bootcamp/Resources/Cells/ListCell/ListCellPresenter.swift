//
//  ListCellPresenter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 25.04.2024.
//

import Foundation
import UIKit

protocol ListCellPresenterProtocol: AnyObject{
    func load()
}

final class ListCellPresenter {
    weak var view: ListCellProtocol?
    private let product: Product
    private var imageLoadingTask: URLSessionDataTask?
    
    init(view: ListCellProtocol? = nil, product: Product) {
            self.view = view
            self.product = product
        }
    
}

extension ListCellPresenter: ListCellPresenterProtocol{

    func load() {
         // Set static information
         view?.setNameLabel(product.name ?? "")
         view?.setPriceLabel(product.priceText ?? "")
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
