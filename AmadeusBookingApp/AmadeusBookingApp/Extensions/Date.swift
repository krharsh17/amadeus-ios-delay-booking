//
//  Date.swift
//  AmadeusBookingApp
//
//  Created by Margels on 16/10/23.
//

import Foundation

extension Date {
    
    var yyyyMMdd: String {
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    var HHmmss: String {
        let dateFormat = "HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
}
