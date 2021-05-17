//
//  String+Localized.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
