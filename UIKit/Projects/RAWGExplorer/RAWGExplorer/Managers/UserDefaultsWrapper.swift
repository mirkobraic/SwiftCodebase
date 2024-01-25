//
//  SettingsManager.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 12.03.2023..
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    private let publisher = PassthroughSubject<Value, Never>()

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            // Check whether we're dealing with an optional and remove the object if the new value is nil.
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
            publisher.send(newValue)
        }
    }

    var projectedValue: AnyPublisher<Value, Never> {
        return publisher.eraseToAnyPublisher()
    }
    
// Example of use for projectedValue
//
//    let subscription = UserDefaults.$username.sink { username in
//        print("New username: \(username)")
//    }
//    UserDefaults.username = "Test"
//    // Prints: New username: Test
}

public protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

extension UserDefault where Value: ExpressibleByNilLiteral {
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}

extension UserDefaults {
    @UserDefault(key: "selectedGenresIds", defaultValue: [])
    static var selectedGenresIds: [Int]
    
    @UserDefault(key: "initialGenreSelectionDone", defaultValue: false)
    static var initialGenreSelectionDone: Bool
}