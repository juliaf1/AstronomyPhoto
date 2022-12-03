//
//  CustomTabBar.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

enum TabBarItemIndex: Int {
    case today = 0
    case search = 1
    case favorites = 2
}

class CustomTabBar: UITabBar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = sizeThatFits.height + 10
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 12
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = Colors.black?.cgColor
        self.layer.shadowOpacity = 0.3
    }

}
