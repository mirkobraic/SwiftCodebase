import ComposableArchitecture

@Reducer
public struct <#Domain#> {

    @ObservableState
    public struct State: Equatable {

    }

    public enum Action: StructuredAction, Equatable {

        case view(View)
        case `internal`(Internal)
        case delegate(Delegate)

        public enum View: Equatable { }

        public enum Internal: Equatable { }

        public enum Delegate: Equatable { }

    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .view(let action):
                return view(action, state: &state)
            case .internal(let action):
                return internalAction(action, state: &state)
            default:
                return .none
            }
        }
    }

    private func view(_ action: Action.View, state: inout State) -> EffectOf<Self> {
        return .none
    }

    private func internalAction(_ action: Action.Internal, state: inout State) -> EffectOf<Self> {
        return .none
    }

}
