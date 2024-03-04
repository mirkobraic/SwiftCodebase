//
//  App.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 04.03.2024..
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var standupsList = StandupsListFeature.State()
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case standupsList(StandupsListFeature.Action)
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case detail(StandupDetailFeature)
        case recordMeeting(RecordMeetingFeature)
        case meeting(Meeting, Standup)
    }

    @Dependency(\.uuid) var uuid
    @Dependency(\.date.now) var now
    @Dependency(\.continuousClock) var clock
    @Dependency(\.dataManager.save) var saveData

    var body: some ReducerOf<Self> {
        Scope(state: \.standupsList, action: \.standupsList) {
            StandupsListFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .standupsList:
                return .none

            case let .path(.element(id: _, action: .detail(.delegate(action)))):
                switch action {
                case let .standupUpdated(standup):
                    state.standupsList.standups[id: standup.id] = standup
                    return .none
                case let .deleteStandup(id):
                    state.standupsList.standups.remove(id: id)
                    return .none
                }

            case let .path(.element(id: _, action: .recordMeeting(.delegate(action)))):
                switch action {
                case let .saveMeeting(transcript):
                    guard let detailId = state.path.ids.dropLast().last else {
                        XCTFail("Record meeting is the last element in the stack. A detail feature shoudl proceed it.")
                        return .none
                    }
                    state.path[id: detailId, case: \.detail]?.standup.meetings.insert(
                        Meeting(id: uuid(), date: now, transcript: transcript),
                        at: 0)

                    guard let standup = state.path[id: detailId, case: \.detail]?.standup else { return .none }
                    state.standupsList.standups[id: standup.id] = standup
                    return .none
                }
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)

        Reduce { state, _ in
            Effect.run { [standups = state.standupsList.standups] _ in
                enum cancelID { case saveDebounce }

                try await withTaskCancellation(id: cancelID.saveDebounce, cancelInFlight: true) {
                    try await clock.sleep(for: .seconds(1))
                    try saveData(JSONEncoder().encode(standups), .standups)
                }
            }
        }
    }
}

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        // TODO: for some reason this navigation does not work with deep linking, (A "forEach" at "ComposableArchitecture/CaseReducer.swift:52" received an action for a missing element.)
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            StandupsListView(store: store.scope(
                state: \.standupsList,
                action: \.standupsList
            ))
        } destination: { store in
            switch store.state {
            case .detail:
                if let store = store.scope(state: \.detail, action: \.detail) {
                    StandupDetailView(store: store)
                }
            case .recordMeeting:
                if let store = store.scope(state: \.recordMeeting, action: \.recordMeeting) {
                    RecordMeetingView(store: store)
                }
            case let .meeting(meeting, standup):
                MeetingView(meeting: meeting, standup: standup)
            }
        }
        
        // this implementation works for deep linking, but causes purple runtime warnings beacause of @ObservableState
//        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
//            StandupsListView(store: store.scope(
//                state: \.standupsList,
//                action: \.standupsList
//            ))
//        } destination: { state in
//            switch state {
//            case .detail:
//                CaseLet(/AppFeature.Path.State.detail, action: AppFeature.Path.Action.detail) { store in
//                    StandupDetailView(store: store)
//                }
//            }
//        }
    }
}

extension URL {
    static let standups = documentsDirectory.appending(component: "standups.json")
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(standupsList: StandupsListFeature.State())) {
        AppFeature()
    })
}
