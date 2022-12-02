//
//  UIViewController+Extension.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let dismissAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(dismissAction)
        
        present(alert, animated: true)
    }
    
}
