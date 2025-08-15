//
//  DataManager.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 07.03.2024..
//

import ComposableArchitecture
import Foundation

struct DataManager {
    var load: @Sendable (URL) throws -> Data
    var save: @Sendable (Data, URL) throws -> Void
}

extension DataManager: DependencyKey {
    static let liveValue = DataManager(
        load: { url in try Data(contentsOf: url) },
        save: { data, url in try data.write(to: url) })

    static let previewValue = Self.mock()

    static let failToWrite = DataManager(
        load: { _ in Data() },
        save: { _, _ in
            struct SomeError: Error { }
            throw SomeError()
        })

    static let failToLoad = DataManager(
        load: { _ in
            struct SomeError: Error { }
            throw SomeError()
        },
        save: { _, _ in })

    static func mock(initialData: Data? = nil) -> DataManager {
        let data = LockIsolated(initialData)
        return DataManager(
            load: { _ in
                guard let data = data.value
                else {
                    struct FileNotFound: Error {}
                    throw FileNotFound()
                }
                return data
            },
            save: { newData, _ in data.setValue(newData) }
        )
    }
}

extension DependencyValues {
    var dataManager: DataManager {
        get { self[DataManager.self] }
        set { self[DataManager.self] = newValue }
    }
}
