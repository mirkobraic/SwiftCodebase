//
//  MapContainerViewController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 13.02.2022..
//

import Foundation

import UIKit

final class MapContainerViewController: BottomSheetContainerViewController
<MapViewController, MapDetailsViewController> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
    }
    
}
