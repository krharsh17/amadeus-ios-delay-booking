//
//  String.swift
//  AmadeusBookingApp
//
//  Created by Margels on 16/10/23.
//

import Foundation

extension String {
    
    var date: Date {
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var datePrettyPrinted: String {
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        let newFormat = "HH:mm - EEE, dd MMM"
        dateFormatter.dateFormat = newFormat
        return dateFormatter.string(from: date ?? Date())
    }
    
    var transformToDateString: String {
        let prettyPrintFormat = "HH:mm - EEE, dd MMM"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = prettyPrintFormat
        let date = dateFormatter.date(from: self)
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date ?? Date())
    }
    
}
