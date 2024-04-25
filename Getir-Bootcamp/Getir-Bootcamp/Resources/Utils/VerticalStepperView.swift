//
//  VerticalStepperView.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 18.04.2024.
//
import UIKit

protocol StepperDelegate: AnyObject {
    func stepperValueChanged(newValue: Int)
}


class VerticalStepperView: UIView {
    weak var delegate: StepperDelegate?

    let stackView = UIStackView()
    let incrementButton = UIButton()
    let decrementButton = UIButton()
    let valueLabel = UILabel()
    let transparentBlue = UIColor.blue.withAlphaComponent(0.0)
    let getirPurple = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
    var value: Int = 0 {
        didSet {
            valueLabel.text = "\(value)"
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
        setupIncrementButton()
        setupValueLabel()
        setupDecrementButton()
        
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
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
        decrementButton.setTitle("-", for: .normal)
        decrementButton.setTitleColor(transparentBlue, for: .normal)
        decrementButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)
        decrementButton.layer.cornerRadius = 8
        decrementButton.layer.shadowColor = UIColor.black.cgColor
        decrementButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        decrementButton.layer.shadowOpacity = 0.5
        decrementButton.layer.shadowRadius = 2
        decrementButton.layer.shadowOpacity = 0.0
        decrementButton.isEnabled = false
    
        stackView.addArrangedSubview(decrementButton)
    }
    
    
    private func setupValueLabel() {
        valueLabel.text = "\(value)"
        valueLabel.textAlignment = .center
        valueLabel.textColor = transparentBlue
        valueLabel.backgroundColor = transparentBlue
        
        stackView.addArrangedSubview(valueLabel)
        
    }
    
    @objc private func increment() {

        value += 1
        visibleDecrement()
        delegate?.stepperValueChanged( newValue: value)
    }
    
    @objc private func decrement() {
        if value > 0 {
            value -= 1
        }
        if value == 0 {
            hiddenDecrement()
        }
        delegate?.stepperValueChanged( newValue: value)
    
      
    }
    
    func hiddenDecrement(){
        decrementButton.setTitleColor(transparentBlue, for: .normal)
        valueLabel.textColor = transparentBlue
        valueLabel.backgroundColor = transparentBlue
        decrementButton.layer.shadowOpacity = 0.0
        decrementButton.isEnabled = false
    }
    
    func visibleDecrement(){
        decrementButton.setTitleColor(.blue, for: .normal)
        decrementButton.layer.shadowOpacity = 0.5
        decrementButton.backgroundColor = .white
        valueLabel.backgroundColor = getirPurple
        decrementButton.isEnabled = true
        valueLabel.textColor = .white
    }

}

