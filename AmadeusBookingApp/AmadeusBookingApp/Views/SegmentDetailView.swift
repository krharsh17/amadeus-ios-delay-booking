//
//  SegmentDetailView.swift
//  AmadeusBookingApp
//
//  Created by Margels on 16/10/23.
//

import Foundation
import UIKit

final class SegmentDetailView: UIView {
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.spacing = 16
        return sv
    }()
    
    private lazy var firstLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = .label
        return l
    }()
    
    private lazy var secondLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = .label
        l.textAlignment = .left
        return l
    }()
    
    private lazy var thirdLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .label
        l.textAlignment = .right
        l.text = nil
        return l
    }()
    
    var airportDetails: AirportDetails? { didSet { didUpdateAirportDetails() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpLayout() {
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        stackView.addArrangedSubview(thirdLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            firstLabel.widthAnchor.constraint(equalToConstant: 40)
        
        ])
        
    }
    
    private func didUpdateAirportDetails() {
        guard let airportDetails = airportDetails else { return }
        self.firstLabel.text = airportDetails.iataCode
        self.secondLabel.text = airportDetails.at.datePrettyPrinted
        if let thirdLabelText = airportDetails.terminal { self.thirdLabel.text = "Terminal \(thirdLabelText)" }
        self.thirdLabel.isHidden = airportDetails.terminal == nil
    }
    
}
