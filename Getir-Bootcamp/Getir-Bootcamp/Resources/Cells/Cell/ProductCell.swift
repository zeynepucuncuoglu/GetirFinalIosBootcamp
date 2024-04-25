//
//  ProductCell.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import UIKit

protocol ProductCellProtocol: AnyObject {
    func setImage(_ image: UIImage)
    func setNameLabel(_ text: String)
    func setPriceLabel(_ text: String)
    func setAttributeLabel(_ text: String?)
    func setStepperLabelValue(_ value: Int)
}

final class ProductCell: UICollectionViewCell {

    let imageView = UIImageView()
    let priceLabel = UILabel()
    let nameLabel = UILabel()
    let attributeLabel = UILabel()
    let stepperView = VerticalStepperView()
    
    var stepperValueChangedHandler: ((Int) -> Void)?
    
    static let reuseIdentifier = "ProductCell"
    //can ı add two presenter inside a cell for vertical and horizontal ?? or should ı create tow different cell
    var cellPresenter: ProductCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
        configurePriceLabel()
        configureNameLabel()
        configureAttributeLabel()
        configureStepperView()
        
        backgroundColor = .clear // Set background color to clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset stepper value and any other UI elements
        stepperView.value = 0 // Reset stepper value to 0 or any default value you prefer
        stepperView.hiddenDecrement()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure correct layout for subviews, e.g., stepperView
        contentView.layoutIfNeeded()
    }
    
}

extension ProductCell: ProductCellProtocol {
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
        self.stepperView.value = value
        if value > 0 {
            stepperView.visibleDecrement()
        }
    }
    
}

extension ProductCell: StepperDelegate {
    func stepperValueChanged(newValue: Int) {
        stepperValueChangedHandler?(newValue)
       }
}



// MARK: UI configuretions
extension ProductCell {
    private func configureStepperView() {
        
        stepperView.delegate = self
        contentView.addSubview(stepperView)
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stepperView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -15),
            stepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
            stepperView.widthAnchor.constraint(equalToConstant: 30),
            stepperView.heightAnchor.constraint(equalToConstant: 90) // Adjust the height as needed
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
    
    private func configureAttributeLabel() {
        attributeLabel.textColor = UIColor(named: "text-secondary") // Assuming you have defined a color named "text-secondary"
        attributeLabel.font = UIFont.systemFont(ofSize: 12)
        attributeLabel.accessibilityLabel = "Product Attributes"
        contentView.addSubview(attributeLabel)
        
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            attributeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            attributeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attributeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            attributeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
