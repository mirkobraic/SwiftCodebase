import SwiftUI
import ComposableArchitecture

@ViewAction(for: StepperPickerDomain.self)
public struct StepperPickerView: View {

    @Bindable public var store: StoreOf<StepperPickerDomain>

    @State private var showingPicker = false

    public init(store: StoreOf<StepperPickerDomain>) {
        self.store = store
    }

    public var body: some View {
        // Using spacers instead of larger HStack spacing to allow the middle button to expand, without
        // affecting the position of increment and decrement buttons
        HStack(spacing: .defaultGutter) {
            decrementButton

            Spacer(minLength: 0)

            textboxButton

            Spacer(minLength: 0)

            incrementButton
        }
    }

    private var decrementButton: some View {
        Button {
            send(.decrementTap)
        } label: {
            Image.iconMinus
        }
        .disabled(!store.hasPreviousValue)
        .opacity(store.hasPreviousValue ? 1 : 0.3)
        .enableButtonRepeatBehavior()
    }

    private var incrementButton: some View {
        Button {
            send(.incrementTap)
        } label: {
            Image.iconPlus
        }
        .disabled(!store.hasNextValue)
        .opacity(store.hasNextValue ? 1 : 0.3)
        .enableButtonRepeatBehavior()
    }

    private var textboxButton: some View {
        Button {
            showingPicker = true
            send(.textboxTap)
        } label: {
            Text(store.selectedValue?.displayName ?? store.placeholder)
                .font(.fontHeading4)
                .foregroundStyle(store.fieldHasError ? Color.lightErrorText : Color.lightTextPrimary)
                .padding(.vertical, .defaultGutter)
                .padding(.horizontal, .doubleGutter)
                .frame(minWidth: 80)
                .background(store.fieldHasError ? Color.lightErrorBackground : store.backgroundColor)
                .border(color: .primaryBlack)
        }
        .popover(isPresented: $showingPicker) {
            popoverPicker
        }
    }

    private var popoverPicker: some View {
        Picker("", selection: $store.selectedValue) {
            if store.selectedValue == nil {
                Text(store.placeholder)
                    .tag(nil as AnyStepperPickerValue?)
            }
            ForEach(store.values, id: \.self) {
                Text($0.displayName)
                    .tag($0 as AnyStepperPickerValue?)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 130)
        .frame(idealWidth: 140)
    }

}

#Preview {

    let mockValues: [StepperPickerValue<Int>] = [
        StepperPickerValue(value: 1, displayName: "One"),
        StepperPickerValue(value: 2, displayName: "Two"),
        StepperPickerValue(value: 3, displayName: "Three")
    ]

    return StepperPickerView(store: .init(initialState: .init(values: mockValues, selectedValue: 2)) {
        StepperPickerDomain()
    })

}
