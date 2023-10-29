//
//  Models+FlightOrderQuery.swift
//  AmadeusBookingApp
//
//  Created by Margels on 24/10/23.
//

import Foundation

struct FlightOrderQuery: Encodable {
    let data: FlightOrderCreateQuery
}

struct FlightOrderCreateQuery: Encodable, Decodable {
    var type: String = "flight-order"
    let flightOffers: [FlightDetails]
    var travelers: [TravelerData] = [.init()]
    var contacts: [ContactData] = [.init()]
}

struct TravelerData: Encodable, Decodable {
    var id: String = "1"
    var dateOfBirth: String = "1990-01-01"
    var gender: String = "UNSPECIFIED"
    var name: TravelerName = .init(firstName: "Jaden", lastName: "Smith", middleName: nil, secondLastName: nil)
    var documents: [TravelerDocument] = [.init()]
    var emergencyContact: EmergencyContact = .init()
    var contacts: ContactData? = nil
}

struct TravelerName: Encodable, Decodable {
    let firstName: String?
    let lastName: String?
    let middleName: String?
    let secondLastName: String?
}

struct TravelerDocument: Encodable, Decodable  {
    var number: String = "AA0000000"
    var issuanceDate: String = "2020-01-01"
    var expiryDate: String = "2030-01-01"
    var issuanceCountry: String = "US"
    var issuanceLocation: String = "New-York"
    var nationality: String = "US"
    var birthPlace: String = "New-York"
    var documentType: String = "PASSPORT"
    var validityCountry: String? = nil
    var birthCountry: String? = nil
    var holder: Bool = true
}

struct EmergencyContact: Encodable, Decodable {
    var addresseeName: String = "John Smith"
    var countryCode: String = "US"
    var number: String = "1234567890"
    var text: String = "Brother"
}

struct ContactData: Encodable, Decodable {
    var addresseeName: TravelerName = .init(firstName: "Jaden", lastName: "Smith", middleName: nil, secondLastName: nil)
    var address: TravelerAddress = .init()
    var language: String? = nil
    var purpose: String = "STANDARD"
    var phones: [TravelerPhone] = [.init()]
    var companyName: String = "AMADEUS"
    var emailAddress: String = "j.smith@mail.com"
}

struct TravelerAddress: Encodable, Decodable {
    var lines: [String] = ["5th Avenue"]
    var postalCode: String = "10128"
    var countryCode: String = "US"
    var cityName: String = "New York"
    var stateName: String = "New York"
    var postalBox: String = "BP 220"
}

struct TravelerPhone: Encodable, Decodable {
    var deviceType: String = "MOBILE"
    var countryCallingCode: String = "1"
    var number: String = "1234567890"
}
