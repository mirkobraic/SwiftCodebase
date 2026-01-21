public enum S3DataType: Sendable {

    case png
    case jpeg
    case heic

    public var imageExtension: String {
        switch self {
        case .png:
            "png"
        case .jpeg:
            "jpeg"
        case .heic:
            "heic"
        }
    }

    public var contentType: String {
        switch self {
        case .png:
            "image/png"
        case .jpeg:
            "image/jpeg"
        case .heic:
            "image/heic"
        }
    }

    init(from type: UploadDataType) {
        switch type {
        case .png:
            self = .png
        case .jpeg:
            self = .jpeg
        case .heic:
            self = .heic
        }
    }

}
