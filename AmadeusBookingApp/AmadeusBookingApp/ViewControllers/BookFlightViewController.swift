//
//  BookFlightViewController.swift
//  AmadeusBookingApp
//
//  Created by Margels on 22/10/23.
//

import Foundation
import UIKit

final class BookFlightViewController: UIViewController {
    
    private lazy var summaryTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.separatorStyle = .none
        tv.register(FlightDetailCell.self, forCellReuseIdentifier: FlightDetailCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .systemBackground
        return footerView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(confirmBookingFlight(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingScreenView = LoadingView(frame: UIScreen.main.bounds)
    
    private var flightDetails: FlightDetails?
    private var isLoading: Bool = false { didSet { didUpdateIsViewLoading() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your selection"
        
        setUpLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    init(flightDetails: FlightDetails) {
        super.init(nibName: nil, bundle: nil)
        self.flightDetails = flightDetails
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        
        self.view.addSubview(summaryTableView)
        self.view.addSubview(footerView)
        footerView.addSubview(continueButton)
        self.view.addSubview(loadingScreenView)
        
        self.setUpConstraints()
        
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            summaryTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            summaryTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: summaryTableView.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: summaryTableView.bottomAnchor),
            
            continueButton.topAnchor.constraint(equalTo: footerView.topAnchor),
            continueButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: continueButton.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: continueButton.bottomAnchor),
            
            footerView.heightAnchor.constraint(equalToConstant: 60),
            footerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        
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
    
    @objc private func confirmBookingFlight(sender: UIButton) {
        guard let flightDetails = flightDetails else { return }
        isLoading = true
        
        Constants.placeFlightOrder(
            for: .init(data: .init(flightOffers: [flightDetails])),
            completion: onFlightOrderCompletion,
            onError: onFlightOrderError
        )
    }
    
    private lazy var onFlightOrderCompletion: (FlightOrderCreateQuery) -> Void = { [weak self] response in
        guard let self = self else { return }
        Constants.bookedFlights.append(contentsOf: response.flightOffers)
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success!", message: "You booked your flight! You can find it in the History section.", preferredStyle: .alert)
            let imageView = UIImageView(frame: CGRect(x: 50, y: 20, width: 22, height: 22))
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
            alert.view.addSubview(imageView)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
    
    private lazy var onFlightOrderError: (String) -> Void = { [weak self] errorDescription in
        guard let self = self else { return }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "We were unable to retrieve the data for the following reason(s):\n\n\(errorDescription)\n\nPlease try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
        
    }
    
}


extension BookFlightViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let flightDetails = flightDetails,
              let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell
        else { return UITableViewCell() }
        cell.configure(
            with: flightDetails
        )
        return cell
    }
    
}
