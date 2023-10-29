//
//  HistoryViewController.swift
//  AmadeusBookingApp
//
//  Created by Margels on 03/10/23.
//

import UIKit

final class HistoryViewController: UIViewController {
    
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
    
    var bookedFlights: [FlightDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your bookings"
        
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bookedFlights = Constants.bookedFlights
        didUpdateFlightsBooked()
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
    
    private func didUpdateFlightsBooked() {
        historyTableView.isHidden = bookedFlights.isEmpty
        noHistoryLabel.isHidden = !(bookedFlights.isEmpty)
        historyTableView.reloadData()
    }
    
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { bookedFlights.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell
        else { return UITableViewCell() }
        let flightDetails = bookedFlights[indexPath.row]
        cell.configure(
            with: flightDetails
        )
        return cell
    }
    
}
