//
//  Models+SuccessBooking.swift
//  AmadeusBookingApp
//
//  Created by Margels on 24/10/23.
//

import Foundation

struct SuccessBookingResponse: Decodable {
    let data: FlightOrderCreateQuery
}

struct SuccessBookingResponseData: Decodable {
    let type: String
    let id: String
    let queuingOfficeId: String
    let associatedRecords: AssociatedRecords
    let flightOffers: [FlightDetails]
    let travelers: [TravelerData]
    let contacts: [ContactData]
}

struct AssociatedRecords: Decodable {
    let reference: String
    let creationDateTime: String
    let originSystemCode: String
    let flightOfferId: String
}
