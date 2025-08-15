//
//  StandupsList.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 01.03.2024..
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StandupsListFeature {
    @ObservableState
    struct State: Equatable {
        var standups: IdentifiedArrayOf<Standup> = []
        @Presents var addStandup: StandupFormFeature.State?

        init(addStandup: StandupFormFeature.State? = nil) {
            self.addStandup = addStandup
            do {
                @Dependency(\.dataManager.load) var loadData
                self.standups = try JSONDecoder().decode(
                    IdentifiedArrayOf<Standup>.self,
                    from: loadData(.standups))
            } catch {
                self.standups = []
            }
        }
    }
    
    enum Action: Equatable {
        case addButtonTapped
        
        case addStandup(PresentationAction<StandupFormFeature.Action>)
        case cancelStandupButtonTapped
        case saveStandupButtonTapped
    }
    
    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addStandup = .init(standup: Standup(id: uuid()))
                return .none
                
            case .addStandup:
                return .none
                
            case .cancelStandupButtonTapped:
                state.addStandup = nil
                return .none

            case .saveStandupButtonTapped:
                guard let standup = state.addStandup?.standup else { return .none }
                state.standups.append(standup)
                state.addStandup = nil
                return .none
            }
        }
        .ifLet(\.$addStandup, action: \.addStandup) {
            StandupFormFeature()
        }
    }
}

struct StandupsListView: View {
    @Bindable var store: StoreOf<StandupsListFeature>
    
    var body: some View {
        List(store.standups) { standup in
            NavigationLink(state: AppFeature.Path.State.detail(StandupDetailFeature.State(standup: standup))) {
                CardView(standup: standup)
            }
            .listRowBackground(standup.theme.mainColor)
        }
        .navigationTitle("Daily Standups")
        .toolbar {
            ToolbarItem {
                Button("Add") {
                    store.send(.addButtonTapped)
                }
            }
        }
        .sheet(item: $store.scope(state: \.addStandup, action: \.addStandup)) { store in
            NavigationStack {
                StandupFormView(store: store)
                    .navigationTitle("New standup")
                    .toolbar {
                        ToolbarItem {
                            Button("Save") {
                                self.store.send(.saveStandupButtonTapped)
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.store.send(.cancelStandupButtonTapped)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    let store = StoreOf<StandupsListFeature>(initialState: StandupsListFeature.State()) {
        StandupsListFeature()
    } withDependencies: {
        $0.dataManager = .mock(initialData: try? JSONEncoder().encode([Standup.mock]))
    }

    return NavigationStack {
        StandupsListView(store: store)
    }
}
