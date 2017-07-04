//
//  SettingsTableViewCell.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 04.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import UIKit

fileprivate let MIN_FLOORS_COUNT: Float = 5.0
fileprivate let MAX_FLOORS_COUNT: Float = 20.0

protocol SettingsTableViewCellDelegate {
    func didSetValueInInput(value: Float, cellTag: Float)
}

class SettingsTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: SettingsTableViewCellDelegate?
    
    let titleLabel: CustomTitleLabel = {
        let label = CustomTitleLabel()
        return label
    }()
    
    lazy var textField: CustomTextField = {
        let field = CustomTextField()
        field.delegate = self
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
        
        addSubview(titleLabel)
        addSubview(textField)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, buttom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 22, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        textField.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, buttom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 42)
    }
    
    // PRAGMA - Events
    
    @objc fileprivate func textFieldChanged(textField: UITextField) {
        if (textField.text?.hasPrefix("0"))! {
            textField.text?.characters.remove(at: (textField.text?.startIndex)!)
            return
        }
    }
    
    // PRAGMA - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)! > 0 {
            guard let floatNumber = Float(textField.text!) else {return}
            
            if (tag == 0 && (floatNumber < MIN_FLOORS_COUNT || floatNumber > MAX_FLOORS_COUNT) || tag == 1 && floatNumber == 1) && floatNumber > 0 {
                textField.text? = ""
                return
            }
            
            delegate?.didSetValueInInput(value: floatNumber, cellTag: Float(tag))
        } else {
            delegate?.didSetValueInInput(value: 0, cellTag: Float(tag))
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Restricting field to take only numbers
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
