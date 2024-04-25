//
//  SuggetedProductCellPresenter.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 22.04.2024.
//

import Foundation
import UIKit

protocol SuggestedProductCellPresenterProtocol: AnyObject{
    func load()
    

}

final class SuggestedProductCellPresenter {
    weak var view: SuggestedProductCellProtocol?
    private let product: HorizontalProduct
    
    init(view: SuggestedProductCellProtocol? = nil, product: HorizontalProduct) {
            self.view = view
            self.product = product
        }
}

extension SuggestedProductCellPresenter: SuggestedProductCellPresenterProtocol{
 

    func load() {
        //TODO: fix this
        self.view?.setNameLabel(product.name ?? "")
        self.view?.setPriceLabel(product.priceText ?? "")
        self.view?.setStepperLabelValue(product.quantity ?? 0)
        if let imageURL = product.imageURL {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        // Update the cell's image view with the fetched image
                        self.view?.setImage(image)
                    }
                }
            }
        }
    }
   
}

