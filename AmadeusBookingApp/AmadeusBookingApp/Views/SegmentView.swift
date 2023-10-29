//
//  SegmentView.swift
//  AmadeusBookingApp
//
//  Created by Margels on 16/10/23.
//

import Foundation
import UIKit

final class SegmentView: UIView {
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var segmentDepartureView: SegmentDetailView = {
        let view = SegmentDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var segmentArrivalView: SegmentDetailView = {
        let view = SegmentDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var segmentDetails: SegmentDetails? { didSet { didUpdateSegmentDetails() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(segmentDepartureView)
        stackView.addArrangedSubview(segmentArrivalView)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        
        ])
        
    }
    
    private func didUpdateSegmentDetails() {
        
        guard let segmentDetails = segmentDetails else { return }
        segmentDepartureView.airportDetails = segmentDetails.departure
        segmentArrivalView.airportDetails = segmentDetails.arrival
        
    }
    
}
