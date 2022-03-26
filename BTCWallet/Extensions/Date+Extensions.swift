//
//  Date+Extensions.swift
//  BTCWallet
//
//  Created by Alexander Kovzhut on 26.03.2022.
//

import Foundation

extension Date {
    func setFormatToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.timeZone = .autoupdatingCurrent

        let stringDate = dateFormatter.string(from: self)
        return stringDate
    }
}
