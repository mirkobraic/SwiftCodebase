//
//  CoinImageViewModel.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 25.07.2023..
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false

    private let coin: CoinModel
    private let dataService: CoinImageService
    private var subscriptions = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscribers()
        isLoading = true
    }

    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] image in
                self?.image = image
                self?.isLoading = false
            }.store(in: &subscriptions)
    }
}
