//
//  SearchViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchCard: UIView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViews()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    func layoutViews() {
        // Round card corners + shadow
        searchCard.layer.cornerRadius = 8
        searchCard.layer.shadowOffset = CGSize(width: 1, height: 1)
        searchCard.layer.shadowRadius = 5
        searchCard.layer.shadowColor = Colors.black?.cgColor
        searchCard.layer.shadowOpacity = 0.3
    }

}
