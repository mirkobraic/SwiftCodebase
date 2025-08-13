//
//  FeedListViewController+CompositionalLayout.swift
//  RSSFeed
//
//  Created by Mirko Braic on 05.01.2024..
//

import UIKit

extension FeedListViewController {

    func plainList(swipeActionDelegate: CollectionViewSwipeActionDelegate?) -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let trailingAction = { [weak swipeActionDelegate] indexPath in
            return swipeActionDelegate?.trailingAction(at: indexPath)
        }
        let leadingAction = { [weak swipeActionDelegate] indexPath in
            return swipeActionDelegate?.leadingAction(at: indexPath)
        }
        configuration.trailingSwipeActionsConfigurationProvider = trailingAction
        configuration.leadingSwipeActionsConfigurationProvider = leadingAction
        configuration.backgroundColor = .rsBackground
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
