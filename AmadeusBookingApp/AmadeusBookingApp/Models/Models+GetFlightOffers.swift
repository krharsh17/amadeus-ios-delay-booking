//
//  Models+GetFlightOffers.swift
//  AmadeusBookingApp
//
//  Created by Margels on 24/10/23.
//

import Foundation

struct GetFlightOffersBody: Encodable {
    let currencyCode: AvailableCurrencies
    let originDestinations: [FlightOriginDestinations]
    let travelers: [FlightTravelers]
    let sources: [FlightSource]
    let searchCriteria: FlightSearchCriteria
}

struct FlightOriginDestinations: Encodable {
    let id: String
    let originLocationCode: String
    let destinationLocationCode: String
    let departureDateTimeRange: FlightTimeRange
}

struct FlightTimeRange: Encodable {
    let date: String
    let time: String
}

struct FlightTravelers: Encodable {
    let id: String
    let travelerType: FlightTravelerType
    let associatedAdultId: String? = nil
}

struct FlightSearchCriteria: Encodable {
    let maxFlightOffers: Int
    let flightFilters: FlightFilters
}

struct FlightFilters: Encodable {
    let cabinRestrictions: [CabinRestrictions]
}

struct CabinRestrictions: Encodable {
    let cabin: TravelClass
    let coverage: CabinCoverage
    let originDestinationIds: [String]
}
