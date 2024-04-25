//
//  ActivityIndicatorView.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import UIKit

class CustomActivityIndicatorView: UIView {
    
    // MARK: - Properties
    
    private let circleLayer = CAShapeLayer()
    private let imageView = UIImageView()
    private var isAnimating = false
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        // Configure circle layer
        let getirPurple = UIColor(red: 93/255, green: 62/255, blue: 188/255, alpha: 1.0)
        let cgColor = getirPurple.cgColor
        let radius = min(bounds.width, bounds.height) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = cgColor
        circleLayer.lineWidth = 2.0
        circleLayer.strokeEnd = 0.8
        
        layer.addSublayer(circleLayer)
    }
    
    // MARK: - Animation
    //TODO: add image
    func startAnimating() {
        if isAnimating {
            return
        }
        
        print("Animating...")
        isAnimating = true
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (completed) in
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations:{
                self.transform = CGAffineTransform(rotationAngle: 0)
            }) { (completed) in
                if self.isAnimating {
                    self.startAnimating()
                }
            }
        }
    }
    
    func stopAnimating() {
        isAnimating = false
    }
}
