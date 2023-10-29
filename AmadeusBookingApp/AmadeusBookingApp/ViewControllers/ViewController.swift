//
//  ViewController.swift
//  AmadeusBookingApp
//
//  Created by Margels on 02/10/23.
//

import Foundation
import UIKit

final class ViewController: UIViewController {
    
    private lazy var homeTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.keyboardDismissMode = .interactive
        tv.separatorStyle = .none
        tv.register(SearchDetailsCell.self, forCellReuseIdentifier: SearchDetailsCell.reuseIdentifier)
        tv.register(FlightDetailCell.self, forCellReuseIdentifier: FlightDetailCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    private lazy var loadingScreenView = LoadingView(frame: UIScreen.main.bounds)
    
    private var flightBookingData: FlightBookingData?
    private var searchResultsFlights: [FlightDetails] = []
    private var isLoading: Bool = false { didSet { didUpdateIsViewLoading() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Book your flight"
        
        setUpLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setUpLayout() {
        
        view.addSubview(homeTableView)
        view.addSubview(loadingScreenView)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            homeTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            homeTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: homeTableView.trailingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: homeTableView.bottomAnchor)
        
        ])
        
    }
    
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
    
    private func onMissingFieldError() {
        
        let alert = UIAlertController(title: "Error", message: "Please make sure to fill all the required fields with valid data. Mandatory fields are marked with an asterisk (*).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
        
    }
    
    private lazy var onError: (String) -> Void = { [weak self] errorDescription in
        guard let self = self else { return }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "We were unable to retrieve the data for the following reason(s):\n\n\(errorDescription)\n\nPlease try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.isLoading = false
            }))
            self.present(alert, animated: true)
        }
        
    }
    
    private lazy var onSearchTapped: (GetFlightOffersBody) -> Void = { [weak self] flightOffersBody in
        guard let self = self else { return }
        
        self.isLoading = true
        guard flightOffersBody.originDestinations.count >= 1,
              flightOffersBody.travelers.count >= 1
        else {
            self.onMissingFieldError()
            self.isLoading = false
            return
        }
        
        Constants.getFlightsRequest(
            for: flightOffersBody,
            completion: { flightOffers in
                DispatchQueue.main.async {
                    self.flightBookingData?.flights = flightOffers
                    self.flightBookingData = .init(
                        getFlightOffersBody: flightOffersBody,
                        flights: flightOffers)
                    self.isLoading = false
                    self.homeTableView.reloadData()
                }
            }, onError: onError)
        
    }
    
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 + (flightBookingData?.getFlightOffersBody.originDestinations.count ?? 1) }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : flightBookingData?.flights.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailsCell.reuseIdentifier, for: indexPath) as? SearchDetailsCell else { return UITableViewCell() }
            cell.configure(
                tableView: tableView,
                onSearchTapped: onSearchTapped
            )
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell else { return UITableViewCell() }
            let flightDetails: FlightDetails? = flightBookingData?.flights[indexPath.row]
            cell.configure(
                with: flightDetails
            )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedFlight = flightBookingData?.flights[indexPath.row]
        else {
            if indexPath.section != 0 { self.onError("Could not select this flight.") }
            return
        }
        self.navigationController?.pushViewController(BookFlightViewController(flightDetails: selectedFlight), animated: true)
    }
    
}
