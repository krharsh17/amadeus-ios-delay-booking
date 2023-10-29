//
//  SearchDetailsCell.swift
//  AmadeusBookingApp
//
//  Created by Margels on 03/10/23.
//

import Foundation
import UIKit

final class SearchDetailsCell: UITableViewCell {
    
    static let reuseIdentifier = "SearchDetailsCell"
    
    private lazy var verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var originLocationStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    
    private lazy var originLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "From:*"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var originLocationTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Origin..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var originLocationTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: AvailableLocations.allCases.map({ location in
            UIAction(title: location.rawValue, handler: { _ in
                self.originLocationTextField.text = location.rawValue
                self.isSearchButtonEnabled()
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        return tf
    }()
    
    private lazy var destinationLocationStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var destinationLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "To:*"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = " Destination..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var destinationLocationTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: AvailableLocations.allCases.map({ location in
            UIAction(title: location.rawValue, handler: { _ in
                self.destinationLocationTextField.text = location.rawValue
                self.isSearchButtonEnabled()
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        return tf
    }()
    
    private lazy var departureDateStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var departureDateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Departure:*"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var departureDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = .now
        picker.datePickerMode = .date
        picker.contentHorizontalAlignment = .leading
        return picker
    }()
    
    private lazy var returnDateStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var returnDateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Return:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var returnDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .automatic
        picker.minimumDate = departureDatePicker.date
        picker.datePickerMode = .date
        picker.contentHorizontalAlignment = .leading
        picker.alpha = 0
        return picker
    }()
    
    private lazy var oneWayTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "One\nway"
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var oneWayToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(didTapOneWayToggle(sender:)), for: .touchUpInside)
        return toggle
    }()
    
    private lazy var adultsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var adultsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Passengers:*"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var adultsTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Number of adults..."
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var adultsTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: (0...10).map({ number in
            UIAction(title: "\(number)", handler: { _ in
                self.adultsTextField.text = number.string
                self.isSearchButtonEnabled()
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        return tf
    }()
    
    private lazy var childrenStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var childrenTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Children:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var childrenTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Number of children..."
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var childrenTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: (0...10).map({ number in
            UIAction(title: "\(number)", handler: { _ in
                self.childrenTextField.text = number.string
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        return tf
    }()
    
    private lazy var infantsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var infantsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Infants:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var infantsTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Number of infants..."
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var infantsTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: (0...10).map({ number in
            UIAction(title: "\(number)", handler: { _ in
                self.infantsTextField.text = number.string
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        return tf
    }()
    
    private lazy var travelClassStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var travelClassTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Travel Class:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var travelClassTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Travel class..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var travelClassTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: TravelClass.allCases.map({ travelClass in
            UIAction(title: travelClass.description, handler: { _ in
                self.travelClassTextField.text = travelClass.description
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        return tf
    }()
    
    private lazy var includedAirlineStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var includedAirlineTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Include Airline:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var includedAirlineTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Airline code..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var excludedAirlineStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var excludedAirlineTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Exclude Airline:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var excludedAirlineTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Airline code..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var nonStopStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var nonStopTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Non stop:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var nonStopToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = false
        return toggle
    }()
    
    private lazy var currencyCodeStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    private lazy var currencyCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Currency:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var currencyCodeTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Currency code..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var currencyTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: AvailableCurrencies.allCases.map({ currency in
            UIAction(title: currency.rawValue, handler: { _ in
                self.currencyCodeTextField.text = currency.rawValue
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        return tf
    }()
    
    private lazy var maxPriceStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    
    private lazy var maxPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Max price:"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var maxPriceTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Amount..."
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    private lazy var moreFiltersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var moreFiltersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.label, for: .normal)
        button.setTitle("+", for: .normal)
        button.setTitle("⌃", for: .selected)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        button.addTarget(self, action: #selector(didSelectMoreFiltersButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(didTapSearchButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    var tableView: UITableView?
    var onSearchTapped: ((GetFlightOffersBody)->Void)?
    
    lazy var hiddenSections = [childrenStackView, infantsStackView, travelClassStackView, includedAirlineStackView, excludedAirlineStackView, nonStopStackView, currencyCodeStackView, maxPriceStackView]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpLayout()
        hidesOptionalFields()
        isSearchButtonEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(originLocationStackView)
        originLocationStackView.addArrangedSubview(originLocationTitleLabel)
        originLocationStackView.addArrangedSubview(originLocationTextField)
        originLocationTextField.addSubview(originLocationTextFieldOptions)
        
        verticalStackView.addArrangedSubview(destinationLocationStackView)
        destinationLocationStackView.addArrangedSubview(destinationLocationTitleLabel)
        destinationLocationStackView.addArrangedSubview(destinationLocationTextField)
        destinationLocationTextField.addSubview(destinationLocationTextFieldOptions)
        
        verticalStackView.addArrangedSubview(departureDateStackView)
        departureDateStackView.addArrangedSubview(departureDateTitleLabel)
        departureDateStackView.addArrangedSubview(departureDatePicker)
        
        verticalStackView.addArrangedSubview(returnDateStackView)
        returnDateStackView.addArrangedSubview(returnDateTitleLabel)
        returnDateStackView.addArrangedSubview(returnDatePicker)
        returnDateStackView.addArrangedSubview(oneWayTitleLabel)
        returnDateStackView.addArrangedSubview(oneWayToggle)
        
        verticalStackView.addArrangedSubview(adultsStackView)
        adultsStackView.addArrangedSubview(adultsTitleLabel)
        adultsStackView.addArrangedSubview(adultsTextField)
        adultsTextField.addSubview(adultsTextFieldOptions)
        
        verticalStackView.addArrangedSubview(childrenStackView)
        childrenStackView.addArrangedSubview(childrenTitleLabel)
        childrenStackView.addArrangedSubview(childrenTextField)
        childrenTextField.addSubview(childrenTextFieldOptions)
        
        verticalStackView.addArrangedSubview(infantsStackView)
        infantsStackView.addArrangedSubview(infantsTitleLabel)
        infantsStackView.addArrangedSubview(infantsTextField)
        infantsTextField.addSubview(infantsTextFieldOptions)
        
        verticalStackView.addArrangedSubview(travelClassStackView)
        travelClassStackView.addArrangedSubview(travelClassTitleLabel)
        travelClassStackView.addArrangedSubview(travelClassTextField)
        travelClassTextField.addSubview(travelClassTextFieldOptions)
        
        verticalStackView.addArrangedSubview(includedAirlineStackView)
        includedAirlineStackView.addArrangedSubview(includedAirlineTitleLabel)
        includedAirlineStackView.addArrangedSubview(includedAirlineTextField)
        
        verticalStackView.addArrangedSubview(excludedAirlineStackView)
        excludedAirlineStackView.addArrangedSubview(excludedAirlineTitleLabel)
        excludedAirlineStackView.addArrangedSubview(excludedAirlineTextField)
        
        verticalStackView.addArrangedSubview(nonStopStackView)
        nonStopStackView.addArrangedSubview(nonStopTitleLabel)
        nonStopStackView.addArrangedSubview(nonStopToggle)
        
        verticalStackView.addArrangedSubview(currencyCodeStackView)
        currencyCodeStackView.addArrangedSubview(currencyCodeTitleLabel)
        currencyCodeStackView.addArrangedSubview(currencyCodeTextField)
        currencyCodeTextField.addSubview(currencyTextFieldOptions)
        
        verticalStackView.addArrangedSubview(maxPriceStackView)
        maxPriceStackView.addArrangedSubview(maxPriceTitleLabel)
        maxPriceStackView.addArrangedSubview(maxPriceTextField)
        
        verticalStackView.addArrangedSubview(moreFiltersView)
        moreFiltersView.addSubview(moreFiltersButton)
        
        verticalStackView.addArrangedSubview(searchView)
        searchView.addSubview(searchButton)
        
        contentView.addSubview(separatorView)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.contentView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 20),
            separatorView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 24),
            
            originLocationStackView.heightAnchor.constraint(equalToConstant: 30),
            originLocationTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            originLocationTextFieldOptions.topAnchor.constraint(equalTo: originLocationTextField.topAnchor),
            originLocationTextFieldOptions.leadingAnchor.constraint(equalTo: originLocationTextField.leadingAnchor),
            originLocationTextField.trailingAnchor.constraint(equalTo: originLocationTextFieldOptions.trailingAnchor),
            originLocationTextField.bottomAnchor.constraint(equalTo: originLocationTextFieldOptions.bottomAnchor),
            
            destinationLocationStackView.heightAnchor.constraint(equalToConstant: 30),
            destinationLocationTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            destinationLocationTextFieldOptions.topAnchor.constraint(equalTo: destinationLocationTextField.topAnchor),
            destinationLocationTextFieldOptions.leadingAnchor.constraint(equalTo: destinationLocationTextField.leadingAnchor),
            destinationLocationTextField.trailingAnchor.constraint(equalTo: destinationLocationTextFieldOptions.trailingAnchor),
            destinationLocationTextField.bottomAnchor.constraint(equalTo: destinationLocationTextFieldOptions.bottomAnchor),
            
            departureDateStackView.heightAnchor.constraint(equalToConstant: 30),
            departureDateTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            returnDateStackView.heightAnchor.constraint(equalToConstant: 30),
            returnDateTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            adultsStackView.heightAnchor.constraint(equalToConstant: 30),
            adultsTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            adultsTextFieldOptions.topAnchor.constraint(equalTo: adultsTextField.topAnchor),
            adultsTextFieldOptions.leadingAnchor.constraint(equalTo: adultsTextField.leadingAnchor),
            adultsTextField.trailingAnchor.constraint(equalTo: adultsTextFieldOptions.trailingAnchor),
            adultsTextField.bottomAnchor.constraint(equalTo: adultsTextFieldOptions.bottomAnchor),
            
            childrenStackView.heightAnchor.constraint(equalToConstant: 30),
            childrenTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            childrenTextFieldOptions.topAnchor.constraint(equalTo: childrenTextField.topAnchor),
            childrenTextFieldOptions.leadingAnchor.constraint(equalTo: childrenTextField.leadingAnchor),
            childrenTextField.trailingAnchor.constraint(equalTo: childrenTextFieldOptions.trailingAnchor),
            childrenTextField.bottomAnchor.constraint(equalTo: childrenTextFieldOptions.bottomAnchor),
            
            infantsStackView.heightAnchor.constraint(equalToConstant: 30),
            infantsTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            infantsTextFieldOptions.topAnchor.constraint(equalTo: infantsTextField.topAnchor),
            infantsTextFieldOptions.leadingAnchor.constraint(equalTo: infantsTextField.leadingAnchor),
            infantsTextField.trailingAnchor.constraint(equalTo: infantsTextFieldOptions.trailingAnchor),
            infantsTextField.bottomAnchor.constraint(equalTo: infantsTextFieldOptions.bottomAnchor),
            
            travelClassStackView.heightAnchor.constraint(equalToConstant: 30),
            travelClassTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            travelClassTextFieldOptions.topAnchor.constraint(equalTo: travelClassTextField.topAnchor),
            travelClassTextFieldOptions.leadingAnchor.constraint(equalTo: travelClassTextField.leadingAnchor),
            travelClassTextField.trailingAnchor.constraint(equalTo: travelClassTextFieldOptions.trailingAnchor),
            travelClassTextField.bottomAnchor.constraint(equalTo: travelClassTextFieldOptions.bottomAnchor),
            
            includedAirlineStackView.heightAnchor.constraint(equalToConstant: 30),
            includedAirlineTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            excludedAirlineStackView.heightAnchor.constraint(equalToConstant: 30),
            excludedAirlineTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            nonStopStackView.heightAnchor.constraint(equalToConstant: 30),
            nonStopTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            currencyCodeStackView.heightAnchor.constraint(equalToConstant: 30),
            currencyCodeTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            currencyTextFieldOptions.topAnchor.constraint(equalTo: currencyCodeTextField.topAnchor),
            currencyTextFieldOptions.leadingAnchor.constraint(equalTo: currencyCodeTextField.leadingAnchor),
            currencyCodeTextField.trailingAnchor.constraint(equalTo: currencyTextFieldOptions.trailingAnchor),
            currencyCodeTextField.bottomAnchor.constraint(equalTo: currencyTextFieldOptions.bottomAnchor),
            
            maxPriceStackView.heightAnchor.constraint(equalToConstant: 30),
            maxPriceTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            moreFiltersButton.topAnchor.constraint(equalTo: moreFiltersView.topAnchor),
            moreFiltersButton.leadingAnchor.constraint(equalTo: moreFiltersView.leadingAnchor),
            moreFiltersView.trailingAnchor.constraint(equalTo: moreFiltersButton.trailingAnchor),
            moreFiltersView.bottomAnchor.constraint(equalTo: moreFiltersButton.bottomAnchor),
            moreFiltersView.heightAnchor.constraint(equalToConstant: 20),
            
            searchButton.widthAnchor.constraint(equalToConstant: 250),
            searchButton.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 40),
            
            separatorView.heightAnchor.constraint(equalToConstant: 16),
            separatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor)
        
        ])
        
    }
    
    private func hidesOptionalFields() {
        hiddenSections.forEach { $0.isHidden = !moreFiltersButton.isSelected }
    }
    
    private func isSearchButtonEnabled() {
        let isEnabled = originLocationTextField.text != "" && originLocationTextField.text != nil && destinationLocationTextField.text != "" && destinationLocationTextField.text != nil && adultsTextField.text != "" && adultsTextField.text != nil &&
        (adultsTextField.text != "0" || (childrenTextField.text != "0" && childrenTextField.text != "") || (infantsTextField.text != "0" && infantsTextField.text != ""))
        switch isEnabled {
        case true:
            searchButton.alpha = 1
            searchButton.isUserInteractionEnabled = true
        case false:
            searchButton.alpha = 0.5
            searchButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func didSelectMoreFiltersButton(sender: UIButton) {
        searchButton.alpha = 0
        sender.isSelected = !sender.isSelected
        hidesOptionalFields()
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
        UIView.animate(withDuration: 1, delay: 0.25) {
            self.searchButton.alpha = 1
        }
    }
    
    @objc private func didTapOneWayToggle(sender: UIButton) {
        returnDatePicker.alpha = oneWayToggle.isOn ? 0 : 1
        returnDatePicker.isUserInteractionEnabled = !oneWayToggle.isOn
    }
    
    @objc private func didTapSearchButton(sender: UIButton) {
        guard let originLocation = originLocationTextField.text,
              let originLocationCode = originLocation.split(separator: " - ").first?.uppercased(),
              let destinationLocation = destinationLocationTextField.text,
              let destinationLocationCode = destinationLocation.split(separator: " - ").first?.uppercased(),
              let passengers = adultsTextField.text, passengers != ""
        else { return }
        
        var flightOriginDestinations: [FlightOriginDestinations] = [
            .init(
                id: "1",
                originLocationCode: originLocationCode,
                destinationLocationCode: destinationLocationCode,
                departureDateTimeRange: .init(
                    date: departureDatePicker.date.yyyyMMdd,
                    time: "00:00:00"))
        ]
        
        if !oneWayToggle.isOn, returnDatePicker.date > departureDatePicker.date {
            flightOriginDestinations.append(
                .init(
                    id: "2",
                    originLocationCode: destinationLocationCode,
                    destinationLocationCode: originLocationCode,
                    departureDateTimeRange: .init(
                        date: returnDatePicker.date.yyyyMMdd,
                        time: "00:00:00"))
            )
        }
        
        onSearchTapped?(.init(
            currencyCode: .init(from: currencyCodeTextField.text ?? ""),
            originDestinations: flightOriginDestinations,
            travelers: [.init(
                id: passengers,
                travelerType: .init(from: adultsTextField.text ?? ""))],
            sources: [.GDS],
            searchCriteria: .init(
                maxFlightOffers: 10,
                flightFilters: .init(
                    cabinRestrictions: [.init(
                        cabin: .init(from: travelClassTextField.text ?? ""),
                        coverage: .MOST_SEGMENTS,
                        originDestinationIds: ["1"])])))
        )
    }
    
    func configure(
        tableView: UITableView,
        onSearchTapped: ((GetFlightOffersBody)->Void)?
    ) {
        self.tableView = tableView
        self.onSearchTapped = onSearchTapped
    }
    
}
