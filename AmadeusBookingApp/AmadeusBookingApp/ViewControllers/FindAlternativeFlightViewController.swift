//
//  FindAlternativeFlightViewController.swift
//  AmadeusBookingApp
//
//  Created by Kumar Harsh on 26/03/24.
//

import Foundation
import UIKit
final class FindAlternativeFlightViewController: UIViewController {

    private lazy var alternativesTableView: UITableView = {
        
        
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.separatorStyle = .none
        tv.register(FlightDetailCell.self, forCellReuseIdentifier: FlightDetailCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    private lazy var loadingScreenView = LoadingView(frame: UIScreen.main.bounds)

    private var flightDetails: FlightDetails?
    private var betterFlightOptions: [(DelayPrediction?, FlightDetails)] = []
    private var chosenFlight: (DelayPrediction?, FlightDetails)? = nil
    private var onReplaceFlight: ((FlightDetails) -> ())? = nil
    private var isLoading: Bool = false { didSet { didUpdateIsViewLoading() } }

    init(
        currentFlightOption: FlightDetails,
        betterFlightOptions: [(DelayPrediction?, FlightDetails)],
        onReplaceFlight: ((FlightDetails) -> ())?
    ) {
        super.init(nibName: nil, bundle: nil)
        self.title = "Alternative flights"
        self.flightDetails = currentFlightOption
        self.betterFlightOptions = betterFlightOptions
        self.onReplaceFlight = onReplaceFlight
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUpViews() {
        self.view.addSubview(alternativesTableView)
        self.view.addSubview(loadingScreenView)
        self.alternativesTableView.reloadData()
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
     
            alternativesTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            alternativesTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: alternativesTableView.trailingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: alternativesTableView.bottomAnchor)
     
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
    
    private func placeOrder() {
        guard let flightDetails = self.chosenFlight else { return }
        Constants.placeFlightOrder(
            for: .init(data: .init(flightOffers: [flightDetails.1])),
            completion: onFlightOrderCompletion,
            onError: onFlightOrderError)
    }
    
    private func createAlert(title: String? = nil, message: String? = nil, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        return alert
    }
    
    private func confirmChoice() {
        guard let chosenFlight = chosenFlight, let delayPrediction = chosenFlight.0 else { return }
        let newDelayPrediction = "\(delayPrediction.probability.integerValue)% chance of being \(delayPrediction.result.description)"
        DispatchQueue.main.async {
            let alert = self.createAlert(
                title: "Delay prediction for this flight:",
                message: "\n\(newDelayPrediction)\n\nAre you sure you want to replace your flight with the one you selected?",
                actions: [
                    UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        self.isLoading = true
                        self.placeOrder()
                    }),
                    UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                        self.chosenFlight = nil
                    })
                ])
            self.present(alert, animated: true)
        }
    }
    
    private lazy var onFlightOrderCompletion: (FlightOrderCreateQuery) -> Void = { [weak self] response in
        guard let self = self,
            let previousFlight = self.flightDetails,
            let index = Constants.bookedFlights.firstIndex(where: { $0 == previousFlight })
        else { return }
        Constants.bookedFlights.remove(at: index)
        Constants.bookedFlights.append(contentsOf: response.flightOffers)
        DispatchQueue.main.async {
            self.isLoading = false
            let alert = self.createAlert(
                title: "Success!",
                message: "You booked your flight! You can find it in the History section.",
                actions: [
                    UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.onReplaceFlight?(previousFlight)
                        self.navigationController?.popViewController(animated: true)
                    })
                ])
            let imageView = UIImageView(frame: CGRect(x: 50, y: 20, width: 22, height: 22))
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
            alert.view.addSubview(imageView)
            self.present(alert, animated: true)
        }
    }
    
    private lazy var onFlightOrderError: (String) -> Void = { [weak self] errorDescription in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.isLoading = false
            let alert = self.createAlert(
                title: "Error",
                message: "We were unable to retrieve the data for the following reason(s):\n\n\(errorDescription)\n\nPlease try again later.",
                actions: [UIAlertAction(title: "OK", style: .cancel)])
            self.present(alert, animated: true)
        }
     
    }

}

extension FindAlternativeFlightViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : betterFlightOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let flightDetails = flightDetails,
                let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell
            else { return UITableViewCell() }
            cell.configure(
                with: flightDetails
            )
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            return cell
        default:
            let betterOption = self.betterFlightOptions[indexPath.row].1
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell
            else { return UITableViewCell() }
            cell.configure(
                with: betterOption
            )
            return cell
        }
     
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Your current flight"
        default:
            return "Alternatives"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            self.chosenFlight = betterFlightOptions[indexPath.row]
            self.confirmChoice()
        }
    }
    
}
