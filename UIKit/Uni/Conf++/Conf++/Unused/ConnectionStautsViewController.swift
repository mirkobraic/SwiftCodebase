//
//  ConnectionViewController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 25.01.2022..
//

import CoreLocation
import UIKit

class ConnectionViewController: UIViewController, BluetoothManagerDelegate {
    @IBOutlet var connectionStatusLabel: UILabel!
    @IBOutlet var distanceReadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Connection Status"
        BluetoothManager.shared.delegates.append(self)
    }

    
    func connectionChanged(isConnected: Bool) {
        if isConnected {
            connectionStatusLabel.text = "CONNECTED"
        } else {
            connectionStatusLabel.text = "DISCONNECTED"
        }
    }
    
    func rangeChanged(range: CLProximity, accuracy: CLLocationAccuracy) {
        UIView.animate(withDuration: 1) {
            switch range {
            case .far:
                self.view.backgroundColor = UIColor(red: 0.2, green: 0.9, blue: 0.2, alpha: 1)
                self.distanceReadingLabel.text = "FAR"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReadingLabel.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1)
                self.distanceReadingLabel.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = UIColor.systemBackground
                self.distanceReadingLabel.text = "UNKNOWN"
            }
        }
    }
}
