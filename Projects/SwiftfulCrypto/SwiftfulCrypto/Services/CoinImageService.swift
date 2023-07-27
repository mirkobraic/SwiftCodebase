//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 25.07.2023..
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    @Published var image: UIImage? = nil

    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id

        getCoinImage()
    }

    private func getCoinImage() {
        if let savedImage = LocalFileManager.shared.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: "https://assets.coincap.io/assets/icons/\(coin.symbol)@2x.png") else { return }

        imageSubscription = NetworkingManager.download(url: url)
            .tryMap { data -> UIImage? in
                return UIImage(data: data)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                NetworkingManager.handleCompletion(completion: completion)
                if case .failure = completion {
                    self?.image = nil
                }
            } receiveValue: { [weak self] image in
                guard let self = self,
                      let image = image
                else { return }

                self.image = image
                self.imageSubscription?.cancel()
                LocalFileManager.shared.saveImage(image: image, imageName: imageName, folderName: folderName)
            }
    }
}
