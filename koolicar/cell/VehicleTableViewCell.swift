//
//  VehicleTableViewCell.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-03.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Alamofire
import AlamofireImage

class VehicleTableViewCell: UITableViewCell {
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryWidthConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vehicleImageView.af_cancelImageRequest()
        vehicleImageView.image = UIImage(named: "car-default")
        titleLabel.text = ""
        titleLabel.text = ""
    }
    
    func loadData(vehicle: Vehicle) {
        titleLabel.text = vehicle.brand + " " + vehicle.vehicle_model
        line1Label.text = vehicle.fuel_type_cd.readable.localizedLowercase
            + " . \(vehicle.places_count) " + "sets".localizedLowercase
            + " . " + vehicle.gears_type_cd.readable.localizedLowercase
        line2Label.text = "\(vehicle.year) . \(vehicle.distance_string)"
        categoryLabel.text = vehicle.category.readable.localizedCapitalized
        
        if let text = categoryLabel.text {
            categoryWidthConstraint.constant = 1.2 * text.width(withConstraintedHeight: CGFloat.greatestFiniteMagnitude, font: categoryLabel.font)
            categoryHeightConstraint.constant = 1.5 * text.height(withConstrainedWidth: CGFloat.greatestFiniteMagnitude, font: categoryLabel.font)
        }
        categoryLabel.layer.cornerRadius = categoryHeightConstraint.constant / 2
        
        let vehicleLocation = CLLocation(latitude: vehicle.location.latitude, longitude: vehicle.location.longitude)
        let distanceInMeter = VehicleManager.sharedInstance.currentLocation.distance(from: vehicleLocation)
        let measurementInMeter = Measurement(value: distanceInMeter, unit: UnitLength.meters)
        let measurementInUserUnit = MeasurementFormatter().string(from: measurementInMeter)
        
        distanceLabel.text = "\(measurementInUserUnit)"
        if let thumbnail_url = vehicle.thumbnail_url {
            vehicleImageView.af_setImage(withURL: thumbnail_url)
        }
    }
}

