//
//  StandupForm.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 01.03.2024..
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StandupFormFeature {
    @ObservableState
    struct State: Equatable {
        var standup: Standup
        var focus: Field?
        
        enum Field: Hashable {
            case attendee(Attendee.ID)
            case title
        }
        
        init(focus: Field? = .title, standup: Standup) {
            self.focus = focus
            self.standup = standup
            if self.standup.attendees.isEmpty {
                @Dependency(\.uuid) var uuid
                self.standup.attendees.append(
                    Attendee(id: uuid())
                )
            }
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case addAttendeeButtonTapped
        case deleteAttendees(atOffsets: IndexSet)
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .addAttendeeButtonTapped:
                let id = uuid()
                state.standup.attendees.append(Attendee(id: id))
                state.focus = .attendee(id)
                return .none
                
            case let .deleteAttendees(atOffsets: indices):
                state.standup.attendees.remove(atOffsets: indices)
                if state.standup.attendees.isEmpty {
                    state.standup.attendees.append(Attendee(id: uuid()))
                }
                
                guard let firstIndex = indices.first else { return .none }
                let index = min(firstIndex, state.standup.attendees.count - 1)
                state.focus = .attendee(state.standup.attendees[index].id)
                return .none
            }
        }
    }
}

extension Duration {
    fileprivate var minutes: Double {
        get { Double(self.components.seconds / 60) }
        set { self = .seconds(newValue * 60) }
    }
}

struct StandupFormView: View {
    @Bindable var store: StoreOf<StandupFormFeature>
    @FocusState var focus: StandupFormFeature.State.Field?
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $store.standup.title)
                    .focused($focus, equals: .title)
                HStack {
                    Slider(value: $store.standup.duration.minutes, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    Spacer()
                    Text(store.standup.duration.formatted())
                }
                ThemePicker(selection: $store.standup.theme)
            } header: {
                Text("Standup Info")
            }
            Section {
                ForEach($store.standup.attendees) { $attendee in
                    TextField("Name", text: $attendee.name)
                        .focused($focus, equals: .attendee(attendee.id))
                }
                .onDelete { indices in
                    store.send(.deleteAttendees(atOffsets: indices))
                }
                
                Button("Add attendee") {
                    store.send(.addAttendeeButtonTapped)
                }
            } header: {
                Text("Attendees")
            }
        }
        .bind($store.focus, to: $focus)
    }
}

struct ThemePicker: View {
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: self.$selection) {
            ForEach(Theme.allCases) { theme in
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.mainColor)
                    Label(theme.name, systemImage: "paintpalette")
                        .padding(4)
                }
                .foregroundColor(theme.accentColor)
                .fixedSize(horizontal: false, vertical: true)
                .tag(theme)
            }
        }
    }
}

#Preview {
    let store = Store(initialState: StandupFormFeature.State(standup: .mock)) {
        StandupFormFeature()
    }
    
    return NavigationStack {
        StandupFormView(store: store)
    }
}
