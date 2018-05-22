//
//  PortfolioViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 17.04.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData
import UserNotifications

var krakenResult: KrakenResult?
var poloniexResult: PoloniexResult?
var bittrexResult: BittrexResult?
var bithumbResult: BithumbResult?

class PortfolioViewController: UIViewController {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // API
    lazy var krakenExchange=APIKrakenManager()
    lazy var bittrexExchange=APIBittrexManager()
    lazy var bithumbExchange=APIBithumbManager()
    lazy var poloniexExchange=APIPoloniexManager()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    
    var myCurrencies: [Currency] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.portfolioTableView.delegate = self
        self.portfolioTableView.dataSource = self
        
        intro()
        scheduleNotification()
        
        deleteButton.layer.cornerRadius = 50
        deleteButton.clipsToBounds = true
        getPoloniex()
        getBittrex()
        getBithumb()
        getKraken()
    }

    override func viewWillAppear(_ animated: Bool) {
        isMovable = true
        deleteButton.isHidden = true
        context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            myCurrencies = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        self.portfolioTableView.backgroundColor = .clear
        self.portfolioTableView.backgroundView = UIImageView(image: UIImage(named: "Rectangle"))
        navigationItem.hidesBackButton = true
        let menuItem = UIBarButtonItem(image: UIImage(named: "Menu Icon")!, style: .plain, target: self, action: #selector(menuTapped))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.rightBarButtonItem = addBarButton
        self.navigationItem.title = "PORTFOLIO"
    }
    
    func intro() {
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        
        guard !wasIntroWatched else { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageVC") as? StartViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["MyUniqueId"])
        let date = Date(timeIntervalSinceNow: 86400)
        let content = UNMutableNotificationContent()
        
        content.title = "Check out"
        content.body = "View today's currencies and news!"
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "MyUniqueId", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        guard let indexPath = self.portfolioTableView.indexPathForSelectedRow else { return }
        self.context.delete(self.myCurrencies[indexPath.row])
        do {
            try self.context.save()
            self.myCurrencies.remove(at: indexPath.row)
            self.portfolioTableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print(error.localizedDescription)
        }
        deleteButton.isHidden = true
    }
    
    @objc func menuTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    //получение данных
    func getKraken()
    {
        krakenExchange.fetchCurrentWith(isAsync: true) { (result) in
            switch result{
            case .Success(let result):
                krakenResult = result
                self.portfolioTableView.reloadData()
            case .Failure(let error):
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
                bittrexResult = result
                self.portfolioTableView.reloadData()
            case .Failure(let error):
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
                poloniexResult = result
                self.portfolioTableView.reloadData()
            case .Failure(let error):
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
                bithumbResult = result
                self.portfolioTableView.reloadData()
            case .Failure(let error):
                let al=UIAlertController(title: "Unable to get data", message: error.localizedDescription, preferredStyle: .alert)
                let ac=UIAlertAction(title: "Ok", style: .default, handler: nil)
                al.addAction(ac)
                self.present(al, animated: true, completion: nil)
            }
        }
    }
}

extension PortfolioViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pcoin", for: indexPath) as! CurrencyCell
        cell.nameLabel.text = myCurrencies[indexPath.row].name!
        cell.exchangeLabel.text = myCurrencies[indexPath.row].exchange!
        switch myCurrencies[indexPath.row].exchange! {
        case "Poloniex":
            guard poloniexResult?.coins != nil else { break }
            for coin in poloniexResult!.coins {
                if coin.name == myCurrencies[indexPath.row].name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let currentPrice = myCurrencies[indexPath.row].numerous*(Double(coin.last[coin.last.startIndex..<index])!)
                    cell.priceLabel.text = String(currentPrice)+"$"
                    cell.percentChangeLabel.text = String(round(100*(currentPrice/myCurrencies[indexPath.row].startValue-1)))+"%"
                }
            }
        case "Kraken":
            guard krakenResult?.coins != nil else { break }
            for coin in krakenResult!.coins {
                if coin.name == myCurrencies[indexPath.row].name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let currentPrice = myCurrencies[indexPath.row].numerous*(Double(coin.last[coin.last.startIndex..<index])!)
                    cell.priceLabel.text = String(currentPrice)+"$"
                    cell.percentChangeLabel.text = String(round(100*(currentPrice/myCurrencies[indexPath.row].startValue-1)))+"%"
                }
            }
        case "Bittrex":
            guard bittrexResult?.coins != nil else { break }
            for coin in bittrexResult!.coins {
                if coin.name == myCurrencies[indexPath.row].name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let currentPrice = myCurrencies[indexPath.row].numerous*(Double(coin.last[coin.last.startIndex..<index])!)
                    cell.priceLabel.text = String(currentPrice)+"$"
                    cell.percentChangeLabel.text = String(round(100*(currentPrice/myCurrencies[indexPath.row].startValue-1)))+"%"
                }
            }
        case "Bithumb":
            guard bithumbResult?.coins != nil else { break }
            for coin in bithumbResult!.coins {
                if coin.name == myCurrencies[indexPath.row].name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let currentPrice = myCurrencies[indexPath.row].numerous*(Double(coin.last[coin.last.startIndex..<index])!)
                    cell.priceLabel.text = String(currentPrice)+"₩"
                    cell.percentChangeLabel.text = String(round(100*(currentPrice/myCurrencies[indexPath.row].startValue-1)))+"%"
                }
            }
        default:
            break
        }
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCurrencies.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteButton.isHidden = false
    }
}
