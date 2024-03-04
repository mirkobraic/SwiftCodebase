//
//  StandupDetail.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 01.03.2024..
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StandupDetailFeature {
    @ObservableState
    struct State: Equatable {
        var standup: Standup
        @Presents var destination: Destination.State?
    }
    
    enum Action: Equatable {
        case editButtonTapped
        case deleteButtonTapped
        case deleteMeetings(atOffset: IndexSet)
        
        case saveEditsTapped
        case cancelEditsTapped
        
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case standupUpdated(Standup)
            case deleteStandup(Standup.ID)
        }
        
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Destination {
        case editStandup(StandupFormFeature)
        case alert(AlertState<Alert>)
        
        enum Alert {
            case confirmDeletion
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.alert(.confirmDeletion))):
                return .run { [id = state.standup.id] send in
                    await send(.delegate(.deleteStandup(id)))
                    await dismiss()
                }
                
            case .destination:
                return .none
                
            case .editButtonTapped:
                state.destination = .editStandup(StandupFormFeature.State(standup: state.standup))
                return .none
                
            case .deleteButtonTapped:
                state.destination = .alert(AlertState {
                    TextState("Are you sure you want to delete?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion) {
                        TextState("Delete")
                    }
                })
                return .none
                 
            case .deleteMeetings(atOffset: let indicies):
                state.standup.meetings.remove(atOffsets: indicies)
                return .none
                
            case .saveEditsTapped:
                guard case let .editStandup(standupForm) = state.destination else { return .none }
                state.standup = standupForm.standup
                state.destination = nil
                return .none
                
            case .cancelEditsTapped:
                state.destination = nil
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .onChange(of: \.standup) { oldValue, newValue in
            Reduce { state, action in
                Effect.send(.delegate(.standupUpdated(newValue)))
            }
        }
    }
}

struct StandupDetailView: View {
    @Bindable var store: StoreOf<StandupDetailFeature>
    
    var body: some View {
        List {
            Section {
                NavigationLink(state: AppFeature.Path.State.recordMeeting(RecordMeetingFeature.State(standup: store.standup))) {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text(store.standup.duration.formatted())
                }
                
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(store.standup.theme.name)
                        .padding(4)
                        .foregroundColor(store.standup.theme.accentColor)
                        .background(store.standup.theme.mainColor)
                        .cornerRadius(4)
                }
            } header: {
                Text("Standup Info")
            }
            
            if !store.standup.meetings.isEmpty {
                Section {
                    ForEach(store.standup.meetings) { meeting in
                        NavigationLink(state: AppFeature.Path.State.meeting(meeting, store.standup)) {
                            HStack {
                                Image(systemName: "calendar")
                                Text(meeting.date, style: .date)
                                Text(meeting.date, style: .time)
                            }
                        }
                    }
                    .onDelete { indices in
                        store.send(.deleteMeetings(atOffset: indices))
                    }
                } header: {
                    Text("Past meetings")
                }
            }
            
            Section {
                ForEach(store.standup.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            } header: {
                Text("Attendees")
            }
            
            Section {
                Button("Delete") {
                    store.send(.deleteButtonTapped)
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(store.standup.title)
        .toolbar {
            Button("Edit") {
                store.send(.editButtonTapped)
            }
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
        .sheet(item: $store.scope(state: \.destination?.editStandup, action: \.destination.editStandup)) { store in
            NavigationStack {
                StandupFormView(store: store)
                    .toolbar {
                        ToolbarItem {
                            Button("Save") {
                                self.store.send(.saveEditsTapped)
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.store.send(.cancelEditsTapped)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    let store = Store(initialState: StandupDetailFeature.State(standup: .mock)) {
        StandupDetailFeature()
    }
    return NavigationStack {
        StandupDetailView(store: store)
    }
}
