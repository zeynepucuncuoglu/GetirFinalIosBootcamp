//
//  BaseViewController.swift
//  Getir-Bootcamp
//
//  Created by Zeynep Üçüncüoğlu on 15.04.2024.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        
    }
    // TODO: Custom Alert View yap
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the "Tekrar Dene" button
        let retryAction = UIAlertAction(title: "Tekrar Dene", style: .default) { action in
            // Handle retry action if needed
        }
        
        // Create a purple background for the button
        let purpleBackgroundImage = UIImage()
        
        // Apply the purple background to the button
        retryAction.setValue(purpleBackgroundImage, forKey: "image")
        
        // Add the button to the alert
        alert.addAction(retryAction)
        
        // Present the alert on the main queue
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

}
