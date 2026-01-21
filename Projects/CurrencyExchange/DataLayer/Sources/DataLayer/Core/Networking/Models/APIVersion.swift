public enum APIVersion: String {

    case v1

    var path: String {
        switch self {
        case .v1:
            "/v1"
        }
    }

}
