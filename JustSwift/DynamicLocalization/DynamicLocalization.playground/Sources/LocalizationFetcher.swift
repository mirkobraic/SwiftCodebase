import Foundation
import Combine

public class LocalizationFetcher {

    public init() { }
    
    public func fetchLocalization() -> AnyPublisher<RuntimeLocalization, Never> {
        let localizationData = readLocalFile(forName: "example".localized())
        let runtimeLocalization = try! JSONDecoder().decode(RuntimeLocalization.self, from: localizationData)
        return Just(runtimeLocalization).eraseToAnyPublisher()
    }

    private func readLocalFile(forName name: String) -> Data {
        let bundlePath = Bundle.main.path(forResource: name, ofType: "json")!
        let jsonData = try! String(contentsOfFile: bundlePath).data(using: .utf8)
        return jsonData!
    }
}
