import UIKit
import Combine

let fetcher = LocalizationFetcher()
let languagePublisher = CurrentValueSubject<String, Never>("en")

LocalizationManager.shared.fetchLocalizations(with: fetcher, currentLanguagePublisher: languagePublisher.eraseToAnyPublisher())

let subscription = LocalizationManager.shared.isLocalizationLoaded
    .sink { completion in
        print("Completion: \(completion)")
    } receiveValue: { b in
        print("")
    }
