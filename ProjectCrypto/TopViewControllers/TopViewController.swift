//
//  TopViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 17.04.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import StoreKit

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showKraken), name: NSNotification.Name("ShowKraken"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBithumb), name: NSNotification.Name("ShowBithumb"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBittrex), name: NSNotification.Name("ShowBittrex"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPoloniex), name: NSNotification.Name("ShowPoloniex"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNews), name: NSNotification.Name("ShowNews"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPortfolio), name: NSNotification.Name("ShowPortfolio"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSendEmail), name: NSNotification.Name("ShowSendEmail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReview), name: NSNotification.Name("ShowReview"), object: nil)
        
        showPortfolio()
    }

    //вызов экрана в меню
    @objc func showKraken()
    {
        guard let EVC=storyboard?.instantiateViewController(withIdentifier: "krakenStoryboard") as? ExchangeViewController else { return }
        EVC.exchangeName="kraken"
        self.navigationController?.pushViewController(EVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc func showBithumb()
    {
        guard let EVC=storyboard?.instantiateViewController(withIdentifier: "krakenStoryboard") as? ExchangeViewController else { return }
        EVC.exchangeName="bithumb"
        self.navigationController?.pushViewController(EVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc func showBittrex()
    {
        guard let EVC=storyboard?.instantiateViewController(withIdentifier: "krakenStoryboard") as? ExchangeViewController else { return }
        EVC.exchangeName="bittrex"
        self.navigationController?.pushViewController(EVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc func showPoloniex()
    {
        guard let EVC=storyboard?.instantiateViewController(withIdentifier: "krakenStoryboard") as? ExchangeViewController else { return }
        EVC.exchangeName="poloniex"
        self.navigationController?.pushViewController(EVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc func showNews() {
        guard let MVC = storyboard?.instantiateViewController(withIdentifier: "newsStoryboard") as? MainVC else { return }
        self.navigationController?.pushViewController(MVC, animated: true)
        guard sideMenuOpen else { return }
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc func showPortfolio() {
        guard let PVC = storyboard?.instantiateViewController(withIdentifier: "portfolioVC") as? PortfolioViewController else { return }
        self.navigationController?.pushViewController(PVC, animated: true)
        guard sideMenuOpen else { return }
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc func showSendEmail() {
        guard let SVC = storyboard?.instantiateViewController(withIdentifier: "emailVC") as? EmailViewController else { return }
        self.navigationController?.pushViewController(SVC, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @objc func showReview() {
        SKStoreReviewController.requestReview()
    }
}
