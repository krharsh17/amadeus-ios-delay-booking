import Foundation

struct DelayPredictionResponse: Decodable {
    let data: [DelayPrediction]
}

struct DelayPrediction: Decodable {
    let type: String
    let subType: String
    let id: String
    let result: PredictionResultType
    let probability: String
}

enum PredictionResultType: String, CaseIterable, Decodable {
    case LESS_THAN_30_MINUTES
    case BETWEEN_30_AND_60_MINUTES
    case BETWEEN_60_AND_120_MINUTES
    case OVER_120_MINUTES_OR_CANCELLED
    
    var description: String {
        switch self {
        case .LESS_THAN_30_MINUTES:
            return "on time"
        case .BETWEEN_30_AND_60_MINUTES:
            return "delayed between 30 and 60 minutes"
        case .BETWEEN_60_AND_120_MINUTES:
            return "delayed between 60 and 120 minutes"
        case .OVER_120_MINUTES_OR_CANCELLED:
            return "delayed by over 120 minutes or canceled"
        }
    }
    
}
