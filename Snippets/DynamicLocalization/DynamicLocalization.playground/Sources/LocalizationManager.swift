import Foundation
import Combine

public class LocalizationManager {
    public static let shared = LocalizationManager()

    private var subscriptions = Set<AnyCancellable>()
    private let bundleName = "RuntimeLocalizable.bundle"
    private let fileManager = FileManager.default
    private let bundlePath: URL
    private var localizableBundle: Bundle? = nil

    private var currentLanguage: String = ""
    private var languageBundles = [String: Bundle?]()

    private let _isLocalizationLoaded = CurrentValueSubject<Bool, Never>(false)
    public var isLocalizationLoaded: AnyPublisher<Bool, Never> {
        _isLocalizationLoaded.eraseToAnyPublisher()
    }

    private init () {
        bundlePath = fileManager.documentsDirectory.appendingPathComponent(bundleName, isDirectory: true)
    }

    public func fetchLocalizations(with fetcher: LocalizationFetcher, currentLanguagePublisher: AnyPublisher<String, Never>) {
        fetcher.fetchLocalization()
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] localizations in
                self?.generateBundle(for: localizations)
            }
            .store(in: &subscriptions)

        currentLanguagePublisher
            .sink { [weak self] language in
                self?.currentLanguage = language
            }
            .store(in: &subscriptions)
    }

    public func getCurrentBundle() -> Bundle? {
        return languageBundles[currentLanguage] ?? nil
    }

    private func generateBundle(for localization: RuntimeLocalization) {
        createBundleDirectory()

        let translations = getTranslations(from: localization)
        for (languageKey, translation) in translations {
            let langPath = bundlePath.appendingPathComponent("\(languageKey).lproj", isDirectory: true)
            createLanguageDirectory(at: langPath)

            let filePath = langPath.appendingPathComponent("Localizable.strings")
            let data = translation.data(using: .utf8)
            fileManager.createFile(atPath: filePath.path, contents: data, attributes: nil)
        }

        localizableBundle = Bundle(url: bundlePath)
        createLanguageBundles(for: Array(translations.keys))
        _isLocalizationLoaded.send(true)
    }

    private func createBundleDirectory() {
        guard fileManager.fileExists(atPath: bundlePath.path) == false else { return }

        do {
            try fileManager.createDirectory(at: bundlePath, withIntermediateDirectories: true)
        } catch {
            print("ERROR: unable to create localizations directory. \(error)")
        }
    }

    private func createLanguageDirectory(at path: URL)  {
        guard fileManager.fileExists(atPath: path.path) == false else { return }

        do {
            try fileManager.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("ERROR: unable to create directory \(path.absoluteString). \(error)")
        }
    }

    private func createLanguageBundles(for languages: [String]) {
        for language in languages {
            guard let path = localizableBundle?.path(forResource: language, ofType: "lproj") else { continue }
            languageBundles[language] = Bundle(path: path)
        }
    }

    private func getTranslations(from localizations: RuntimeLocalization) -> [String: String] {
        var output = [String: String]()
        for (categoryKey, category) in localizations.values {
            for (subcategoryKey, subcategory) in category {
                for (languageKey, translation) in subcategory {
                    let translationKey = [categoryKey, subcategoryKey].joined(separator: ".")
                    if output[languageKey] == nil {
                        output[languageKey] = ""
                    }
                    output[languageKey]?.append("\"\(translationKey)\" = \"\(translation.replacingOccurrences(of: "\"", with: "\\\""))\";\n")
                }
            }
        }
        return output
    }
}
