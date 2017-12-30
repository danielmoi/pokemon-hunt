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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        // we don't want to catch ourselves :)
        if view.annotation! is MKUserLocation {
            return
        }
        
        // center map on the tapped pokemon
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        // use a timer to allow map to re-center on pokemon
        // before we do the Point in Rect check
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            // this is the pokemon that was tapped
            let pokemon = (view.annotation as! PokemonAnnotation).pokemon
            
            // see if trainer is inside pokemon's Rect
            if let coord = self.manager.location?.coordinate {
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    print("WE CAN CATCH!")
                    
                    // set the pokemon to caught!
                    pokemon.caught = true
                    
                    // save
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    // remove from map
                    mapView.removeAnnotation(view.annotation!)
                    
                    // alert
                    let alertVC = UIAlertController(title: "Success", message: "You caught a \(pokemon.name!)!", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    let actionPokedex = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    
                    alertVC.addAction(actionOk)
                    alertVC.addAction(actionPokedex)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    print("NAH CAN'T CATCH :(")
                    // alert
                    let alertVC = UIAlertController(title: "Uh-oh", message: "You are too far away to catch the \(pokemon.name!). Move closer to it!", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)

                    alertVC.addAction(actionOk)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
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

