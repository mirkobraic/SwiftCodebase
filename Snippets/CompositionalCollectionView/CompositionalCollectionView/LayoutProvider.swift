//
//  LayoutProvider.swift
//  CompositionalCollectionView
//
//  Created by Mirko Braic on 11.05.2023..
//

import UIKit
import SwiftUI

class LayoutProvider {
    static let numberOfSections = 9
    
    private static let numberOfItemsInSection = [3, 8, 3, 4, 17, 8, 9, 19, 16, 10]
    
    static func getNumberOfItemsForSection(section: Int) -> Int {
        return numberOfItemsInSection[section]
    }
    
    static func configureLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                return configureFirstSection()
            } else if sectionNumber == 1 {
                return configureSecondSection()
            } else if sectionNumber == 2 {
                return configureThirdSection()
            } else if sectionNumber == 3 {
                return configureFourthSection()
            } else if sectionNumber == 4 {
                return configureFifthSection()
            } else if sectionNumber == 5 {
                return configureSixthSection { offset in
                    print(offset)
                }
            } else if sectionNumber == 6 {
                return configureSeventhSection(environment: environment)
            } else if sectionNumber == 7 {
                return configureEightSection()
            } else if sectionNumber == 8 {
                return configureNinthSection()
            } else {
                return configureTenthSection()
            }
        }
        
        // no need to register it in ViewController, we can do it directly on the layout
        layout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: "background")
        return layout
    }
    
    private static func configureFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 2
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
    
    private static func configureSecondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 16
        item.contentInsets.bottom = 16
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: SectionHeader.defaultElementKind,
            alignment: .topLeading)
        sectionHeader.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [
            sectionHeader
        ]
        
        
        return section
    }
    
    private static func configureThirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 16
        item.contentInsets.leading = 16
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(125))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private static func configureFourthSection() -> NSCollectionLayoutSection {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                        elementKind: Badge.defaultElementKind,
                                                        containerAnchor: badgeAnchor)
        
        let bannerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.04), heightDimension: .absolute(30))
        let bannerAnchor = NSCollectionLayoutAnchor(edges: [.bottom], absoluteOffset: CGPoint(x: 0, y: 5))
        let banner = NSCollectionLayoutSupplementaryItem(layoutSize: bannerSize, elementKind: Banner.defaultElementKind, containerAnchor: bannerAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge, banner])
        item.contentInsets.trailing = 16
        item.contentInsets.bottom = 16
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        section.contentInsets.top = 16
        
        return section
    }
    
    private static func configureFifthSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 10
        
        return section
    }
    
    private static func configureSixthSection(scrollOffset: @escaping ((CGFloat) -> Void)) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 16, bottom: 2, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets.top = 16
        section.contentInsets.bottom = 16
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            scrollOffset(offset.x)
        }
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: "background")
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        section.decorationItems = [backgroundItem]

        return section
    }
    
    private static func configureSeventhSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var listConf = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConf.headerMode = .supplementary
        let section = NSCollectionLayoutSection.list(using: listConf, layoutEnvironment: environment)
        
        return section
    }
    
    private static func configureEightSection() -> NSCollectionLayoutSection {
        let leftItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let leftItem = NSCollectionLayoutItem(layoutSize: leftItemSize)
        leftItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let rightItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
        let rightItem = NSCollectionLayoutItem(layoutSize: rightItemSize)
        rightItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let rightGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize: rightGroupSize, subitems: [rightItem])
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leftItem, rightGroup, rightGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    private static func configureNinthSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 2, bottom: 16, trailing: 2)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10
        
        // TODO: scale not working well on bounce
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                print("\(item.indexPath.row) - Scale: \(scale)")
                
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        return section
    }
    
    private static func configureTenthSection()  -> NSCollectionLayoutSection {
        // TODO: do a waterfall
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 2
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
}
