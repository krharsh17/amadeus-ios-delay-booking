//
//  FlightInformationView.swift
//  AmadeusBookingApp
//
//  Created by Margels on 16/10/23.
//

import Foundation
import UIKit

final class FlightInformationView: UIView {
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .label
        l.textAlignment = .left
        return l
    }()
    
    private lazy var firstSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var firstLayoverLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        return l
    }()
    
    private lazy var secondSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondLayoverLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        return l
    }()
    
    private lazy var thirdSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var thirdLayoverLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        return l
    }()
    
    private lazy var fourthSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var segmentViews = [firstSegmentView, secondSegmentView, thirdSegmentView, fourthSegmentView]
    lazy var layoverViews = [firstLayoverLabel, secondLayoverLabel, thirdLayoverLabel]
    var segments: [SegmentDetails]? { didSet { didUpdateSegments() } }
    var title: String = "" { didSet { didUpdateTitle() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(firstSegmentView)
        stackView.addArrangedSubview(firstLayoverLabel)
        stackView.addArrangedSubview(secondSegmentView)
        stackView.addArrangedSubview(secondLayoverLabel)
        stackView.addArrangedSubview(thirdSegmentView)
        stackView.addArrangedSubview(thirdLayoverLabel)
        stackView.addArrangedSubview(fourthSegmentView)
        
        setUpConstraints()
        
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
        
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            self.titleLabel.heightAnchor.constraint(equalToConstant: 45)
        
        ])
        
    }
    
    private func didUpdateTitle() {
        titleLabel.text = title
    }
    
    private func didUpdateSegments() {
        
        guard let segments = segments else { return }
        
        for (index, segment) in segments.enumerated() where index < 4 {
            
            segmentViews[index].segmentDetails = segment
            segmentViews[index].isHidden = false
            if index < segments.count-1 {
                let departure = segments[index+1].departure.at.date
                let arrival = segment.arrival.at.date
                let difference = Calendar.current.dateComponents([.hour, .minute], from: arrival, to: departure)
                layoverViews[index].text = "layover \(difference.hour ?? 0) hrs \(difference.minute ?? 0) mins"
            } else {
                layoverViews[index].text = nil
            }
            
        }

        for index in 0..<(segmentViews.count-segments.count) {
            
            segmentViews.reversed()[index].isHidden = true
            
        }
        
    }
    
}
