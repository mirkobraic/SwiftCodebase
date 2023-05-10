//
//  RoomDetailsTableViewController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 25.01.2022..
//

import UIKit

class RoomDetailsTableViewController: UITableViewController {
    var roomDetails: [RoomDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Room details"
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchRoomDetails()
    }
    
    func fetchRoomDetails() {
        NetworkManager.shared.getLocationMetadata(locationID: Constants.Locations.bigRoom) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.roomDetails = details
                    self.tableView.reloadData()
                case .failure:
                    break
                }
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseIdentifier")

        let entry = roomDetails[indexPath.row]
        cell.textLabel?.text = entry.key
        cell.detailTextLabel?.text = entry.value

        return cell
    }
}
