enum Environment {

    static let current: Self = .dev

    case dev

    var baseApiPath: String {
        switch self {
        case .dev:
            "api.dolarapp.dev"
        }
    }

}
