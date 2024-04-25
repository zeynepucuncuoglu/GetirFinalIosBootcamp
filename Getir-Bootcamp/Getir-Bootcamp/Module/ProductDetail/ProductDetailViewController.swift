//
//  ProductDetailViewController.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.
//

import UIKit

protocol ProductDetailViewControllerProtocol: AnyObject{
    func setupViews()
    func setupNavigationBar()
    func setupStepperValue(value: Int)
    func setImage(_ image: UIImage)
    func setNameLabel(_ text: String)
    func setPriceLabel(_ text: String)
    func setTotalPrice(_ totalPrice: Double)
}

final class ProductDetailViewController: BaseViewController {

    var presenter: ProductDetailPresenterProtocol!
    var stepperView: HorizontalStepperView?
    private var cartBarButtonItemView: CartBarButtonItemView?
    var stepperValue : Int?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)

        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepete Ekle", for: .normal)
        button.backgroundColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setupStackView()
        setupViews()
        setupButton()
        
        setupStepperView()
        print("stepp")
        setupNavigationBar()
    }
 
    
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol{
    func setTotalPrice(_ totalPrice: Double) {
        self.cartBarButtonItemView?.updateTotalPriceLabel(with: totalPrice)
    }
    
    func setImage(_ image: UIImage) {
        self.productImageView.image = image
    }
    
    func setNameLabel(_ text: String){
        self.nameLabel.text = text
    }
    
    func setPriceLabel(_ text: String) {
        self.priceLabel.text = text
    }
    
    func setupStepperValue(value: Int) {
        print("eeee")
        self.stepperValue = value
    }
    
    func setupNavigationBar() {
        
        // Create a custom view for the right bar button item
        let customView = CartBarButtonItemView()
        self.cartBarButtonItemView = customView
        
        // Set the custom view as the right bar button item
        let customBarButtonItem = UIBarButtonItem(customView: customView)
        navigationItem.rightBarButtonItem = customBarButtonItem
        
        
        title = "Ürün Detayı"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]
        
        // Customizing our navigation bar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }

    func setupViews() {

        stackView.addArrangedSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              productImageView.heightAnchor.constraint(equalToConstant: 200),
              productImageView.widthAnchor.constraint(equalToConstant: 200),
              productImageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 80),
          ])

        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(nameLabel)

        nameLabel.numberOfLines = 3
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textAlignment = .center

        priceLabel.setContentHuggingPriority(.required, for: .vertical)
        priceLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        productImageView.image = UIImage(named: "placeholder")
        productImageView.contentMode = .scaleAspectFill

    }


    
    private func setupButton() {
          view.addSubview(button)
          button.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
              button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
              button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
              button.heightAnchor.constraint(equalToConstant: 50)
          ])
      }
      
    private func setupStepperView() {
        stepperView = HorizontalStepperView()
          stepperView?.translatesAutoresizingMaskIntoConstraints = false
          stepperView?.delegate = self
        stepperView?.value = self.stepperValue!
           view.addSubview(stepperView!)
           

           NSLayoutConstraint.activate([
               stepperView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               stepperView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
               stepperView!.heightAnchor.constraint(equalToConstant: 50),
               stepperView!.widthAnchor.constraint(equalToConstant: 200)
           ])
           
           stepperView?.isHidden = true 
       }
    
    @objc private func buttonTapped() {
        stepperView?.isHidden = false
        button.isHidden = true
        stepperView?.value = 1
    }
   

}


extension ProductDetailViewController: HorizontalStepperDelegate {
    func stepperValueDidChange(to value: Int) {
        if stepperView?.value == 0 {
            button.isHidden = false
            stepperView?.isHidden = true
        }
        
    }
}

