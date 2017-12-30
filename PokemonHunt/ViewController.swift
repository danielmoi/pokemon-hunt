//
//  ViewController.swift
//  PokemonHunt
//
//  Created by Daniel Moi on 29/12/17.
//  Copyright © 2017 Daniel Moi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            mapView.delegate = self
            mapView.showsUserLocation = true
            
            manager.startUpdatingLocation()
            
            // timer logic
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                if let coord = self.manager.location?.coordinate {
                    let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                    
                    // spawn new Pokemon
                    // use our subclass of MKAnnotation
                    let pin = PokemonAnnotation(coordinate: coord, pokemon: pokemon)
                    
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        
        
        if annotation is MKUserLocation {
            // the user is a pin too
            pinView.image = UIImage(named: "player")
        } else {
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            pinView.image = UIImage(named: pokemon.imageName!)
        }
        
        var frame = pinView.frame
        frame.size.height = 50
        frame.size.width = 50
        pinView.frame = frame
        
        
        
        return pinView
    }

    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        
            // true so it's smooth when we re-center
            mapView.setRegion(region, animated: true)
        }
    }
    

}

