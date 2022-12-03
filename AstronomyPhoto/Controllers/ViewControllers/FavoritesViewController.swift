//
//  FavoritesViewController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    var favorites: [APOD] {
        return APODController.shared.favorites
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
    
    // MARK: - Helpers
    
    func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "apodCell", for: indexPath) as? APODTableViewCell else { return UITableViewCell() }
        
        cell.apod = favorites[indexPath.row]
        
        return cell
    }
    
}
