//
//  KrakenViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 21.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import SVProgressHUD

class ExchangeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let images:[String:String]=["kraken":"Kraken-Exchange","bittrex":"Bittrex-Exchange","poloniex":"Poloniex-Exchange","bithumb":"Bithumb-Exchange"]
    
    @IBOutlet weak var exchangeTableView: UITableView!    
    @IBOutlet weak var bidPriceLabel: UILabel!
    @IBOutlet weak var askPriceLabel: UILabel!
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var theLowestPriceLabel: UILabel!
    @IBOutlet weak var theHighestPriceLabel: UILabel!
    @IBOutlet weak var openPriceLabel: UILabel!
    
    private let refreshController = UIRefreshControl()
    
    var coins: [Coin] = []
    //API
    lazy var krakenExchange=APIKrakenManager()
    lazy var bittrexExchange=APIBittrexManager()
    lazy var bithumbExchange=APIBithumbManager()
    lazy var poloniexExchange=APIPoloniexManager()
    
    //выбранная биржа
    var exchangeName=""
    
    //загрузка контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exchangeTableView.delegate=self
        self.exchangeTableView.dataSource=self
        
        isMovable = true
        refreshController.addTarget(self, action: #selector(self.fetch), for: .valueChanged)
        exchangeTableView.refreshControl = refreshController
        fetch()
    }
    
    @objc func fetch() {
        refreshController.endRefreshing()
        SVProgressHUD.show()
        switch exchangeName
        {
        case "kraken":
            getKraken()
        case "bittrex":
            getBittrex()
        case "poloniex":
            getPoloniex()
        case "bithumb":
            getBithumb()
        default:
            break
        }
    }
    @objc func menuTapped() {
        self.navigationController?.title = exchangeName
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    //получение данных
    func getKraken()
    {
        krakenExchange.fetchCurrentWith(isAsync: true) { (result) in
            switch result{
            case .Success(let result):
                self.coins = result.coins
                self.exchangeTableView.reloadData()
                SVProgressHUD.dismiss()
            case .Failure(let error):
                SVProgressHUD.dismiss()
                let al=UIAlertController(title: "Unable to get data", message: error.localizedDescription, preferredStyle: .alert)
                let ac=UIAlertAction(title: "Ok", style: .default, handler: nil)
                al.addAction(ac)
                self.present(al, animated: true, completion: nil)
            }
        }
    }
    func getBittrex()
    {
        bittrexExchange.fetchCurrentWith(isAsync: true) { (result) in
            switch result{
            case .Success(let result):
                self.coins = result.coins
                self.exchangeTableView.reloadData()
                SVProgressHUD.dismiss()
            case .Failure(let error):
                SVProgressHUD.dismiss()
                let al=UIAlertController(title: "Unable to get data", message: error.localizedDescription, preferredStyle: .alert)
                let ac=UIAlertAction(title: "Ok", style: .default, handler: nil)
                al.addAction(ac)
                self.present(al, animated: true, completion: nil)
            }
        }
    }
    func getPoloniex()
    {
        poloniexExchange.fetchCurrentWith(isAsync: true) { (result) in
            switch result{
            case .Success(let result):
                self.coins = result.coins
                self.exchangeTableView.reloadData()
                SVProgressHUD.dismiss()
            case .Failure(let error):
                SVProgressHUD.dismiss()
                let al=UIAlertController(title: "Unable to get data", message: error.localizedDescription, preferredStyle: .alert)
                let ac=UIAlertAction(title: "Ok", style: .default, handler: nil)
                al.addAction(ac)
                self.present(al, animated: true, completion: nil)
            }
        }
    }
    func getBithumb()
    {
        bithumbExchange.fetchCurrentWith(isAsync: true) { (result) in
            switch result{
            case .Success(let result):
                self.coins = result.coins
                self.exchangeTableView.reloadData()
                SVProgressHUD.dismiss()
            case .Failure(let error):
                SVProgressHUD.dismiss()
                let al=UIAlertController(title: "Unable to get data", message: error.localizedDescription, preferredStyle: .alert)
                let ac=UIAlertAction(title: "Ok", style: .default, handler: nil)
                al.addAction(ac)
                self.present(al, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton=true
        let menuItem = UIBarButtonItem(image: UIImage(named: "Menu Icon")!, style: .plain, target: self, action: #selector(menuTapped))
        navigationItem.leftBarButtonItem = menuItem
        navigationItem.title = exchangeName.uppercased()
        self.exchangeTableView.backgroundView = UIImageView(image: UIImage(named: "Rectangle")!)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if coins.count != 0 {
            return coins.count+1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell=tableView.dequeueReusableCell(withIdentifier: "exImage", for: indexPath) as! ExchImageCell
            cell.exchImage.image = UIImage(named: images[exchangeName]!)
            cell.backgroundColor = .clear
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! ExchangeCell
        cell.backgroundColor = .clear
        cell.backgroundView?.layer.cornerRadius = 100
        cell.nameOfCoin.text = self.coins[indexPath.row-1].name
        cell.valueOfCoin.text = self.coins[indexPath.row-1].last
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 0 else { return }
        percentageChangeLabel.text = self.coins[indexPath.row-1].percentageChange
        bidPriceLabel.text = self.coins[indexPath.row-1].bidPrice
        askPriceLabel.text = self.coins[indexPath.row-1].askPrice
        openPriceLabel.text = self.coins[indexPath.row-1].openingPrice
        theLowestPriceLabel.text = self.coins[indexPath.row-1].lowPrice
        theHighestPriceLabel.text = self.coins[indexPath.row-1].highPrice
    }
}
