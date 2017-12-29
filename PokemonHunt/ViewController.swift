//
//  ViewController.swift
//  PokemonHunt
//
//  Created by Daniel Moi on 29/12/17.
//  Copyright © 2017 Daniel Moi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("READY TO GO!")
            mapView.showsUserLocation = true
            
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
         centerCoordinate: The center point of the new coordinate region.
         latitudinalMeters: The amount of north-to-south distance (measured in meters) to use for the span.
         longitudinalMeters: The amount of east-to-west distance (measured in meters) to use for the span.
        */
        
        // stop moving map when user moves = allow panning
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 400, 400)
            
            // false so it's smooth upon opening
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            // stop this function getting called ALL the time
            manager.stopUpdatingLocation()
        }
        
        
        
    }

    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 400, 400)
        
            // true so it's smooth when we re-center
            mapView.setRegion(region, animated: true)
        }
    }
    

}

