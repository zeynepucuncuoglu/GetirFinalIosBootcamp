//
//  HorizontalStepperView.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 24.04.2024.
//

import Foundation
import UIKit
protocol HorizontalStepperDelegate: AnyObject {
    func stepperValueDidChange(to value: Int)
}




class HorizontalStepperView: UIView {
 

    let stackView = UIStackView()
    let incrementButton = UIButton()
    let decrementButton = UIButton()
    let valueLabel = UILabel()
    let transparentBlue = UIColor.blue.withAlphaComponent(0.0)
    let getirPurple = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
    weak var delegate: HorizontalStepperDelegate?
      
      var value: Int = 0 {
          didSet {
              valueLabel.text = "\(value)"
              delegate?.stepperValueDidChange(to: value)
          }
      }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        setupStackView()
        setupDecrementButton()
        setupValueLabel()
        setupIncrementButton()
     
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupIncrementButton() {
        incrementButton.setTitle("+", for: .normal)
        incrementButton.setTitleColor(getirPurple, for: .normal)
        incrementButton.addTarget(self, action: #selector(increment), for: .touchUpInside)
        incrementButton.layer.cornerRadius = 8
        incrementButton.layer.shadowColor = UIColor.black.cgColor
        incrementButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        incrementButton.layer.shadowOpacity = 0.5
        incrementButton.layer.shadowRadius = 2
        incrementButton.backgroundColor = .white
        incrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        stackView.addArrangedSubview(incrementButton)
        
    }
    
    private func setupDecrementButton() {
        let trashImage = UIImage(systemName: "trash")?.withTintColor(getirPurple, renderingMode: .alwaysOriginal)
        decrementButton.setImage(trashImage, for: .normal)
        decrementButton.setTitleColor(getirPurple, for: .normal)
        decrementButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)
        decrementButton.backgroundColor = .white
        decrementButton.layer.cornerRadius = 8
        decrementButton.layer.shadowColor = UIColor.black.cgColor
        decrementButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        decrementButton.layer.shadowOpacity = 0.5
        decrementButton.layer.shadowRadius = 2
        decrementButton.layer.shadowOpacity = 0.5
        decrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        stackView.addArrangedSubview(decrementButton)
    }
    
    
    private func setupValueLabel() {
        valueLabel.text = "\(value)"
        valueLabel.textAlignment = .center
        valueLabel.textColor = .white
        valueLabel.backgroundColor = getirPurple
        
        stackView.addArrangedSubview(valueLabel)
        
    }
    
    @objc private func increment() {
        value += 1
        if value == 1 {
            showIcon()
        }
        hideIcon()
    }
    
    @objc private func decrement() {
        value -= 1
        if value == 1 {
            showIcon()
        }
        hideIcon()
    }
    
    func showIcon(){
        let trashImage = UIImage(systemName: "trash")?.withTintColor(getirPurple, renderingMode: .alwaysOriginal)
        decrementButton.setImage(trashImage, for: .normal)
        decrementButton.setTitle(nil, for: .normal)
    }
    func hideIcon(){
        decrementButton.setTitle("-", for: .normal)
        decrementButton.setTitleColor(getirPurple, for: .normal)
        decrementButton.setImage(nil, for: .normal)
    }
}

