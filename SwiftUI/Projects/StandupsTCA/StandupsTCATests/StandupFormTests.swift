//
//  StandupFormTests.swift
//  StandupsTCATests
//
//  Created by Mirko Braić on 01.03.2024..
//

import ComposableArchitecture
import XCTest
@testable import StandupsTCA

@MainActor
final class StandupFormTests: XCTestCase {
    func testAddDeleteAttendee() async {
        let standup = Standup(id: UUID(), attendees: [Attendee(id: UUID())])
        let initialState = StandupFormFeature.State(standup: standup)
        
        let store = TestStore(initialState: initialState) {
            StandupFormFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addAttendeeButtonTapped) {
            $0.focus = .attendee(UUID(0))
            $0.standup.attendees.append(Attendee(id: UUID(0)))
        }
        
        await store.send(.deleteAttendees(atOffsets: [1])) {
            $0.focus = .attendee($0.standup.attendees[0].id)
            $0.standup.attendees.remove(at: 1)
        }
    }
}
