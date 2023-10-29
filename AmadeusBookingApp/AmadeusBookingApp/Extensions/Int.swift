//
//  Int.swift
//  AmadeusBookingApp
//
//  Created by Margels on 03/10/23.
//

import Foundation

extension Int {
    
    var string: String { "\(self)" }
    
}

extension Optional where Wrapped == Int {
    
    var string: String {
        guard let self = self else { return "" }
        return "\(self)"
    }
    
}
