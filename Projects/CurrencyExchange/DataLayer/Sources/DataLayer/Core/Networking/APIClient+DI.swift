import FactoryKit

extension Container {

    public var apiClient: Factory<APIClient> {
        self { APIClient() }
    }

}
