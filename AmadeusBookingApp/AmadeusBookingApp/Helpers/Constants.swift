//
//  Constants.swift
//  AmadeusBookingApp
//
//  Created by Margels on 06/10/23.
//

import Foundation

final class Constants {
    
    static var bookedFlights: [FlightDetails] = []
    
    static let authUrl = "https://test.api.amadeus.com/v1/security/oauth2/token"
    
    static let baseUrlV1 = "https://test.api.amadeus.com/v1"
    static let baseUrlV2 = "https://test.api.amadeus.com/v2"
    static let flightOffersUrl = "/shopping/flight-offers"
    static let flightOrderUrl = "/booking/flight-orders"
    
    static let clientId = "SWrGF5PZUAwTTOo7HnWH5bN3VyFj7JMJ"
    static let clientSecret = "ZgmeBoGkIzwQjwZZ"
    
    // MARK: - Auth Token
    
    static func getAuthRequest(onError: ((String)->Void)?, completion: @escaping (String)->()) {
        
        guard let url = URL(string: self.authUrl) else { return }
        
        let parameters = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.httpBody = parameters.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                onError?(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                onError?("Invalid response")
                return
            }
            
            guard let responseData = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let authResponse = try decoder.decode(AuthResponse.self, from: responseData)
                completion("\(authResponse.token_type) \(authResponse.access_token)")
            } catch let error {
                onError?(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: - Flight offers
    
    static func getFlightsRequest(
        for getFlightOffersBody: GetFlightOffersBody,
        completion: @escaping ([FlightDetails]) -> (),
        onError: ((String)->Void)?
    ) {
        
        Constants.getAuthRequest(onError: onError) { token in
            
            guard let url = URL(string: "\(self.baseUrlV2)\(self.flightOffersUrl)") else {
                onError?("The URL could not be found.")
                return
            }
            
            if let jsonData = try? JSONEncoder().encode(getFlightOffersBody) {
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("POST", forHTTPHeaderField: "X-HTTP-Method-Override")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(token, forHTTPHeaderField: "Authorization")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let error = error {
                        onError?(error.localizedDescription)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode)
                    else {
                        if let data = data, let jsonResponse = try? JSONDecoder().decode(ErrorBody.self, from: data) { onError?("\(jsonResponse.errors[0].title), \(jsonResponse.errors[0].detail ?? "")") }
                        return
                    }
                    
                    guard let responseData = data else { return }
                    
                    let decoder = JSONDecoder()
                    do {
                        let responseBody = try decoder.decode(FlightOffersResponse.self, from: responseData)
                        completion(responseBody.data)
                    } catch let error {
                        onError?(error.localizedDescription)
                    }
                }
                task.resume()
                
            }
            
        }
        
    }
    
    // MARK: - Create flight order
    
    static func placeFlightOrder(
        for flightOrderQuery: FlightOrderQuery,
        completion: @escaping (FlightOrderCreateQuery) -> (),
        onError: ((String)->Void)?
    ) {
        
        Constants.getAuthRequest(onError: onError) { token in
            
            guard let url = URL(string: "\(self.baseUrlV1)\(self.flightOrderUrl)") else {
                onError?("The URL could not be found.")
                return
            }
            
            if let jsonData = try? JSONEncoder().encode(flightOrderQuery) {
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(token, forHTTPHeaderField: "Authorization")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let error = error {
                        onError?(error.localizedDescription)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode)
                    else {
                        if let data = data, let jsonResponse = try? JSONDecoder().decode(ErrorBody.self, from: data).errors[0] {
                            onError?("\(jsonResponse.title), \(jsonResponse.detail ?? "")") }
                        return
                    }
                    
                    guard let responseData = data else { return }
                    
                    let decoder = JSONDecoder()
                    do {
                        let responseBody = try decoder.decode(SuccessBookingResponse.self, from: responseData)
                        completion(responseBody.data)
                    } catch let error {
                        onError?(error.localizedDescription)
                    }
                }
                task.resume()
                
            }
            
        }
        
    }
    
}
