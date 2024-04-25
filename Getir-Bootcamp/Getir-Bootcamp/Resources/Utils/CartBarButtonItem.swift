//
//  CartBarButtonItem.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 19.04.2024.
//
import UIKit

class CartBarButtonItemView: UIView {
    
    
    
    private let basketButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate) {
            // Set the button's image
            button.setImage(image, for: .normal)
            
            // Set the button's tint color to your custom color
            button.tintColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        }
        button.layer.cornerRadius = 5
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        // Set width constraint for the basket button
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return button
    }()
    
    private let totalPriceLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        label.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 250/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.isUserInteractionEnabled = true
        label.layer.cornerRadius = 5
        label.adjustsFontSizeToFitWidth = true // Adjusts the font size to fit the width of the label
        label.minimumScaleFactor = 0.5 // Minimum scale factor for the font size
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var stackView: UIStackView = {

        let stackView = UIStackView(arrangedSubviews: [basketButton, totalPriceLabel])
        stackView.isUserInteractionEnabled = true
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0 // Set the spacing to 0 to eliminate any space between views
        stackView.backgroundColor = UIColor(red: 242/255, green: 240/255, blue: 250/255, alpha: 1)
        stackView.layer.cornerRadius = 5
        return stackView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
  
    private func setupViews() {
        self.clipsToBounds = false
        // Add stack view to the custom view
        addSubview(stackView)
        
        // Position the stack view within the custom view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        // Set content hugging and compression resistance priorities to ensure views stick close together
        basketButton.setContentHuggingPriority(.required, for: .horizontal)
        totalPriceLabel.setContentHuggingPriority(.required, for: .horizontal)
        basketButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        totalPriceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        
    }
    
    func updateTotalPriceLabel(with price: Double) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let formattedPrice = formatter.string(from: NSNumber(value: price)) ?? ""
        totalPriceLabel.text = formattedPrice
        
        // Temporarily increase the button width during the translation animation
              let originalWidth = basketButton.bounds.width
              let targetWidth = originalWidth + 20
              
              UIView.animate(withDuration: 0.5, animations: {
                  self.stackView.bringSubviewToFront(self.basketButton)
                  self.basketButton.bounds.size.width = targetWidth
                  self.basketButton.transform = CGAffineTransform(translationX: self.totalPriceLabel.frame.width , y: 0)
              }) { _ in
                  UIView.animate(withDuration: 0.5) {
                      self.basketButton.bounds.size.width = originalWidth // Restore the original width
                      self.basketButton.transform = .identity
                  }
        }
    }

}
