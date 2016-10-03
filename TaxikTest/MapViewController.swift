//
//  MapViewController.swift
//  TaxikTest
//
//  Created by Артем on 01/10/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var coordinatePin: (latitude: Double, longitude: Double)?

    @IBOutlet weak var mapView: MKMapView!
    
    private func setPin() {
        if coordinatePin != nil {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: coordinatePin!.latitude, longitude: coordinatePin!.longitude)
        mapView.addAnnotation(pin)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(pin.coordinate, span)
        mapView.setRegion(region, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPin()
    }
}
