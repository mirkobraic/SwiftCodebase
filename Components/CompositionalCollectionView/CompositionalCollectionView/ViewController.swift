//
//  ViewController.swift
//  CompositionalCollectionView
//
//  Created by Mirko Braic on 11.05.2023..
//

import UIKit
import SwiftUI

class ViewController: UICollectionViewController {
    let sectionColors = [UIColor.red, .blue, .orange, .green, .purple, .brown, .white, .gray, .magenta, .systemIndigo]
    
    init() {
        super.init(collectionViewLayout: LayoutProvider.configureLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(collectionViewLayout: LayoutProvider.configureLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.defaultReuseIdentifier)
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: UICollectionViewListCell.defaultReuseIdentifier)
        collectionView.register(LabeledCell.self, forCellWithReuseIdentifier: LabeledCell.defaultReuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: SectionHeader.defaultElementKind, withReuseIdentifier: SectionHeader.defaultReuseIdentifier)
        collectionView.register(Badge.self, forSupplementaryViewOfKind: Badge.defaultElementKind, withReuseIdentifier: Badge.defaultReuseIdentifier)
        collectionView.register(Banner.self, forSupplementaryViewOfKind: Banner.defaultElementKind, withReuseIdentifier: Banner.defaultReuseIdentifier)

        collectionView.register(UICollectionViewListCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "tableViewHeader")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return LayoutProvider.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        LayoutProvider.getNumberOfItemsForSection(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabeledCell.defaultReuseIdentifier, for: indexPath) as! LabeledCell
            cell.backgroundColor = sectionColors[indexPath.section]
            cell.label.text = String(repeating: "=", count: Int.random(in: 2...8))

            return cell
        } else if indexPath.section == 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewListCell.defaultReuseIdentifier, for: indexPath) as! UICollectionViewListCell
            var content = cell.defaultContentConfiguration()
            content.text = "Item \(indexPath.row)"
            cell.contentConfiguration = content
            let customImageView = UICellAccessory.CustomViewConfiguration(customView: UIImageView(image: .actions), placement: .leading())
            cell.accessories = [.disclosureIndicator(), .checkmark(), .customView(configuration: customImageView)]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.defaultReuseIdentifier, for: indexPath)
            cell.backgroundColor = sectionColors[indexPath.section]
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case SectionHeader.defaultElementKind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.defaultReuseIdentifier, for: indexPath) as! SectionHeader
            return header
            
        case Badge.defaultElementKind:
            let badge = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Badge.defaultReuseIdentifier, for: indexPath) as! Badge
            badge.isHidden = Bool.random()
            return badge
            
        case Banner.defaultElementKind:
            let banner = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Banner.defaultReuseIdentifier, for: indexPath) as! Banner
            banner.label.text = "Item: \(indexPath.row)"
            return banner
            
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "tableViewHeader", for: indexPath) as! UICollectionViewListCell
            var content = header.defaultContentConfiguration()
            content.text = "HEADER"
            header.contentConfiguration = content
            return header
        default:
            fatalError("Element kind \"\(kind)\" not supported")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = UIViewController()
        controller.view.backgroundColor = sectionColors[indexPath.section]
        present(controller, animated: true)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: ViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
        
        typealias UIViewControllerType = UIViewController
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
