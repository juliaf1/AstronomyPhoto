//
//  SearchViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    let loadingVC = LoadingViewController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchCard: UIView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        layoutViews()
        hideViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideViews()
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
        tableView.delegate = self
        tableView.dataSource = self
        
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
        setUpDismissKeyboardTap()
    }
    
    func hideViews() {
        titleLabel.layer.opacity = 0
        searchCard.layer.opacity = 0
        
        titleLabel.isHidden = true
        searchCard.isHidden = true
    }
    
    func displayViews() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            self.titleLabel.isHidden = false
            self.searchCard.isHidden = false
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut]) {
            self.titleLabel.layer.opacity = 1
            self.searchCard.layer.opacity = 1
        }
    }
    
    func setUpDismissKeyboardTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndSearch))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardAndSearch() {
        if startDateTextField.isFirstResponder || endDateTextField.isFirstResponder {
            view.endEditing(true)
            searchResults()
        }
    }
    
    func searchResults() {
        guard let startDateString = startDateTextField.text,
              let endDateString = endDateTextField.text,
              startDateString != "MM/DD/YYYY",
              endDateString != "MM/DD/YYYY" else {
            return
        }

        guard startDateString.validDate,
              endDateString.validDate else {
            presentAlert(title: "Ops, error fetching results", message: "Date must be between Jun 16, 1995 and \(Date().toString())")
            return
        }

        let startDate = startDateString.toDate(formatter: .forms)
        let endDate = endDateString.toDate(formatter: .forms)
        
        self.presentLoading(loadingVC)
        
        APODController.shared.fetchAPODs(startDate: startDate, endDate: endDate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableView.reloadData()
                    self.removeLoading(self.loadingVC, completion: {})
                case .failure(let error):
                    self.removeLoading(self.loadingVC) {
                        self.presentAlert(title: "Ops, error fetching results", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toDetailVC",
              let destination = segue.destination as? APODViewController,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        let apod = APODController.shared.results[indexPath.row]
        destination.apod = apod
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text,
               text == "MM/DD/YYYY"  {
            textField.text = ""
        }

        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text,
               text.isEmpty {
            textField.text = "MM/DD/YYYY"
        }
        
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }

        guard let text = textField.text,
              text.count < 10 else {
            return false
        }
        
        if text.count == 2 || text.count == 5 {
            textField.text = text + "/"
        }
        
        return true
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APODController.shared.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "apodCell", for: indexPath) as? APODTableViewCell else { return UITableViewCell() }
        
        let apod = APODController.shared.results[indexPath.row]
        cell.apod = apod
        
        return cell
    }
    
}
