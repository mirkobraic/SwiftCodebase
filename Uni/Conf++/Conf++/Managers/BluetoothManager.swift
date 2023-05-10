//
//  BluetoothManager.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 26.01.2022..
//

import CoreLocation
import Foundation

protocol BluetoothManagerDelegate: AnyObject {
    func connectionChanged(isConnected: Bool)
    func rangeChanged(range: CLProximity, accuracy: CLLocationAccuracy)
}

class BluetoothManager: NSObject, CLLocationManagerDelegate {
    static let shared = BluetoothManager()
    
    var locationManager = CLLocationManager()
    var isConnected = false
    private var currentProximity: CLProximity = .unknown
    var delegates: [BluetoothManagerDelegate] = []
    
    var wasSpicaCardAdded = false
    
    private override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        startScanning()
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: Constants.Beacon.macID)!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 0, minor: 0, identifier: "MyBeacon")
        beaconRegion.notifyOnExit = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyEntryStateOnDisplay = true
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: uuid, major: 0, minor: 0)
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        locationManager.startRangingBeacons(satisfying: beaconConstraint)
        locationManager.startUpdatingLocation()
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
    
    func scheduleNotification(entered: Bool) {
        let keyword = entered ? "Entered" : "Left"
        NetworkManager.shared.getLocationMetadata(locationID: Constants.Locations.bigRoom) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    var nameFound = false
                    for detail in details {
                        if detail.key == "Name" {
                            NotificationManager.shared.pushNotification(title: "\(keyword) the \(detail.value)", message: "")
                            nameFound = true
                            break
                        }
                    }
                    if (nameFound == false) {
                        NotificationManager.shared.pushNotification(title: "\(keyword) the room", message: "")
                    }
                case .failure:
                    NotificationManager.shared.pushNotification(title: "\(keyword) the room", message: "")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("Range changed")
        let oldProximity = currentProximity
        if let beacon = beacons.first {
            currentProximity = beacon.proximity
            delegates.forEach { $0.rangeChanged(range: beacon.proximity, accuracy: beacon.accuracy) }
        } else {
            currentProximity = .unknown
            delegates.forEach { $0.rangeChanged(range: .unknown, accuracy: CLLocationAccuracy(0)) }
        }
        
        
        if oldProximity == .unknown, currentProximity != .unknown, isConnected == false {
            isConnected = true
            delegates.forEach { $0.connectionChanged(isConnected: true) }
            
            scheduleNotification(entered: true)
            NetworkManager.shared.postUserEntered(location: Constants.Locations.bigRoom, userID: Constants.Users.mirkoBraic)
        } else if oldProximity != .unknown, currentProximity == .unknown, isConnected == true {
            isConnected = false
            delegates.forEach { $0.connectionChanged(isConnected: false) }
            
            scheduleNotification(entered: false)
            NetworkManager.shared.postUserLeft(location: Constants.Locations.bigRoom, userID: Constants.Users.mirkoBraic)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did enter region")
        guard isConnected == false else { return }
        isConnected = true
        delegates.forEach { $0.connectionChanged(isConnected: true) }
        
        scheduleNotification(entered: true)
        NetworkManager.shared.postUserEntered(location: Constants.Locations.bigRoom, userID: Constants.Users.mirkoBraic)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Did leave region")
        guard isConnected == true else { return }
        isConnected = false
        delegates.forEach { $0.connectionChanged(isConnected: false) }
        
        scheduleNotification(entered: false)
        NetworkManager.shared.postUserLeft(location: Constants.Locations.bigRoom, userID: Constants.Users.mirkoBraic)
    }
}
