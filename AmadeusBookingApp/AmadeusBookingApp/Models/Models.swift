//
//  Models.swift
//  AmadeusBookingApp
//
//  Created by Margels on 24/10/23.
//

import Foundation

struct FlightBookingData {
    var getFlightOffersBody: GetFlightOffersBody
    var flights: [FlightDetails]
}

enum AvailableCurrencies: String, CaseIterable, Encodable {
    case USD = "USD"
    case CAD = "CAD"
    case GBP = "GBP"
    case AUD = "AUD"
    case EUR = "EUR"
    case JPY = "JPY"
    
    init(from string: String) {
        switch string {
        case "USD": self = .USD
        case "EUR": self = .EUR
        case "CAD": self = .CAD
        case "AUD": self = .AUD
        case "GBP": self = .GBP
        case "JPY": self = .JPY
        default: self = .USD
        }
    }
    
    var symbol: String {
        switch self {
        case .USD, .CAD, .AUD: return "$"
        case .EUR: return "€"
        case .GBP: return "£"
        case .JPY: return "¥"
        }
    }
}

enum FlightTravelerType: String, Encodable {
    case ADULT = "ADULT"
    case CHILD = "CHILD"
    case SENIOR = "SENIOR"
    case YOUNG = "YOUNG"
    case HELD_INFANT = "HELD_INFANT"
    case SEATED_INFANT = "SEATED_INFANT"
    case STUDENT = "STUDENT"
    
    init(from string: String) {
        switch string {
        case "ADULT": self = .ADULT
        case "CHILD": self = .CHILD
        case "SENIOR": self = .SENIOR
        case "YOUNG": self = .YOUNG
        case "HELD_INFANT": self = .HELD_INFANT
        case "SEATED_INFANT": self = .SEATED_INFANT
        case "STUDENT": self = .STUDENT
        default: self = .ADULT
        }
    }
}

enum TravelClass: String, CaseIterable, Encodable {
    case economy = "ECONOMY"
    case premium = "PREMIUM_ECONOMY"
    case business = "BUSINESS"
    case first = "FIRST"
    
    init(from string: String) {
        switch string {
        case "ECONOMY", "Economy": self = .economy
        case "PREMIUM_ECONOMY", "Premium economy": self = .premium
        case "BUSINESS", "Business": self = .business
        case "FIRST", "First": self = .first
        default: self = .economy
        }
    }
    
    var description: String {
        switch self {
        case .economy:
            return "Economy"
        case .premium:
            return "Premium economy"
        case .business:
            return "Business"
        case .first:
            return "First"
        }
    }
}

enum FlightSource: String, Encodable {
    case GDS = "GDS"
    
    init(from string: String) {
        switch string {
        default: self = .GDS
        }
    }
}

enum CabinCoverage: String, Encodable {
    case MOST_SEGMENTS = "MOST_SEGMENTS"
    case AT_LEAST_ONE_SEGMENT = "AT_LEAST_ONE_SEGMENT"
    case ALL_SEGMENTS = "ALL_SEGMENTS"
    
    init(from string: String) {
        switch string {
        case "MOST_SEGMENTS": self = .MOST_SEGMENTS
        case "AT_LEAST_ONE_SEGMENT": self = .AT_LEAST_ONE_SEGMENT
        case "ALL_SEGMENTS": self = .ALL_SEGMENTS
        default: self = .MOST_SEGMENTS
        }
    }
}

enum AvailableLocations: String, CaseIterable {
    case NYC = "NYC - New York (All Airports), USA"
    case JFK = "JFK - New York John F. Kennedy Intl Airport, USA"
    case EWR = "EWR - Newark Liberty Intl Airport, USA"
    case LAX = "LAX - Los Angeles Intl Airport, USA"
    case SFO = "SFO - San Francisco Intl Airport, USA"
    case MIA = "MIA - Miami Intl Airport, USA"
    case YYZ = "YYZ - Toronto Intl Airport, CA"
    case LGW = "LGW - London Gatwick, UK"
    case CDG = "CDG - Paris Charles De Gaulle, FR"
    case MXP = "MXP - Milan Intl Airport, IT"
    case FCO = "FCO - Rome Intl Airport, IT"
    case MAD = "MAD - Madrid Intl Airport, ES"
    case ATH = "ATH - Athens Intl Airport, GR"
    case IST = "IST - Istanbul Intl Airport, TR"
    case DXB = "DXB - Dubai Intl Airport, AE"
    case GIG = "GIG - Rio de Janeiro Intl Airport, BR"
    case PEK = "PEK - Beijing Intl Airport, CH"
    case PVG = "PVG - Shanghai Intl Airport, CH"
    case HND = "HND - Tokyo Haneda, JP"
}
