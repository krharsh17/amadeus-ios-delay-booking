//
//  HistoryViewController.swift
//  AmadeusBookingApp
//
//  Created by Margels on 03/10/23.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    private lazy var loadingScreenView = LoadingView(frame: UIScreen.main.bounds)

    private var isLoading: Bool = false { didSet { didUpdateIsViewLoading() } }
    
    private func didUpdateIsViewLoading() {
            loadingScreenView.isHidden = false
            let alpha: CGFloat = isLoading ? 0.75 : 0
            UIView.animate(withDuration: 0.75, animations: {
                self.loadingScreenView.alpha = alpha
            }, completion: { _ in
                self.loadingScreenView.isHidden = !self.isLoading
                self.loadingScreenView.isUserInteractionEnabled = self.isLoading
            })
        }

    
    private lazy var noHistoryLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Nothing to see here."
        l.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        return l
    }()
    
    private lazy var historyTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.register(FlightDetailCell.self, forCellReuseIdentifier: FlightDetailCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var bookedFlights: [([DelayPrediction?], FlightDetails)] = []
    
    private func predictDelay(for segments: [SegmentDetails], completion: @escaping (([DelayPrediction?])->Void?)) {
            var delayPredictions: [DelayPrediction?] = []
            for segment in segments {
                Constants.predictDelay(for: segment) { delayPrediction in
                    delayPredictions.append(delayPrediction)
                    if delayPredictions.count == segments.count { completion(delayPredictions) }
                } onError: { _ in
                    delayPredictions.append(nil)
                    if delayPredictions.count == segments.count { completion(delayPredictions) }
                }
            }
        }
    
    private func updateTableViewData() {
            let bookedFlights = Constants.bookedFlights
            guard let latestFlight = bookedFlights.last else { return }
            if self.bookedFlights.last?.1.id != latestFlight.id {
                self.predictDelay(for: latestFlight.flightSegments) { delayPredictions in
                    self.bookedFlights.append((delayPredictions, latestFlight))
                    self.didUpdateFlightsBooked()
                }
            } else { self.isLoading = false }
        }
    
    private func didUpdateFlightsBooked() {
            DispatchQueue.main.async {
                self.historyTableView.isHidden = self.bookedFlights.isEmpty
                self.noHistoryLabel.isHidden = !(self.bookedFlights.isEmpty)
                self.historyTableView.reloadData()
                self.isLoading = false
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your bookings"
        
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isLoading = true
        updateTableViewData()
    }
    
    private func orderDelaysByHighest(delays: inout [DelayPrediction?]) -> [DelayPrediction?] {
            let numberedCases = PredictionResultType.allCases
            delays.sort(by: { firstDelayPrediction, secondDelayPrediction in
                return numberedCases.firstIndex(where: { firstDelayPrediction?.result.rawValue == $0.rawValue }) ?? 0 > numberedCases.firstIndex(where: { secondDelayPrediction?.result.rawValue == $0.rawValue }) ?? 0
            })
            return delays
    }
    
private func findBetterFlightAlternativesBasedOnDelay(currentFlight: ([DelayPrediction?], FlightDetails), flightOptions: [FlightDetails], completion: @escaping (([(DelayPrediction?, FlightDetails)])->Void)) {
        var betterOptions: [(DelayPrediction?, FlightDetails)] = []
        flightOptions.forEach { flightOption in
            self.predictDelay(for: flightOption.flightSegments) { delayPredictions in
                let allCases = PredictionResultType.allCases
                var currentFlightDelays = currentFlight.0
                var newFlightDelays = delayPredictions
                let currentFlightDelaysInOrder = self.orderDelaysByHighest(delays: &currentFlightDelays)
                let newFlightDelaysInOrder = self.orderDelaysByHighest(delays: &newFlightDelays)
                if let currentFlightDelay = allCases.firstIndex(where: { $0 == currentFlightDelaysInOrder.first??.result }),
                let newFlightDelayPrediction = newFlightDelaysInOrder.first,
                let newFlightDelay = allCases.firstIndex(where: { $0 == newFlightDelayPrediction?.result }),
                newFlightDelay < currentFlightDelay {
                    betterOptions.append((newFlightDelayPrediction, flightOption))
                }
                if betterOptions.count == 3 || flightOptions.last != nil && flightOptions.last! == flightOption {
                    completion(betterOptions)
                }
            }
        }
    }

    private lazy var didTapSearchAlternatives: ((Int) -> Void)? = { [weak self] index in
        guard let self = self else { return }
        self.isLoading = true
     
        let flightDetails = self.bookedFlights[index].1
     
        let currencyCode = AvailableCurrencies(from: flightDetails.price.currency)
        let originDestinations = [FlightOriginDestinations(id: "1", originLocationCode: flightDetails.flightSegments.first?.departure.iataCode ?? "", destinationLocationCode: flightDetails.flightSegments.last?.arrival.iataCode ?? "", departureDateTimeRange: .init(date: flightDetails.lastTicketingDate ?? "", time: "00:00:00"))]
        let travelers = [FlightTravelers(
            id: flightDetails.travelerPricings.count.description,
            travelerType: .init(from: flightDetails.travelerPricings.first?.travelerType ?? "") )]
     
        Constants.getFlightsRequest(
            for: .init(
                currencyCode: currencyCode,
                originDestinations: originDestinations,
                travelers: travelers,
                sources: [.GDS],
                searchCriteria: .init(
                    maxFlightOffers: 30,
                    flightFilters: .init(
                        cabinRestrictions: [.init(
                            cabin: .init(from: flightDetails.travelerPricings.first?.fareDetailsBySegment.first?.cabin ?? ""),
                            coverage: .MOST_SEGMENTS,
                            originDestinationIds: ["1"])])))
            ) { flightOptions in
                self.findBetterFlightAlternativesBasedOnDelay(currentFlight: self.bookedFlights[index], flightOptions: flightOptions) { betterOptions in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.navigationController?.pushViewController(FindAlternativeFlightViewController(currentFlightOption: flightDetails, betterFlightOptions: betterOptions, onReplaceFlight: self.replaceOldFlight), animated: true)
                    }
                }
            } onError: { error in
                print(error.description)
            }

    }

    private lazy var replaceOldFlight: (FlightDetails) -> Void = { [weak self] oldFlightDetails in
        guard let self = self, let index = self.bookedFlights.firstIndex(where: { $0.1 == oldFlightDetails }) else { return }
        self.bookedFlights.remove(at: index)
    }
    
    private func setUpLayout() {
        
        self.view.addSubview(noHistoryLabel)
        self.view.addSubview(historyTableView)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            historyTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: historyTableView.trailingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: historyTableView.bottomAnchor),
            
            noHistoryLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            noHistoryLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: noHistoryLabel.trailingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: noHistoryLabel.bottomAnchor),
        
        ])
        
    }
    
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { bookedFlights.count }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = CustomHeaderView()
            view.tag = 100+section
            view.onTapClickHere = self.didTapSearchAlternatives
                    let delayPredictions = self.orderDelaysByHighest(delays: &self.bookedFlights[section].0)
                    switch delayPredictions.first {
                    case .some(let delayPrediction):
                        if let segmentIndex = self.bookedFlights[section].0.firstIndex(where: { $0?.id == delayPrediction?.id }),
                        let delayProbability = delayPrediction?.probability,
                        let delayResult = delayPrediction?.result,
                        view.tag == 100+section {
                            view.probabilityAndResult = (segmentIndex+1, delayProbability, delayResult)
                        }
                        return view
                    case .none:
                        if view.tag == 100+section { view.resetText() }
                        return view
                    }

        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 75
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell
            else { return UITableViewCell() }
            let flightDetails = bookedFlights[indexPath.section].1
            cell.configure(
                with: flightDetails
            )
            return cell
        }
    
}
