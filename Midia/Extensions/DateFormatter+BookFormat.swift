//
//  DateFormatter+BookFormat.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 26/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

extension DateFormatter {
    // Not a computed variable. BookFormatter will only be generated once and
    // every time we access to bookFormatter the code will not be executed
    static let bookFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }()
}
