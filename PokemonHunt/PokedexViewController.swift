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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    


    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
}
