//
//  ViewController.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-02.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import UIKit
import CoreLocation

protocol VehicleSelectable: NSObjectProtocol {
    func vehicleDidSelected(vehicle: Vehicle)
}

class HomeViewController: UIViewController {
    var selection: Selection = (true, true, true, true, true, true, true, true, true, true)
    var vehicles: [Vehicle]? {
        didSet {
            vehicleTableViewController.vehicles = vehicles
            vehicleMapViewController.vehicles = vehicles
        }
    }
    var listIsHidden: Bool = false {
        didSet {
            if let tableView = vehicleTableViewController.view {
                tableView.isHidden = listIsHidden
            }
            if let vehicleMapView = vehicleMapViewController.view {
                vehicleMapView.isHidden = !listIsHidden
            }
            if listIsHidden {
                toolbar.items = buttonsList
            } else {
                toolbar.items = buttonsMap
            }
        }
    }
    let vehicleTableViewController = VehicleTableViewController()
    let vehicleMapViewController = VehicleMapViewController()
    let activityIndicator =  UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let toolbar = UIToolbar()
    let buttonsList: [UIBarButtonItem]
    let buttonsMap: [UIBarButtonItem]
    
    required init?(coder aDecoder: NSCoder)
    {
        let filterButton: UIBarButtonItem = Style.barButton(imageName: "settings", title: "filter".localizedLowercase, frontColor: Style.purpleKoolicar(), backgroundColor: Style.grayDarkKoolicar(), radiusHeightMultiplier: 0.5)
        let listButton: UIBarButtonItem = Style.barButton(imageName: "list", title: "list".localizedLowercase, frontColor: Style.greenKoolicar(), backgroundColor: Style.grayDarkKoolicar(), radiusHeightMultiplier: 0.5)
        let mapButton: UIBarButtonItem = Style.barButton(imageName: "map", title: "map".localizedLowercase, frontColor: Style.greenKoolicar(), backgroundColor: Style.grayDarkKoolicar(), radiusHeightMultiplier: 0.5)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        buttonsList = [flexibleSpace, filterButton, fixedSpace, listButton]
        buttonsMap = [flexibleSpace, filterButton, fixedSpace, mapButton]
        
        super.init(coder: aDecoder);
        if let customListButton = filterButton.customView as? UIButton {
            customListButton.addTarget(self, action: #selector(HomeViewController.showFilter), for: .touchUpInside)
        }
        if let customListButton = listButton.customView as? UIButton {
            customListButton.addTarget(self, action: #selector(HomeViewController.toggleView), for: .touchUpInside)
        }
        if let customMapButton = mapButton.customView as? UIButton {
            customMapButton.addTarget(self, action: #selector(HomeViewController.toggleView), for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        toolbar.backgroundColor = Style.toolbarBackgroundColor()
        toolbar.tintColor = Style.toolbarBackgroundColor()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            toolbar.heightAnchor.constraint(equalToConstant: 50),
            toolbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            toolbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
        
        if let vehicleMapView = vehicleMapViewController.view {
            vehicleMapViewController.delegate = self
            vehicleMapView.isHidden = true
            view.addSubview(vehicleMapView)
            vehicleMapView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vehicleMapView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
                vehicleMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                vehicleMapView.leftAnchor.constraint(equalTo: view.leftAnchor),
                vehicleMapView.rightAnchor.constraint(equalTo: view.rightAnchor),
                ])
            addChildViewController(vehicleMapViewController)
        }
        
        if let tableView = vehicleTableViewController.view {
            vehicleTableViewController.delegate = self
            tableView.isHidden = true
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                ])
            addChildViewController(vehicleTableViewController)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = Style.opacKoolicar()
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: view.leftAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
        updateVehicleList()
        listIsHidden = false
    }
    
    func updateVehicleList(selection: Selection? = nil) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let onSuccessCompletion = { [weak self] (_ vehicles: [Vehicle]?) in
            self?.vehicles = vehicles?.filter() { $0.fitWithSelection(selection: selection) }
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
        let onErrorCompletion = { [weak self] (_ error: Error) in
            self?.vehicles = []
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
            let alert = UIAlertController(title: "Error".localizedCapitalized, message: error.localizedDescription, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK".localizedUppercase, style: .default)
            alert.addAction(okButton)
            self?.present(alert, animated: true)
        }
        
        VehicleManager.sharedInstance.updateVehiclesList(onSuccessCompletion: onSuccessCompletion, onErrorCompletion: onErrorCompletion)
    }
    
    @objc func showFilter() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let filterViewController = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else { return }
        filterViewController.selection = selection
        filterViewController.delegate = self
        present(filterViewController, animated: true)
    }
    
    @objc func toggleView(sender: UIBarButtonItem) {
        listIsHidden = !listIsHidden
    }
}

// MARK: VehicleSelectable
extension HomeViewController: VehicleSelectable {
    func vehicleDidSelected(vehicle: Vehicle) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vehicleFileViewController = storyboard.instantiateViewController(withIdentifier: "VehicleFileViewController") as? VehicleFileViewController else { return }
        vehicleFileViewController.vehicle = vehicle
        self.navigationController?.pushViewController(vehicleFileViewController, animated: true)
    }
}

extension HomeViewController: Selectionnable{
    func didSelection(selection: Selection) {
        self.selection = selection
        updateVehicleList(selection: selection)
    }
}
