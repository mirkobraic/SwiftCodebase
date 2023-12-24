import Foundation

extension String {
    func localized() -> String {
        guard let bundle = LocalizationManager.shared.getCurrentBundle() else { return self }
        return NSLocalizedString(self, bundle: bundle, value: self, comment: "")
    }
}

extension FileManager {
    var documentsDirectory: URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
