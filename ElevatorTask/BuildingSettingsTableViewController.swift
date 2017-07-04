//
//  BuildingSettingsViewController.swift
//  ElevatorTask
//
//  Created by Roman Bogomolov on 03.07.17.
//  Copyright © 2017 Roman Bogomolov. All rights reserved.
//

import UIKit

class BuildingSettingsTableViewController: UITableViewController {

    let cellId = "settings_cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUI()
        setupTableView()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SettingsTableViewCell
        return cell
    }

}
