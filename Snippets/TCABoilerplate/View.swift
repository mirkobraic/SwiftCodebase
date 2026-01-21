import SwiftUI
import ComposableArchitecture

@ViewAction(for: <#Domain#>.self)
public struct <#View#>: View {

    public let store: StoreOf<<#Domain#>>

    public init(store: StoreOf<<#Domain#>>) {
        self.store = store
    }

    public var body: some View {
        Text("Hello World!")
    }

}
