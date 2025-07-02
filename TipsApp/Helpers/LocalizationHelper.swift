//
//  LocalizationHelper.swift
//  Tips App
//
//  Created by Anand Upadhyay on 28/06/25.
//

import Foundation

struct LocalizationHelper {
    static func localizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
} 