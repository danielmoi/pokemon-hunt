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
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
