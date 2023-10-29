//
//  Models+Auth.swift
//  AmadeusBookingApp
//
//  Created by Margels on 24/10/23.
//

import Foundation

struct AuthResponse: Decodable {
    let type: String
    let username: String
    let application_name: String
    let client_id: String
    let token_type: String
    let access_token: String
    let expires_in: Int
    let state: String
    let scope: String?
}
