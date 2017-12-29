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
            
            // timer logic
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                if let coord = self.manager.location?.coordinate {
                    // spawn new Pokemon
                    let pin = MKPointAnnotation()
                    pin.coordinate = coord
                    
                    let randLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    let randLng = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    
                    pin.coordinate.latitude += randLat
                    pin.coordinate.longitude += randLng
                    
                    self.mapView.addAnnotation(pin)
                }
                
            })
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
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            
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
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        
            // true so it's smooth when we re-center
            mapView.setRegion(region, animated: true)
        }
    }
    

}

