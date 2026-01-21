import SwiftUI

public struct StepperPickerColorConfiguration: Equatable {

    /// The background color of the picker when it is first displayed.
    let initialColor: Color

    /// The background color of the picker after the value has been changed.
    let newValueColor: Color

    /// The background color of the picker when the value is reset to its original value.
    let originalValueColor: Color

    public static let `default` = StepperPickerColorConfiguration(
        initialColor: .mainGray,
        newValueColor: .lightGreenBackground,
        originalValueColor: .lightPurpleBackground)

}
