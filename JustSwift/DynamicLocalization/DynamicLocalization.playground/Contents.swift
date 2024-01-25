import UIKit
import Combine

let fetcher = LocalizationFetcher()
let languagePublisher = CurrentValueSubject<String, Never>("en")

LocalizationManager.shared.fetchLocalizations(with: fetcher, currentLanguagePublisher: languagePublisher.eraseToAnyPublisher())
languagePublisher.send("sq")

let subscription = LocalizationManager.shared.isLocalizationLoaded
    .sink { completion in
        print("Completion: \(completion)")
    } receiveValue: { finishedLoading in
        print("Finished loading localizations: \(finishedLoading)")
        
        print("menu.live".localized())
    }
