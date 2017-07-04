//
//  CustomTextField.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 03.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override var placeholder: String? {
        didSet {
            guard let text = placeholder else { return }
            attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        textAlignment = .left
        textColor = Constants.appicationColors.mainFontColor
        backgroundColor = Constants.appicationColors.mainTextFieldBackgroundColor
        borderStyle = .roundedRect
        keyboardAppearance = .dark
        keyboardType = .numberPad
        autocorrectionType = .no
        autocapitalizationType = .none
        clearButtonMode = .whileEditing
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
