//
//  MapDetailsViewController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 13.02.2022..
//

import UIKit
import CoreLocation

class MapDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pillView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    let currentRoomCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    
    let connectionStatusCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let signalStrengthCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let distanceCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    
    var headers = ["Connection Info"]
    var cells: [[UITableViewCell]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        currentRoomCell.textLabel?.text = "Location name"
//        currentRoomCell.detailTextLabel?.text = "-"
        
        connectionStatusCell.textLabel?.text = "Connection status"
        connectionStatusCell.detailTextLabel?.text = "Disconnected"
        signalStrengthCell.textLabel?.text = "Signal strength"
        signalStrengthCell.detailTextLabel?.text = "-"
        distanceCell.textLabel?.text = "Distance from beacon"
        distanceCell.detailTextLabel?.text = "-"
        
        cells.append([connectionStatusCell, signalStrengthCell, distanceCell])
//        cells.append([currentRoomCell])
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        
        pillView.layer.cornerRadius = 3
        
        BluetoothManager.shared.delegates.append(self)
        
        searchBar.delegate = self
        
        fetchRoomDetails()
    }
    
    func fetchRoomDetails() {
        NetworkManager.shared.getLocationMetadata(locationID: Constants.Locations.bigRoom) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.cells.append([])
                    self.headers.append("Current Location")
                    for detail in details {
                        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                        cell.textLabel?.text = detail.key
                        cell.detailTextLabel?.text = detail.value
                        self.cells[1].append(cell)
                    }

                    UIView.transition(with: self.tableView, duration: 0.2, options: .transitionCrossDissolve) {
                        self.tableView.reloadData()
                    }
                case .failure:
                    break
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let tbc = UIApplication.shared.windows.first!.rootViewController as! TabBarController
        tbc.mapContainer.moveOverlay(toNotchAt: 1, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func connectionChanged(isConnected: Bool) {
        if isConnected {
            connectionStatusCell.detailTextLabel?.text = "Connected"
        } else {
            connectionStatusCell.detailTextLabel?.text = "Disconnected"
            currentRoomCell.detailTextLabel?.text = "-"
            signalStrengthCell.detailTextLabel?.text = "-"
            distanceCell.detailTextLabel?.text = "-"
        }
    }
    
    func rangeChanged(range: CLProximity, accuracy: CLLocationAccuracy) {
        switch range {
        case .far:
            signalStrengthCell.detailTextLabel?.text = "Poor"
            distanceCell.detailTextLabel?.text = "\(round(accuracy * 100) / 100)m"
        case .near:
            signalStrengthCell.detailTextLabel?.text = "Good"
            distanceCell.detailTextLabel?.text = "\(round(accuracy * 100) / 100)m"
        case .immediate:
            signalStrengthCell.detailTextLabel?.text = "Excelent"
            distanceCell.detailTextLabel?.text = "\(round(accuracy * 100) / 100)m"
        default:
            signalStrengthCell.detailTextLabel?.text = "-"
            distanceCell.detailTextLabel?.text = "-"
        }
    }
}
