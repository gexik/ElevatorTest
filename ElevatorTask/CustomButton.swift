//
//  CustomButton.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 04.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit(){
        setTitleColor(Constants.appicationColors.mainFontColor, for: .normal)
        titleLabel?.font = Constants.appicationFonts.mainFont
        layer.cornerRadius = 5
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
