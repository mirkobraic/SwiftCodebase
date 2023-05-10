//
//  GamesTableViewController.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import UIKit

class GamesTableViewController: UITableViewController {
    var games: [Game] = []
    var selectedGenresIds = UserDefaults.selectedGenresIds
    let pageSize = 25
    var nextPageUrl: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Games"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(presentGenreSelectionVC))
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "gameCell")
        
        if !UserDefaults.initialGenreSelectionDone {
            UserDefaults.initialGenreSelectionDone = true
            presentGenreSelectionVC()
        } else {
            fetchGamesForSelectedGenres()
        }
    }
    
    @objc private func presentGenreSelectionVC() {
        let vc = GenreSelectionTableViewController()
        vc.genreSelectionDelegate = self
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .pageSheet
        present(nc, animated: true)
    }
    
    private func fetchGamesForSelectedGenres() {
        NetworkManager.shared.fetchGames(forGenres: selectedGenresIds, pageSize: pageSize) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.games = response.results
                    self.nextPageUrl = response.next
                    self.tableView.animatedReload()
                case .failure:
                    self.presentAlertVC(title: "Error", message: "Unable to fetch games")
                }
            }
        }
    }
    
    private func fetchNextPage() {
        guard let nextPageUrl else {
            fetchGamesForSelectedGenres()
            return
        }
        
        NetworkManager.shared.fetchGames(with: nextPageUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    var indexPaths: [IndexPath] = []
                    for i in self.games.count..<self.games.count + self.pageSize {
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    self.games.append(contentsOf: response.results)
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.nextPageUrl = response.next
                case .failure:
                    self.presentAlertVC(title: "Error", message: "Unable to fetch games")
                }
            }
        }
    }
    
    private func formatSubtitle(forGenres genres: [Genre]) -> NSAttributedString {
        let subtitleString = genres.map { String($0.name) }.joined(separator: ", ")
        let formattedString = NSMutableAttributedString(string: subtitleString)
        
        for genre in genres {
            if selectedGenresIds.contains(genre.id) {
                let range = (subtitleString as NSString).range(of: genre.name)
                formattedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
            }
        }
        return formattedString
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension GamesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        let game = games[indexPath.row]
        
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.attributedText = formatSubtitle(forGenres: game.genres)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GameDetailsViewController(gameId: games[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= games.count - 1 {
            fetchNextPage()
        }
    }
}

// MARK: SelectedGenresDelegate
extension GamesTableViewController: GenreSelectionDelegate {
    func selectedGenres(ids: [Int]) {
        selectedGenresIds = ids
        fetchGamesForSelectedGenres()
    }
}
