//
//  Models+FlightOffersResponse.swift
//  AmadeusBookingApp
//
//  Created by Margels on 24/10/23.
//

import Foundation

struct FlightOffersResponse: Decodable {
    let meta: MetaBody
    let data: [FlightDetails]
}

struct MetaBody: Decodable {
    let count: Int
}

struct FlightDetails: Encodable, Decodable {
    let type: String
    let id: String
    let source: String
    let instantTicketingRequired: Bool?
    let nonHomogeneous: Bool
    let oneWay: Bool?
    var lastTicketingDate: String?
    let numberOfBookableSeats: Int?
    let itineraries: [ItineraryDetails]
    var price: PriceDetails
    let pricingOptions: PricingOption
    let validatingAirlineCodes: [String]
    let travelerPricings: [TravelerPricingDetails]
    var flightSegments: [SegmentDetails] {
        var segments: [SegmentDetails] = []
        for itinerary in itineraries {
            segments.append(contentsOf: itinerary.segments)
        }
        return segments
    }
    static func == (lhs: FlightDetails, rhs: FlightDetails) -> Bool {
       lhs.id == rhs.id && lhs.type == rhs.type && lhs.source == rhs.source && lhs.instantTicketingRequired == rhs.instantTicketingRequired && lhs.nonHomogeneous == rhs.nonHomogeneous && lhs.oneWay == rhs.oneWay && lhs.lastTicketingDate == rhs.lastTicketingDate && lhs.itineraries.count == rhs.itineraries.count && lhs.price.total == rhs.price.total && lhs.validatingAirlineCodes.first == rhs.validatingAirlineCodes.first && lhs.validatingAirlineCodes.count == rhs.validatingAirlineCodes.count && lhs.validatingAirlineCodes.first == rhs.validatingAirlineCodes.first && lhs.validatingAirlineCodes.last == rhs.validatingAirlineCodes.last && lhs.travelerPricings.count == rhs.travelerPricings.count && lhs.flightSegments.count == rhs.flightSegments.count && lhs.flightSegments.first?.departure.iataCode == lhs.flightSegments.first?.departure.iataCode && lhs.flightSegments.first?.arrival.iataCode == lhs.flightSegments.first?.arrival.iataCode && lhs.flightSegments.last?.departure.iataCode == lhs.flightSegments.last?.departure.iataCode && lhs.flightSegments.last?.arrival.iataCode == lhs.flightSegments.last?.arrival.iataCode
   }
}

struct ItineraryDetails: Encodable, Decodable {
    let duration: String?
    let segments: [SegmentDetails]
}

struct SegmentDetails: Encodable, Decodable {
    let departure: AirportDetails
    let arrival: AirportDetails
    let carrierCode: String
    let number: String
    let aircraft: AircraftDetails
    let operating: OperatingDetails?
    let duration: String
    let id: String
    let numberOfStops: Int
    let blacklistedInEU: Bool?
}

struct AirportDetails: Encodable, Decodable {
    let iataCode: String
    let terminal: String?
    let at: String
}

struct AircraftDetails: Encodable, Decodable {
    let code: String
}

struct OperatingDetails: Encodable, Decodable {
    let carrierCode: String
}

struct PriceDetails: Encodable, Decodable {
    let currency: String
    let total: String
    let base: String
    let fees: [FeeDetails]?
    let grandTotal: String?
}

struct FeeDetails: Encodable, Decodable {
    let amount: String
    let type: String
}

struct PricingOption: Encodable, Decodable {
    let fareType: [String]
    let includedCheckedBagsOnly: Bool
}

struct TravelerPricingDetails: Encodable, Decodable {
    let travelerId: String
    let fareOption: String
    let travelerType: String
    let price: PriceDetails
    let fareDetailsBySegment: [FareDetails]
}

struct FareDetails: Encodable, Decodable {
    let segmentId: String
    let cabin: String
    let fareBasis: String
    let `class`: String
    let includedCheckedBags: CheckedBagDetails
}

struct CheckedBagDetails: Encodable, Decodable {
    let weight: Int?
    let weightUnit: String?
}
