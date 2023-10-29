//
//  LoadingView.swift
//  AmadeusBookingApp
//
//  Created by Margels on 23/10/23.
//

import Foundation
import UIKit

final class LoadingView: UIView {
    
    private lazy var loadingText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Loading..."
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.textColor = .label
        view.textAlignment = .center
        return view
    }()
    
    private var superView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        
        self.backgroundColor = .systemBackground
        self.alpha = 0
        self.isUserInteractionEnabled = false
        
        self.addSubview(loadingText)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
//        guard let superview = superView else { return }
        
        NSLayoutConstraint.activate([
            
//            self.topAnchor.constraint(equalTo: superview.topAnchor),
//            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
//            superview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            superview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        
            loadingText.topAnchor.constraint(equalTo: self.topAnchor),
            loadingText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.trailingAnchor.constraint(equalTo: loadingText.trailingAnchor, constant: 30),
            self.bottomAnchor.constraint(equalTo: loadingText.bottomAnchor, constant: 30)
        
        ])
        
    }
    
}
