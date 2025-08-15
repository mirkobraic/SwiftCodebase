//
//  AppFeatureTests.swift
//  TheComposableArchitectureTests
//
//  Created by Mirko Braić on 28.02.2024..
//

import ComposableArchitecture
import Foundation
import XCTest
@testable import TCAEssentials

@MainActor
final class AppFeatureTests: XCTestCase {
    func testIncrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
          AppFeature()
        }
        
        await store.send(.tab1(.incrementButtonTapped)) {
            $0.tab1.count = 1
        }
    }
}
