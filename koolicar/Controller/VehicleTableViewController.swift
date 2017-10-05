//
//  VehicleTableViewController.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-02.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import UIKit
import CoreLocation

class VehicleTableViewController: UITableViewController {
    let cellReuseIdentifier = "VehicleTableViewCell"
    weak var delegate: VehicleSelectable?
    var vehicles: [Vehicle]? {
        didSet {
            if let vehicles = vehicles, vehicles.count > 0 {
                tableView.backgroundView = nil
                tableView.reloadData()
                tableView.separatorColor = .gray
            }
            else if let signView = Bundle.main.loadNibNamed("SignView", owner: self, options: nil)?.first as? SignView {
                signView.titleLabel.text = "No result".localizedCapitalized
                signView.subtitleLabel.text = "No vehicle available in this region".localizedCapitalized
                tableView.backgroundView = signView
                tableView.separatorColor = .clear
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        tableView.separatorColor = .clear
    }
    
    func getVehicleAtRow(indexRow: Int) -> Vehicle? {
        return vehicles?[indexRow] ?? nil
    }
}

// MARK: Datasource
extension VehicleTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? VehicleTableViewCell else {
            fatalError("The cell is not properly registered")
        }
        if let vehicle = getVehicleAtRow(indexRow: indexPath.row) {
            cell.loadData(vehicle: vehicle)
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = .zero
        cell.layoutMargins = .zero

        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let vehicles = vehicles, vehicles.count > 0 else { return 0 }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vehicles = vehicles else { return 0 }
        return vehicles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: TableViewDelegate
extension VehicleTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vehicle = getVehicleAtRow(indexRow: indexPath.row)  else { return }
        delegate?.vehicleDidSelected(vehicle: vehicle)
    }
}
