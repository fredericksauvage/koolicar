//
//  VehicleMapViewController.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-04.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import UIKit
import MapKit


class VehicleMapViewController: UIViewController {
    class VehiculePinAnnotation: NSObject, MKAnnotation {
        var vehicle: Vehicle
        var title: String? {
            return  "\(vehicle.brand) \(vehicle.vehicle_model)"
        }
        var coordinate: CLLocationCoordinate2D {
            return vehicle.location
        }
        var subtitle: String? {
            return "\(vehicle.year)"
        }
        
        init(vehicle: Vehicle) {
            self.vehicle = vehicle
            super.init()
        }
    }
    
    weak var delegate: VehicleSelectable?
    var lastTapGesture : UITapGestureRecognizer?
    var regionRadius: CLLocationDistance = 1000
    var centerLocation: CLLocation = parisLocation {
        didSet {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    var mapView = MKMapView()
    var signNoResult: UIView?
    var vehicles: [Vehicle]? {
        didSet {
            if let vehicles = vehicles, vehicles.count > 0 {
                signNoResult?.removeFromSuperview()
                reloadData()
            }
            else if let signView = Bundle.main.loadNibNamed("SignView", owner: self, options: nil)?.first as? SignView {
                signNoResult?.removeFromSuperview()
                signNoResult = signView
                signView.titleLabel.text = "No result".localizedCapitalized
                signView.subtitleLabel.text = "No vehicle available in this region".localizedCapitalized
                view.addSubview(signView)
                signView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    signView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                    signView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                    signView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
                ])
                reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.frame = view.bounds
    }
    
    func reloadData() {
        mapView.removeAnnotations(mapView.annotations)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        mapView.centerCoordinate = centerLocation.coordinate
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let vehicles = vehicles {
            for vehicle in vehicles {
                let vehiclePin = VehiculePinAnnotation(vehicle: vehicle)
                mapView.addAnnotation(vehiclePin)
            }
        }
    }
}

// MARK: MKMapViewDelegate
extension VehicleMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let vehiclePinAnnotation = annotation as? VehiculePinAnnotation else { return MKAnnotationView() }
        let vehiclePinAnnotationView = MKPinAnnotationView(annotation: vehiclePinAnnotation, reuseIdentifier: "vehiclePinAnnotation")
        
        vehiclePinAnnotationView.pinTintColor = Style.purpleKoolicar()
        vehiclePinAnnotationView.isDraggable = true
        vehiclePinAnnotationView.canShowCallout = true
        vehiclePinAnnotationView.animatesDrop = true
        
        if let thumbnail_url = vehiclePinAnnotation.vehicle.thumbnail_url {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "car-default")
            imageView.af_setImage(withURL: thumbnail_url)
            imageView.frame.size.width = 40
            imageView.frame.size.height = 30
            vehiclePinAnnotationView.leftCalloutAccessoryView = imageView
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(VehicleMapViewController.annotationTapped))
        vehiclePinAnnotationView.addGestureRecognizer(gesture)
        return vehiclePinAnnotationView
    }
    
    @objc func annotationTapped(sender: UITapGestureRecognizer){
        if let lastTapGesture = lastTapGesture,
            lastTapGesture == sender,
            let annotationView = lastTapGesture.view as? MKPinAnnotationView,
            let annotation = annotationView.annotation as? VehiculePinAnnotation {
            delegate?.vehicleDidSelected(vehicle: annotation.vehicle)
        }
        lastTapGesture = sender
    }
}
