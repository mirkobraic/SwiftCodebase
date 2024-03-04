//
//  RecordMeeting.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 04.03.2024..
//

import ComposableArchitecture
import Foundation
import Speech
import SwiftUI

@Reducer
struct RecordMeetingFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        let standup: Standup
        var secondsElapsed = 0
        var speakerIndex = 0
        var transcript = ""

        var durationRemaning: Duration {
            standup.duration - .seconds(secondsElapsed)
        }
    }

    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case nextButtonTapped
        case endMeetingTapped
        case onTask
        case speechResult(String)
        case timerTicked

        enum Alert {
            case confirmDiscard
            case confirmSave
        }
        enum Delegate: Equatable {
            case saveMeeting(transcript: String)
        }
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.speechClient) var speechClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmDiscard)):
                return .run { _ in await dismiss() }

            case .alert(.presented(.confirmSave)):
                return .run { [transcript = state.transcript] send in
                    await send(.delegate(.saveMeeting(transcript: transcript)))
                    await dismiss()
                }

            case .alert(.dismiss):
                return .none

            case .delegate:
                return .none

            case .nextButtonTapped:
                guard state.speakerIndex < state.standup.attendees.count - 1 else {
                    state.alert = .endMeeting(isDiscardable: false)
                    return .none
                }
                
                state.speakerIndex += 1
                state.secondsElapsed = state.speakerIndex * Int(state.standup.durationPerAttendee.components.seconds)
                return .none
                
            case .endMeetingTapped:
                state.alert = .endMeeting(isDiscardable: true)
                return .none
                
            case .onTask:
                return .run { send in
                    await onTask(send: send)
                }

            case let .speechResult(transcript):
                state.transcript = transcript
                return .none

            case .timerTicked:
                guard state.alert == nil else { return .none }
                state.secondsElapsed += 1
                let secondsPerAttendee = Int(state.standup.durationPerAttendee.components.seconds)
                if state.secondsElapsed.isMultiple(of: secondsPerAttendee) {
                    if state.speakerIndex == state.standup.attendees.count - 1 {
                        return .run { [transcript = state.transcript] send in
                            await send(.delegate(.saveMeeting(transcript: transcript)))
                            await self.dismiss()
                        }
                    }
                    state.speakerIndex += 1
                }
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }

    private func onTask(send: Send<Action>) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                let status = await speechClient.requestAuthorization()
                if status == .authorized {
                    do {
                        for try await transcript in self.speechClient.start() {
                            await send(.speechResult(transcript))
                        }
                    } catch {
                        // TODO: handle error
                    }
                }
            }

            group.addTask {
                for await _ in self.clock.timer(interval: .seconds(1)) {
                    await send(.timerTicked)
                }
            }
        }
    }
}

extension AlertState where Action == RecordMeetingFeature.Action.Alert {
    static func endMeeting(isDiscardable: Bool) -> Self {
        Self {
            TextState("End meeting?")
        } actions: {
            ButtonState(action: .confirmSave) {
                TextState("Save and end")
            }
            if isDiscardable {
                ButtonState(
                    role: .destructive, 
                    action: .confirmDiscard) {
                    TextState("Discard")
                }
            }
            ButtonState(role: .cancel) {
                TextState("Resume")
            }
        } message: {
            TextState("""
        You are ending the meeting early. \
        What would you like to do?
        """)
        }
    }
}


struct RecordMeetingView: View {
    @Bindable var store: StoreOf<RecordMeetingFeature>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(store.standup.theme.mainColor)
            
            VStack {
                MeetingHeaderView(
                    secondsElapsed: store.secondsElapsed,
                    durationRemaining: store.durationRemaning,
                    theme: store.standup.theme
                )
                MeetingTimerView(
                    standup: store.standup,
                    speakerIndex: store.speakerIndex
                )
                MeetingFooterView(
                    standup: store.standup,
                    nextButtonTapped: {
                        store.send(.nextButtonTapped)
                    },
                    speakerIndex: store.speakerIndex
                )
            }
        }
        .padding()
        .foregroundColor(store.standup.theme.accentColor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("End meeting") {
                    store.send(.endMeetingTapped)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task { await store.send(.onTask).finish() }
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
}

#Preview {
    NavigationStack {
        RecordMeetingView(store: Store(initialState: RecordMeetingFeature.State(standup: .mock)) {
            RecordMeetingFeature()
        })
    }
}
