//
//  MainTableViewController.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 03.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import UIKit

protocol MainTableViewControllerDelegate {
    func getValuesFromCells() -> (value: Int, cellTag: Int)
}

class MainTableViewController: UITableViewController, SettingsTableViewCellDelegate {
    
    var floorsCount: Int? = 0
    var floorHeight: Int? = 0
    var elevatorSpeed: Int? = 0
    var openDoorsTime: Int? = 0
    var closeDoorsTime: Int? = 0
    var floorNumber: Int? = 0

    let cellId = "settings_cell"
    
    let itemsTitles = [["Количествово этажей":"От 5 до 20"],
                       ["Высота одного этажа":"От 2 метров"],
                       ["Скорость лифта при движении":"м/с"],
                       ["Время на открытие дверей":"Секунды"],
                       ["Время на закрытие дверей":"Секунды"],
                       ["Номер этажа":"Число"]] as [Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
        setupTableView()
        setupTableFooterView()
    }

    fileprivate func applyUI() {
        title = "Настройки"
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = Constants.appicationColors.mainAppColor
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.estimatedRowHeight = 40.0;
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func setupTableFooterView() {
        let callFromEntranceButton = CustomButton(type: .system)
        callFromEntranceButton.setTitle("Из подъезда".uppercased(), for: .normal)
        callFromEntranceButton.backgroundColor = UIColor(red:0.17, green:0.86, blue:0.40, alpha:1.00)
        callFromEntranceButton.addTarget(self, action: #selector(callFromEntranceButtonAction), for: .touchUpInside)
        
        let callFromElevatorButton = CustomButton(type: .system)
        callFromElevatorButton.setTitle("Из лифта".uppercased(), for: .normal)
        callFromElevatorButton.backgroundColor = UIColor(red:1.00, green:0.15, blue:0.21, alpha:1.00)
        callFromElevatorButton.addTarget(self, action: #selector(callFromElevatorButtonAction), for: .touchUpInside)
        
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 90))
        tableFooterView.addSubview(callFromEntranceButton)
        tableFooterView.addSubview(callFromElevatorButton)
        
        let padding: CGFloat = 15
        
        callFromEntranceButton.anchor(top: nil, left: tableFooterView.leftAnchor, buttom: nil, right: nil, paddingTop: 0, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: tableFooterView.frame.size.width / 2 - padding - (padding / 2), height: 42)
        callFromEntranceButton.centerYAnchor.constraint(equalTo: tableFooterView.centerYAnchor).isActive = true
        
        callFromElevatorButton.anchor(top: nil, left: nil, buttom: nil, right: tableFooterView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: padding, width: tableFooterView.frame.size.width / 2 - padding - (padding / 2), height: 42)
        callFromElevatorButton.centerYAnchor.constraint(equalTo: tableFooterView.centerYAnchor).isActive = true
        
        tableView.tableFooterView = tableFooterView
    }
    
    // PRAGMA - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SettingsTableViewCell
        cell.delegate = self
        let titleDictionary = itemsTitles[indexPath.row] as? [String: String]
        let title = titleDictionary?.keys.first
        let placeholder = titleDictionary?.values.first
        cell.titleLabel.text = title
        cell.textField.placeholder = placeholder
        cell.tag = indexPath.row
        return cell
    }
    
    // PRAGMA - SettingsTableViewCellDelegate
    
    func didSetValueInInput(value: Int, cellTag: Int) {
        switch cellTag {
        case 0:
            floorsCount = value
            break
        case 1:
            floorHeight = value
            break
        case 2:
            elevatorSpeed = value
            break
        case 3:
            openDoorsTime = value
            break
        case 4:
            closeDoorsTime = value
            break
        case 5:
            floorNumber = value
            break
        default:
            break
        }
    }
    
    // PRAGMA - Actions
    
    @objc fileprivate func callFromEntranceButtonAction() {
        view.endEditing(true)
        callElevator(side: .outSide)
    }
    
    @objc fileprivate func callFromElevatorButtonAction() {
        callElevator(side: .inSide)
    }
    
    fileprivate func callElevator(side: CallSide) {
        guard let guardFloorsCount = floorsCount, guardFloorsCount > 0 else {return }
        guard let guardFloorHeight = floorHeight, guardFloorHeight > 0 else {return }
        guard let guardElevatorSpeed = elevatorSpeed, guardElevatorSpeed > 0 else {return }
        guard let guardOpenDoorsTime = openDoorsTime, guardOpenDoorsTime > 0 else {return }
        guard let guardCloseDoorsTime = closeDoorsTime, guardCloseDoorsTime > 0 else {return }
        guard let guardFloorNumber = floorNumber, guardFloorNumber > 0 else {return }
        
        ElevatorActions.shared.callElevator(side: side, speed: guardElevatorSpeed, floorNumber: guardFloorNumber, timeOpenDoors: guardOpenDoorsTime, timeCloseDoors: guardCloseDoorsTime, floosCount: guardFloorsCount, floorHeight: guardFloorHeight) { (resultString) in
            print(resultString)
        }
    }
}
