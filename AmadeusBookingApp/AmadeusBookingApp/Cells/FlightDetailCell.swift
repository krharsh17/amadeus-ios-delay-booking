//
//  FlightDetailCell.swift
//  AmadeusBookingApp
//
//  Created by Margels on 02/10/23.
//

import Foundation
import UIKit

final class FlightDetailCell: UITableViewCell {
    
    static let reuseIdentifier = "FlightDetailCell"
    
    private lazy var noFlightsFoundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var noFlightsFoundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No flights found."
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var containerVerticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var flightInformationView: FlightInformationView = {
        let view = FlightInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "🛫 Departing flight"
        return view
    }()
    
    private lazy var returnFlightInformationView: FlightInformationView = {
        let view = FlightInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "🛬 Returning flight"
        return view
    }()
    
    private lazy var priceHorizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Total"
        label.textAlignment = .right
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var paddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var separatorContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var flightDetails: FlightDetails?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        
        contentView.addSubview(containerVerticalStackView)
        
        containerVerticalStackView.addArrangedSubview(flightInformationView)
        containerVerticalStackView.addArrangedSubview(returnFlightInformationView)
        
        containerVerticalStackView.addArrangedSubview(paddingView)
        
        containerVerticalStackView.addArrangedSubview(priceHorizontalStackView)
        priceHorizontalStackView.addArrangedSubview(totalLabel)
        priceHorizontalStackView.addArrangedSubview(priceLabel)
        
        containerVerticalStackView.addArrangedSubview(separatorContainerView)
        separatorContainerView.addSubview(separatorView)
        
        contentView.addSubview(noFlightsFoundView)
        noFlightsFoundView.addSubview(noFlightsFoundLabel)
        contentView.bringSubviewToFront(noFlightsFoundView)
        noFlightsFoundView.isHidden = true
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            noFlightsFoundView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            noFlightsFoundView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
            self.contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: noFlightsFoundView.trailingAnchor),
            self.contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: noFlightsFoundView.bottomAnchor),
            
            noFlightsFoundLabel.topAnchor.constraint(equalTo: noFlightsFoundView.topAnchor),
            noFlightsFoundLabel.leadingAnchor.constraint(equalTo: noFlightsFoundView.leadingAnchor),
            noFlightsFoundView.trailingAnchor.constraint(equalTo: noFlightsFoundLabel.trailingAnchor),
            noFlightsFoundView.bottomAnchor.constraint(equalTo: noFlightsFoundLabel.bottomAnchor),
        
            containerVerticalStackView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            self.contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: containerVerticalStackView.trailingAnchor, constant: 15),
            self.contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: containerVerticalStackView.bottomAnchor, constant: 15),
            
            paddingView.heightAnchor.constraint(equalToConstant: 16),
            
            separatorContainerView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.topAnchor.constraint(equalTo: separatorContainerView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: separatorContainerView.leadingAnchor, constant: 48),
            separatorContainerView.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 48),
            separatorContainerView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor)
        
        ])
        
    }
    
    func configure(
        with flightDetails: FlightDetails?
    ) {
        guard let flightDetails = flightDetails else {
            self.noFlightsFoundView.isHidden = false
            self.isUserInteractionEnabled = false
            return
        }
        
        self.flightDetails = flightDetails
        self.noFlightsFoundView.isHidden = true
        self.isUserInteractionEnabled = true
        
        flightInformationView.segments = flightDetails.itineraries[0].segments
        if flightDetails.itineraries.count > 1 { returnFlightInformationView.segments = flightDetails.itineraries[1].segments }
        returnFlightInformationView.isHidden = flightDetails.itineraries.count < 2
        priceLabel.text = "\(flightDetails.price.total) \(AvailableCurrencies(from: flightDetails.price.currency).symbol)"
    }
    
}
