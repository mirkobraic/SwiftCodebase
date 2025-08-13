//
//  AddContactFeature.swift
//  TCANavigation
//
//  Created by Mirko Braić on 28.02.2024..
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct AddContactFeature {
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }

    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
                
            case .delegate:
                return .none
                
            case .setName(let name):
                state.contact.name = name
                return .none
            }
        }
    }
}

struct AddContactView: View {
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form {
            TextField("Name", text: $store.contact.name.sending(\.setName))
            Button("Save") {
                store.send(.saveButtonTapped)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Cancel", role: .cancel) {
                    store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    let state = AddContactFeature.State(contact: Contact(id: UUID(), name: "Šime"))
    let store = Store(initialState: state) {
        AddContactFeature()
    }
    
    return NavigationStack {
        AddContactView(store: store)
    }
}
