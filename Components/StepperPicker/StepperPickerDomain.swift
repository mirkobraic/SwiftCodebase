import SwiftUI
import ComposableArchitecture

@Reducer
public struct StepperPickerDomain {

    public init() { }

    @ObservableState
    public struct State: Equatable {

        public let values: [AnyStepperPickerValue]
        public var hasEverChanged: Bool = false

        let placeholder: String
        var showingPicker = false
        var valueChanged = false
        var fieldHasError = false

        private let colorConfig: StepperPickerColorConfiguration
        /// The selected value that the component has been initialized with. Primarily used to determine the background color of a picker.
        private let initialValue: AnyStepperPickerValue?

        private var selectedIndex: Int?

        public var selectedValue: AnyStepperPickerValue? {
            get {
                guard let selectedIndex else { return nil }

                return values[safe: selectedIndex]
            }
            set {
                guard let newValue else { return }

                selectedIndex = values.firstIndex(of: newValue)
            }
        }

        var hasNextValue: Bool {
            // If no value is selected, default to true
            selectedIndex.map { $0 + 1 < values.endIndex } ?? true
        }

        var hasPreviousValue: Bool {
            // If no value is selected, default to true
            selectedIndex.map { $0 - 1 >= values.startIndex } ?? true
        }

        var backgroundColor: Color {
            guard let selected = selectedValue else {
                return colorConfig.initialColor
            }

            guard let initial = initialValue else {
                return valueChanged ? colorConfig.newValueColor : colorConfig.initialColor
            }

            if selected == initial {
                return hasEverChanged ? colorConfig.originalValueColor : colorConfig.initialColor
            } else {
                return colorConfig.newValueColor
            }
        }

        public init<T: PickerValueType>(
            values: [StepperPickerValue<T>],
            selectedValue: T?,
            originalSelectedValue: T? = nil,
            hasEverChanged: Bool = false,
            colorConfig: StepperPickerColorConfiguration = .default,
            placeholder: String = LocalizableStrings.select.localized
        ) {
            self.colorConfig = colorConfig
            self.placeholder = placeholder
            self.values = values.map { $0.eraseToAnyStepperPickerValue() }
            let baselineValue = originalSelectedValue
            self.initialValue = baselineValue.flatMap { original in
                values.first { $0.value == original }?.eraseToAnyStepperPickerValue()
            }

            let currentAny = selectedValue.flatMap { value in
                values.first { $0.value == value }?.eraseToAnyStepperPickerValue()
            }

            self.selectedIndex = nil
            self.selectedValue = currentAny

            if initialValue == nil {
                self.valueChanged = (self.selectedValue != nil)
            } else {
                self.valueChanged = false
            }

            self.hasEverChanged = hasEverChanged
            self.fieldHasError = false
            self.showingPicker = false
        }

        public mutating func setFieldError(hasError: Bool) {
            fieldHasError = hasError
        }

        mutating func selectNext() {
            guard let selectedIndex else {
                // If no value is currently selected, select the first value
                self.selectedIndex = values.startIndex
                return
            }

            if hasNextValue {
                self.selectedIndex = selectedIndex + 1
            }
        }

        mutating func selectPrevious() {
            guard let selectedIndex else {
                // If no value is currently selected, select the last value
                self.selectedIndex = values.endIndex - 1
                return
            }

            if hasPreviousValue {
                self.selectedIndex = selectedIndex - 1
            }
        }

    }

    public enum Action: ViewAction, BindableAction, Equatable {

        case view(View)
        case delegate(Delegate)
        case binding(BindingAction<State>)

        public enum View: Equatable {

            case decrementTap
            case textboxTap
            case incrementTap

        }

        public enum Delegate: Equatable {

            case userActivityDetected
            case valueUpdated

        }

    }

    public  var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.selectedValue) { oldValue, newValue in
                Reduce<State, Action> { _, _ in
                    guard oldValue != newValue else { return .none }

                    return .send(.delegate(.valueUpdated))
                }
            }
        Reduce<State, Action> { state, action in
            switch action {
            case .view(.decrementTap):
                state.selectPrevious()

                return .send(.delegate(.valueUpdated))
            case .view(.incrementTap):
                state.selectNext()

                return .send(.delegate(.valueUpdated))
            case .view(.textboxTap):
                return .send(.delegate(.userActivityDetected))
            case .delegate(.valueUpdated):
                state.valueChanged = true
                state.fieldHasError = false
                state.hasEverChanged = true

                return .none
            case .delegate:
                return .none
            case .binding:
                return .none
            }
        }
    }

}
