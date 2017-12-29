//
//  CoreDataHelp.swift
//  PokemonHunt
//
//  Created by Daniel Moi on 29/12/17.
//  Copyright © 2017 Daniel Moi. All rights reserved.
//

import UIKit
import CoreData

func createAllPokemon() {

    createPokemon(name: "Bulbasaur", imageName: "bulbasaur")
    createPokemon(name: "Charmander", imageName: "charmander")
    createPokemon(name: "Evee", imageName: "evee")
    createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Squirtle", imageName: "squirtle")
    
    createPokemon(name: "Weedle", imageName: "weedle")
    createPokemon(name: "Zubat", imageName: "zubat")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name: String, imageName: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
    
}

func getAllPokemon() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        // this will only run if pokemon haven't been created yet!
        if (pokemons.count == 0) {
            createAllPokemon()
            return getAllPokemon()
        }
        
        return pokemons
    } catch {}
    
    return []
}
