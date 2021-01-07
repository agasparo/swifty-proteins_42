//
//  Strings.swift
//  swifty-proteins
//
//  Created by arthur on 06/01/2021.
//

import Foundation

extension String {
    var condensed: String {
            return replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
        }
}
