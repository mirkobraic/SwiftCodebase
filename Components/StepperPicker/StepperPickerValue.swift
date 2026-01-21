public typealias PickerValueType = Equatable & Hashable

public struct StepperPickerValue<T: PickerValueType>: Equatable, Hashable {

    public let value: T
    public let displayName: String

    public init(value: T, displayName: String) {
        self.value = value
        self.displayName = displayName
    }

    public func eraseToAnyStepperPickerValue() -> AnyStepperPickerValue {
        AnyStepperPickerValue(wrappedValue: self)
    }

}

/// A type-erased wrapper for `StepperPickerValue` instances.
///
/// This type uses type erasure to allow different `StepperPickerValue<T>` instances
/// to be used together in collections or other contexts where the specific type parameter
/// doesn't need to be preserved, while maintaining the ability to compare values for equality
/// and generate hash values.
///
/// Example usage:
/// ```swift
/// let intValue = StepperPickerValue(value: 1, displayName: "One")
/// let stringValue = StepperPickerValue(value: "text", displayName: "Text")
///
/// let erasedInt = AnyStepperPickerValue(wrappedValue: intValue)
/// let erasedString = AnyStepperPickerValue(wrappedValue: stringValue)
///
/// // Both values can be stored in the same array
/// let values: [AnyStepperPickerValue] = [erasedInt, erasedString]
/// ```
public struct AnyStepperPickerValue: Equatable, Hashable {

    public let displayName: String
    private let _wrappedValue: Any
    private let _isEqual: (AnyStepperPickerValue) -> Bool
    private let _hashValue: (inout Hasher) -> Void

    public init<T: PickerValueType>(wrappedValue: StepperPickerValue<T>) {
        self.displayName = wrappedValue.displayName
        self._wrappedValue = wrappedValue
        self._isEqual = { other in
            guard let otherValue = other._wrappedValue as? StepperPickerValue<T> else { return false }

            return wrappedValue == otherValue
        }
        self._hashValue = { hasher in
            wrappedValue.hash(into: &hasher)
        }
    }

    public static func == (lhs: AnyStepperPickerValue, rhs: AnyStepperPickerValue) -> Bool {
        lhs._isEqual(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        _hashValue(&hasher)
    }

}
