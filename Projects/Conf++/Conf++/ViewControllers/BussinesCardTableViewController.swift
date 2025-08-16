//
//  BussinesCardTableViewController.swift
//  Conf++
//
//  Created by Tomislav Jurić-Arambašić on 13.02.2022..
//

import UIKit
import CoreLocation

class BussinesCardTableViewController: UITableViewController, BluetoothManagerDelegate {
    func connectionChanged(isConnected: Bool) {
        if (isConnected && BluetoothManager.shared.wasSpicaCardAdded == false) {
            addSpicaBusinessCard()
            tableView.insertSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func rangeChanged(range: CLProximity, accuracy: CLLocationAccuracy) {
        // nothing
    }
    
    var businessCards: [BusinessCardModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Business cards"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        BluetoothManager.shared.delegates.insert(self, at: 0)
        
        tableView.register(UINib(nibName: "BusinessCardTableViewCell", bundle: .main), forCellReuseIdentifier: "cardCell")
        tableView.sectionHeaderHeight = 0
        tableView.rowHeight = 160
        
        fetchBusinessCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarItem.badgeValue = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarItem.badgeValue = nil
    }
    
    func fetchBusinessCards() {
        businessCards.append(BusinessCardModel(
            companyName: "Company 1",
            companyLogo: "infobip",
            phoneNumber: "+385 11 111 1111",
            website: "www.company1.com",
            linkedin: "",
            color: .orange,
            imageBackgroundColor: .white,
            fontColor: .black))
        
        businessCards.append(BusinessCardModel(
            companyName: "Company 2",
            companyLogo: "evolutio",
            phoneNumber: "+385 22 222 2222",
            website: "www.company2.com",
            linkedin: "",
            color: .white,
            imageBackgroundColor: .black,
            fontColor: .black))
        
        businessCards.append(BusinessCardModel(
            companyName: "Company 3",
            companyLogo: "ericsson",
            phoneNumber: "+385 33 333 3333",
            website: "www.company3.com",
            linkedin: "",
            color: UIColor(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),
            imageBackgroundColor: .white,
            fontColor: .white))
        if (BluetoothManager.shared.wasSpicaCardAdded) {
            addSpicaBusinessCard()
        }
    }
    
    func addSpicaBusinessCard() {
        businessCards.insert(BusinessCardModel(
            companyName: "Spica",
            companyLogo: "spica",
            phoneNumber: "+385 98 334 9550",
            website: "https://www.spica.hr",
            linkedin: "",
            color: .red,
            imageBackgroundColor: .white,
            fontColor: .white), at: 0)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return businessCards.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! BusinessCardTableViewCell
        let card = businessCards[indexPath.section]
        
        cell.backView.backgroundColor = card.color
        cell.halfCircleView.backgroundColor = card.imageBackgroundColor
        cell.logoImageView.image = UIImage(named: card.companyLogo)
        cell.titleLabel?.text = card.companyName
        cell.titleLabel.textColor = card.fontColor
        cell.websiteTextView.text = card.website
        cell.websiteTextView.tintColor = card.fontColor
        cell.phoneTextView.text = card.phoneNumber
        cell.phoneTextView.tintColor = card.fontColor
        
        return cell
    }
}
