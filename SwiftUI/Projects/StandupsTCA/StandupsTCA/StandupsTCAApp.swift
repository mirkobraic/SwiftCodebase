//
//  StandupsTCAApp.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 01.03.2024..
//

import ComposableArchitecture
import SwiftUI

@main
struct StandupsTCAApp: App {
    static let store = StoreOf<StandupsListFeature>(initialState: StandupsListFeature.State()) {
        StandupsListFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            var editedStandup = Standup.mock
            let _ = editedStandup.title += " Morning Sync"
            
            let stackState = StackState<AppFeature.Path.State>([
                .detail(StandupDetailFeature.State(standup: .mock)),
                .recordMeeting(RecordMeetingFeature.State(standup: .mock))
            ])
            let standupsList = StandupsListFeature.State()
            
            // add "path: stackState" argument in order to provide deep linking
            AppView(store: Store(initialState: AppFeature.State(standupsList: standupsList)) {
                AppFeature()
                    ._printChanges()
            })
        }
    }
}
