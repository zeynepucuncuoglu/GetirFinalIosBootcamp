//
//  ListCell.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 25.04.2024.
//

import Foundation
import UIKit

protocol ListCellProtocol: AnyObject {
    func setImage(_ image: UIImage)
    func setNameLabel(_ text: String)
    func setPriceLabel(_ text: String)
    func setAttributeLabel(_ text: String?)
    func setStepperLabelValue(_ value: Int)
}

final class ListCell: UICollectionViewCell {

    let imageView = UIImageView()
    let priceLabel = UILabel()
    let nameLabel = UILabel()
    let attributeLabel = UILabel()
    let horizontalStepperView = HorizontalStepperView()
    
    var stepperValueChangedHandler: ((Int) -> Void)?
    
    static let reuseIdentifier = "ListCell"
    //can ı add two presenter inside a cell for vertical and horizontal ?? or should ı create two different cells
    var cellPresenter: ListCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
        configurePriceLabel()
        configureNameLabel()

        configureHorizontalStepperView()
        
        backgroundColor = .clear // Set background color to clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
}

extension ListCell: ListCellProtocol {
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
    func setNameLabel(_ text: String){
        self.nameLabel.text = text
    }
    func setPriceLabel(_ text: String){
        self.priceLabel.text = text
    }
    func setAttributeLabel(_ text: String?){
        self.attributeLabel.text = text
    }
    func setStepperLabelValue(_ value: Int){

        self.horizontalStepperView.value = value
    }
    
}

// MARK: UI configurations
extension ListCell {

    private func configureHorizontalStepperView() {
        contentView.addSubview(horizontalStepperView)
        horizontalStepperView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalStepperView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            horizontalStepperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            horizontalStepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStepperView.heightAnchor.constraint(equalToConstant: 30) // Adjust the height as needed
        ])
    }

    private func configureImageView() {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 242/255, green: 240/255, blue: 250/255, alpha: 1).cgColor // #F2F0FA
        imageView.layer.cornerRadius = 16
        imageView.accessibilityLabel = "Product Image"
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100) // Adjust the height as needed
        ])
    }
    
    private func configurePriceLabel() {
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        priceLabel.textColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        priceLabel.accessibilityLabel = "Price"
        contentView.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel.textColor = UIColor(named: "text-dark") // Assuming you have defined a color named "text-dark"
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.numberOfLines = 2 // Allow up to two lines for the label
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.accessibilityLabel = "Product Name"
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
}
