//
//  FileViewController.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-03.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import UIKit
import CoreLocation

class VehicleFileViewController: UIViewController {
    
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var doorLabel: UILabel!
    @IBOutlet weak var gearLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var categoryWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var seatImageView: UIImageView!
    @IBOutlet weak var fuelImageView: UIImageView!
    @IBOutlet weak var doorImageView: UIImageView!
    @IBOutlet weak var gearImageView: UIImageView!
    @IBOutlet weak var reservationButton: UIButton!
    var vehicle: Vehicle? {
        didSet {
            guard let vehicle = vehicle else { return }
            vehicleMapViewController.vehicles = [vehicle]
            vehicleMapViewController.centerLocation = CLLocation(latitude: vehicle.location.latitude, longitude: vehicle.location.longitude)
        }
    }
    private var vehicleMapViewController = VehicleMapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let vehicle = vehicle else{ return }
        let backButton = Style.button(title: "<", frontColor: Style.grayDarkKoolicar(), backgroundColor: Style.greenKoolicar())
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backButton.addTarget(self, action: #selector(VehicleFileViewController.goBack), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        modelLabel.text = "\(vehicle.brand) \(vehicle.vehicle_model)"
        categoryLabel.text = vehicle.category.readable.localizedLowercase
        yearLabel.text = "\(vehicle.year)"
        seatLabel.text = "\(vehicle.places_count) " + "seats".localizedLowercase
        fuelLabel.text = vehicle.fuel_type_cd.readable.localizedLowercase
        doorLabel.text = "\(vehicle.doors_count) " + "doors".localizedLowercase
        gearLabel.text = vehicle.gears_type_cd.readable.localizedLowercase
        if let thumbnail_url = vehicle.thumbnail_url {
            vehicleImageView.af_setImage(withURL: thumbnail_url)
        }
        
        if let text = categoryLabel.text {
            categoryWidthConstraint.constant = 1.5 * text.width(withConstraintedHeight: CGFloat.greatestFiniteMagnitude, font: categoryLabel.font)
            categoryHeightConstraint.constant = 1.5 * text.height(withConstrainedWidth: CGFloat.greatestFiniteMagnitude, font: categoryLabel.font)
        }
        categoryLabel.layer.cornerRadius = categoryHeightConstraint.constant / 4
        
        if let image = seatImageView.image {
            seatImageView.image = image.withRenderingMode(.alwaysTemplate)
            seatImageView.tintColor = Style.greenKoolicar()
        }
        if let image = fuelImageView.image {
            fuelImageView.image = image.withRenderingMode(.alwaysTemplate)
            fuelImageView.tintColor = Style.greenKoolicar()
        }
        if let image = doorImageView.image {
            doorImageView.image = image.withRenderingMode(.alwaysTemplate)
            doorImageView.tintColor = Style.greenKoolicar()
        }
        if let image = gearImageView.image {
            gearImageView.image = image.withRenderingMode(.alwaysTemplate)
            gearImageView.tintColor = Style.greenKoolicar()
        }
        
        reservationButton.backgroundColor = Style.greenKoolicar()
        reservationButton.setTitleColor(Style.grayDarkKoolicar(), for: .normal)
        reservationButton.setTitle("reserve".localizedLowercase, for: .normal)
        if let vehicleMapView = vehicleMapViewController.view {
            mapView.addSubview(vehicleMapView)
            vehicleMapView.frame = mapView.bounds
            addChildViewController(vehicleMapViewController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    @IBAction func onReserve(_ sender: Any) {
        let alert = UIAlertController(title: "Reservation".localizedCapitalized, message: "Functionnality not available".localizedLowercase, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK".localizedUppercase, style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
