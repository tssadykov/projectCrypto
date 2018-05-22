//
//  exchangeChooseTableViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 17.04.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ExchangeChooseTableViewController: UITableViewController {
    
    let arrayOfExchanges: [String?] = ["Poloniex", "Kraken", "Bittrex", "Bithumb"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250/4
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfExchanges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exMenu", for: indexPath)
        cell.textLabel?.text = arrayOfExchanges[indexPath.row]
        return cell
    }
    
    
}
