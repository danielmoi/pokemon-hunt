//
//  PokedexViewController.swift
//  PokemonHunt
//
//  Created by Daniel Moi on 29/12/17.
//  Copyright © 2017 Daniel Moi. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var caught: [Pokemon] = []
    var uncaught: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caught = getAllCaughtPokemon()
        uncaught = getAllUncaughtPokemon()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "CAUGHT"
        }
        return "UNCAUGHT"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caught.count
        }
        return uncaught.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon: Pokemon
        if indexPath.section == 0 {
            pokemon = caught[indexPath.row]
        } else {
            pokemon = uncaught[indexPath.row]
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        return cell
    }
    
    


    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
}
