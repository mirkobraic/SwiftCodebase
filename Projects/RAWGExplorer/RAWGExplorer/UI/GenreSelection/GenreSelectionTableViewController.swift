//
//  GenreSelectionTableViewController.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import UIKit
import FirebaseAnalytics

protocol GenreSelectionDelegate: AnyObject {
    func selectedGenres(ids: [Int])
}

class GenreSelectionTableViewController: UITableViewController {
    var genres: [Genre] = []
    var selectedGenresIds = UserDefaults.selectedGenresIds
    var changesMade = false
    
    weak var genreSelectionDelegate: GenreSelectionDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "genreCell")
        
        navigationController?.presentationController?.delegate = self
        isModalInPresentation = true
        
        title = "Select a genre"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem?.isEnabled = !selectedGenresIds.isEmpty
        
        fethcGenres()
    }
    
    private func fethcGenres() {
        NetworkManager.shared.fetchGenres { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.genres = response.results
                    self.tableView.reloadData()
                case .failure:
                    self.presentAlertVC(title: "Error", message: "Unable to fetch genres")
                }
            }
        }
    }
    
    @objc private func handleDismiss() {
        if selectedGenresIds.isEmpty == false {
            if changesMade {
                genreSelectionDelegate?.selectedGenres(ids: selectedGenresIds)
                UserDefaults.selectedGenresIds = selectedGenresIds
            }
            dismiss(animated: true)
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension GenreSelectionTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath)
        let genre = genres[indexPath.row]
        
        if selectedGenresIds.contains(genre.id) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = genre.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        changesMade = true
        
        let cell = tableView.cellForRow(at: indexPath)
        let selectedGenre = genres[indexPath.row]
        
        if selectedGenresIds.contains(selectedGenre.id) {
            // cell deselected
            selectedGenresIds.removeAll { $0 == selectedGenre.id }
            cell?.accessoryType = .none
            
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
              AnalyticsParameterItemID: "id-\(selectedGenre.id)",
              AnalyticsParameterItemName: selectedGenre.name
            ])
        } else {
            // cell selected
            selectedGenresIds.append(selectedGenre.id)
            cell?.accessoryType = .checkmark
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = !selectedGenresIds.isEmpty
    }
}

// MARK: UIAdaptivePresentationControllerDelegate
extension GenreSelectionTableViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        handleDismiss()
    }
}
