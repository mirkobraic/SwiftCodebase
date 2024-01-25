//
//  ConnectionViewController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 25.01.2022..
//

import CoreLocation
import UIKit

class ConnectionStautsViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var connectionStatusLabel: UILabel!
    @IBOutlet var distanceReadingLabel: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Connection Status"
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: Constants.Beacon.macID)!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReadingLabel.text = "FAR"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReadingLabel.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReadingLabel.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReadingLabel.text = "UNKNOWN"
            }
        }
    }
}
