public struct MockS3PresignedUrlProvider: S3PresignedUrlProvider {

    public func getPresignedUrls(count: Int, type: S3DataType) async throws -> [S3PresignedUrlModel] {
        []
    }

}
