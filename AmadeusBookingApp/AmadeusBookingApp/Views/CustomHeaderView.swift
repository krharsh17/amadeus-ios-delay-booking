import Foundation
import UIKit

final class CustomHeaderView: UIView {
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fill
        return sv
    }()
    
    var finalPrediction = ""
        var probabilityAndResult: (Int, String, PredictionResultType) = (0, "", .LESS_THAN_30_MINUTES) { didSet { didUpdateProbabilityAndResult() } }
    
    private lazy var warningLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .secondaryLabel
        l.text = initialText
        l.numberOfLines = 0
        l.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return l
    }()
    
    private lazy var clickHereButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.blue, for: .normal)
        b.setTitle("Click here to find alternatives →", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        b.titleLabel?.textAlignment = .left
        b.addTarget(self, action: #selector(didClickSearchAlternatives), for: .touchUpInside)
        return b
    }()
    
    var initialText = "No delay prediction available for this flight."
    var onTapClickHere: ((Int) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetText() {
        warningLabel.text = initialText
    }
    
    private func setUpLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(warningLabel)
        stackView.addArrangedSubview(clickHereButton)
        clickHereButton.isHidden = true
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
     
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 30),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
         
        ])
    }

    private func didUpdateProbabilityAndResult() {
         
            let index = probabilityAndResult.0
            let probability = probabilityAndResult.1.integerValue
            let result = probabilityAndResult.2
         
            DispatchQueue.main.async {
                let newLine = self.finalPrediction == "" ? "" : "\n"
                var prediction = "\(newLine)Flight no. \(index) has \(probability)% chance of being \(result.description)"
             
                switch (probability, result) {
                case (_, .LESS_THAN_30_MINUTES):
                    prediction = "\(newLine)Flight no. \(index) is usually on time"
                    self.warningLabel.textColor = .systemGreen
                    self.clickHereButton.isHidden = true
                case ((0...29), .BETWEEN_30_AND_60_MINUTES):
                    self.warningLabel.textColor = .systemOrange
                    self.clickHereButton.isHidden = self.onTapClickHere == nil
                default:
                    self.warningLabel.textColor = .systemRed
                    self.clickHereButton.isHidden = self.onTapClickHere == nil
                }
             
                self.finalPrediction.append(prediction)
                self.warningLabel.text = self.finalPrediction
            }

        }
    
    @objc private func didClickSearchAlternatives() {
        self.onTapClickHere?(self.tag-100)
    }
    
}
