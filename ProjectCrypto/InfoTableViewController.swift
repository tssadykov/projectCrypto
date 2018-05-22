//
//  InfoTableViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 02.03.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    var coin: Coin? = Coin()

    @IBOutlet weak var percentChangeLabel: UILabel!
    @IBOutlet weak var bidPriceLabel: UILabel!
    @IBOutlet weak var askPriceLabel: UILabel!
    @IBOutlet weak var openPriceLabel: UILabel!
    @IBOutlet weak var theLowestPriceLabel: UILabel!
    @IBOutlet weak var theHighestPriceLabel: UILabel!
    
    
    override func viewDidLoad() {
        if coin != nil {
            percentChangeLabel.text = coin?.percentageChange
            bidPriceLabel.text = coin?.bidPrice
            askPriceLabel.text = coin?.askPrice
            openPriceLabel.text = coin?.openingPrice
            theLowestPriceLabel.text = coin?.lowPrice
            theHighestPriceLabel.text = coin?.highPrice
            
        }
    }
    
    //API
    lazy var krakenExchange=APIKrakenManager()
    lazy var bittrexExchange=APIBittrexManager()
    lazy var bithumbExchange=APIBithumbManager()
    lazy var poloniexExchange=APIPoloniexManager()
    
    
}
