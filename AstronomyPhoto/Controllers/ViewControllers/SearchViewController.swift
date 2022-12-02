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
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        layoutViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
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
    
    func configureViews() {
        startDateTextField.delegate = self
        endDateTextField.delegate = self
    }

}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""

        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text,
               text.isEmpty {
            textField.text = "MM/DD/YY"
        }
        return true
    }
    
}
