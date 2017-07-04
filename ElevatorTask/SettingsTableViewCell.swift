//
//  SettingsTableViewCell.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 04.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import UIKit

fileprivate let MIN_FLOORS_COUNT = 5
fileprivate let MAX_FLOORS_COUNT = 20

class SettingsTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let floosCountTitleLabel: CustomTitleLabel = {
        let label = CustomTitleLabel()
        label.text = "Количество этажей (\(MIN_FLOORS_COUNT))"
        return label
    }()
    
    lazy var floosCountSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Float(MIN_FLOORS_COUNT)
        slider.maximumValue = Float(MAX_FLOORS_COUNT)
        slider.tintColor = UIColor(red:0.17, green:0.86, blue:0.40, alpha:1.00)
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return slider
    }()
    
    let floorHeightTitleLabel: CustomTitleLabel = {
        let label = CustomTitleLabel()
        label.text = "Высота одного этажа"
        return label
    }()
    
    lazy var floorHeightTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.placeholder = "Высота в метрах (от 2 м)"
        field.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return field
    }()
    
    let elevatorSpeedTitleLabel: CustomTitleLabel = {
        let label = CustomTitleLabel()
        label.text = "Постоянная скорость лифта"
        return label
    }()
    
    lazy var elevatorSpeedTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.placeholder = "Скорость (м/с)"
        field.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return field
    }()
    
    let elevatorDoorsSpeedTitleLabel: CustomTitleLabel = {
        let label = CustomTitleLabel()
        label.text = "Время между открытием и закрытием дверей"
        return label
    }()
    
    lazy var elevatorDoorsSpeedTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.placeholder = "Время в секундах"
        field.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return field
    }()
    
    let needdedFloorNumberTitleLabel: CustomTitleLabel = {
        let label = CustomTitleLabel()
        label.text = "Номер этажа"
        return label
    }()
    
    lazy var needdedFloorNumberTextField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
        field.placeholder = "Число"
        field.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return field
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyUI()
    }

    fileprivate func applyUI() {
        backgroundColor = Constants.appicationColors.mainAppColor
        selectionStyle = .none
        
        addSubview(floosCountTitleLabel)
        addSubview(floosCountSlider)
        addSubview(floorHeightTitleLabel)
        addSubview(floorHeightTextField)
        addSubview(elevatorSpeedTitleLabel)
        addSubview(elevatorSpeedTextField)
        addSubview(elevatorDoorsSpeedTitleLabel)
        addSubview(elevatorDoorsSpeedTextField)
        addSubview(needdedFloorNumberTitleLabel)
        addSubview(needdedFloorNumberTextField)
        
        floosCountTitleLabel.anchor(top: topAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 25, paddingLeft: 22, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        floosCountSlider.anchor(top: floosCountTitleLabel.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        floorHeightTitleLabel.anchor(top: floosCountSlider.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 22, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        floorHeightTextField.anchor(top: floorHeightTitleLabel.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 42)
        elevatorSpeedTitleLabel.anchor(top: floorHeightTextField.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 22, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        elevatorSpeedTextField.anchor(top: elevatorSpeedTitleLabel.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 42)
        elevatorDoorsSpeedTitleLabel.anchor(top: elevatorSpeedTextField.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 22, paddingBottom: 0, paddingRight: 15, width: 0, height: 21)
        elevatorDoorsSpeedTextField.anchor(top: elevatorDoorsSpeedTitleLabel.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 42)
        
        needdedFloorNumberTitleLabel.anchor(top: elevatorDoorsSpeedTextField.bottomAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 22, paddingBottom: 0, paddingRight: 15, width: 0, height: 21)
        needdedFloorNumberTextField.anchor(top: needdedFloorNumberTitleLabel.bottomAnchor, left: leftAnchor, buttom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: 0, height: 42)
    }
    
    // PRAGMA - Events
    
    @objc fileprivate func sliderChanged(slider: UISlider) {
        floosCountTitleLabel.text = String(format: "Количество этажей (%.f)", slider.value)
    }
    
    @objc fileprivate func textFieldChanged(textField: UITextField) {
        if (textField.text?.hasPrefix("0"))! || (textField == floorHeightTextField && textField.text == "1") {
            textField.text?.characters.remove(at: (textField.text?.startIndex)!)
        }
    }
    
    // PRAGMA - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Restricting field to take only numbers
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
