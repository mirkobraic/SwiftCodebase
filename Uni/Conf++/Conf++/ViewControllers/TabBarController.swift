//
//  TabBarController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 25.01.2022..
//

import UIKit
//import UBottomSheet
import OverlayContainer

class TabBarController: UITabBarController, UITabBarControllerDelegate, OverlayContainerViewControllerDelegate {
    
    let mapContainer = OverlayContainerViewController()
    
    enum OverlayNotch: Int, CaseIterable {
        case minimum, maximum
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return OverlayNotch.allCases.count
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        heightForNotchAt index: Int,
                                        availableSpace: CGFloat) -> CGFloat {
        switch OverlayNotch.allCases[index] {
            case .maximum:
            return availableSpace * 0.85
            case .minimum:
            return availableSpace * 0.12
        }
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        willStartDraggingOverlay overlayViewController: UIViewController) {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.isTranslucent = false
        tabBar.tintColor = #colorLiteral(red: 0.2951556444, green: 0.6126813293, blue: 0.9699079394, alpha: 1)
        tabBar.backgroundColor = .tertiarySystemBackground
        
        
        let mapVC = MapViewController()
        let mapTBI = UITabBarItem(title: "Conference Map",
                                  image: UIImage(systemName: "map"),
                                  selectedImage: UIImage(systemName: "map.fill"))
        mapVC.tabBarItem = mapTBI
        
        let mapDetailsVC = MapDetailsViewController()
        mapDetailsVC.view.layer.cornerRadius = 20
        
        mapContainer.delegate = self
        mapContainer.viewControllers = [
            mapVC,
            mapDetailsVC
        ]
        mapContainer.view.clipsToBounds = true
        mapContainer.tabBarItem = mapTBI
        mapContainer.drivingScrollView = mapDetailsVC.tableView
     
        let cardVC = BussinesCardTableViewController()
        let cardTBI = UITabBarItem(title: "Business cards",
                                   image: UIImage(systemName: "lanyardcard"),
                                   selectedImage: UIImage(systemName: "lanyardcard.fill"))
        cardVC.tabBarItem = cardTBI
        
        let controllers = [mapContainer, UINavigationController(rootViewController: cardVC)]
        self.viewControllers = controllers
    }

    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
}
