//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 28.07.2023..
//

import Foundation

extension String {
    func removingHTMLOccurances() -> String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
