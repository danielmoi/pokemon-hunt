//
//  PokemonAnnotation.swift
//  PokemonHunt
//
//  Created by Daniel Moi on 30/12/17.
//  Copyright © 2017 Daniel Moi. All rights reserved.
//

import UIKit
import MapKit

// this is a SUBCLASS of MKAnnotation
// it has the "type" MKAnnotation
// NB. the order of the INHERITANCE CLAUSE matters (NSObject must come first
class PokemonAnnotation: NSObject, MKAnnotation {
    // needed
    var coordinate: CLLocationCoordinate2D
    
    // custom
    var pokemon: Pokemon
    
    // needed
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
    
}
