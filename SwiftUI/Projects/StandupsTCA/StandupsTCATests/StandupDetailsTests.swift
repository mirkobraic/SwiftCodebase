//
//  StandupDetailsTests.swift
//  StandupsTCATests
//
//  Created by Mirko Braić on 01.03.2024..
//

import ComposableArchitecture
import XCTest
@testable import StandupsTCA

@MainActor
final class StandupDetailTests: XCTestCase {
    func testEdit() async throws {
        var standup = Standup.mock
        let store = TestStore(initialState: StandupDetailFeature.State(standup: standup)) {
            StandupDetailFeature()
        }
        store.exhaustivity = .off
        
        await store.send(.editButtonTapped)
        standup.title = "Point-Free Morning Sync"
        await store.send(.destination(.presented(.editStandup(.set(\.standup, standup)))))
        await store.send(.saveEditsTapped) {
            $0.standup.title = "Point-Free Morning Sync"
        }
    }
}
