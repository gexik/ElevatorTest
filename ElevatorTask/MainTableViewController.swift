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
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.appicationFonts.mainFont
        label.textColor = UIColor(red:1.00, green:0.81, blue:0.00, alpha:1.00)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var floorsCount: Float? = 0
    var floorHeight: Float? = 0
    var elevatorSpeed: Float? = 0
    var openDoorsTime: Float? = 0
    var closeDoorsTime: Float? = 0
    var floorNumber: Float? = 0

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
        registerNotifications()
    }
    
    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReciveNotification), name: NSNotification.Name(rawValue: "didReciveNotification"), object: nil)
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
        
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 120))
        tableFooterView.addSubview(callFromEntranceButton)
        tableFooterView.addSubview(callFromElevatorButton)
        tableFooterView.addSubview(infoLabel)
        
        infoLabel.anchor(top: tableFooterView.topAnchor, left: tableFooterView.leftAnchor, buttom: callFromEntranceButton.topAnchor, right: tableFooterView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
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
    
    func didSetValueInInput(value: Float, cellTag: Float) {
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
        view.endEditing(true)
        callElevator(side: .inSide)
    }
    
    fileprivate func callElevator(side: CallSide) {
        guard let guardFloorsCount = floorsCount, guardFloorsCount > 0 else {return }
        guard let guardFloorHeight = floorHeight, guardFloorHeight > 0 else {return }
        guard let guardElevatorSpeed = elevatorSpeed, guardElevatorSpeed > 0 else {return }
        guard let guardOpenDoorsTime = openDoorsTime, guardOpenDoorsTime > 0 else {return }
        guard let guardCloseDoorsTime = closeDoorsTime, guardCloseDoorsTime > 0 else {return }
        guard let guardFloorNumber = floorNumber, guardFloorNumber > 0 else {return }
        
        if guardFloorNumber > guardFloorsCount {
            let aletr = UIAlertController(title: nil, message: "Указанный номер этажа превышает общее кол-во этажей", preferredStyle: .alert)
            aletr.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(aletr, animated: true, completion: nil)
            return
        }
        
        ElevatorActions.shared.callElevator(side: side, speed: guardElevatorSpeed, floorNumber: guardFloorNumber, timeOpenDoors: guardOpenDoorsTime, timeCloseDoors: guardCloseDoorsTime, floosCount: guardFloorsCount, floorHeight: guardFloorHeight) { (resultString) in
            print(resultString)
        }
    }
    
    @objc fileprivate func didReciveNotification(notification: Notification) {
        guard let string = notification.object as? String else {return}
        infoLabel.text = string
        print(string)
    }
}
