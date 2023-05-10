//
//  MapViewController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 25.01.2022..
//

import CoreLocation
import UIKit

class MapViewController: UIViewController, BluetoothManagerDelegate {
    @IBOutlet var mapImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Conference Map"
        BluetoothManager.shared.delegates.append(self)
        if BluetoothManager.shared.isConnected {
            mapImageView.image = UIImage(named: "mapSelected")
        } else {
            mapImageView.image = UIImage(named: "map")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BluetoothManager.shared.delegates.append(self)
        if BluetoothManager.shared.isConnected {
            mapImageView.image = UIImage(named: "mapSelected")
        } else {
            mapImageView.image = UIImage(named: "map")
        }
        
    }
    
    @IBAction func didTapOnRoom(_ sender: UITapGestureRecognizer) {
        let roomDetailsVC = RoomDetailsTableViewController()
        let navController = UINavigationController(rootViewController: roomDetailsVC)
        present(navController, animated: true)
    }
    
    func connectionChanged(isConnected: Bool) {
        if (isConnected && BluetoothManager.shared.wasSpicaCardAdded == false) {
            let tbc = UIApplication.shared.windows.first!.rootViewController as! TabBarController
            tbc.tabBar.items?.last?.badgeValue = "1"
            BluetoothManager.shared.wasSpicaCardAdded = true
        }
        
        UIView.transition(with: mapImageView, duration: 0.4, options: .transitionCrossDissolve) {
            if isConnected {
                self.mapImageView.image = UIImage(named: "mapSelected")
            } else {
                self.mapImageView.image = UIImage(named: "map")
            }
        }
    }
    
    func rangeChanged(range: CLProximity, accuracy: CLLocationAccuracy) {
        // nothing
    }
}
