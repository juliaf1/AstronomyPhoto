//
//  UIView+Extension.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

extension UIView {
    
    func roundCorners(radius: Double) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func lightShadow() {
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = Colors.black?.cgColor
        self.layer.shadowOpacity = 0.8
    }
    
}
