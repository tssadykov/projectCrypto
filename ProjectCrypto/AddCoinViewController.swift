//
//  AddCoinViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 17.04.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import CoreData

class AddCoinViewController: UIViewController {

    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numerousTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        numerousTextField.delegate = self
        setupGestures()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let name: String! = (nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.uppercased()
        guard name != "" else {
            presentAlert(message: "You have not writed the name")
            return
        }
        guard let numerous = Double((numerousTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").joined(separator: "."))!) else {
            presentAlert(message: "You should write numerous correctly")
            return
        }
        guard numerous > 0 else {
            presentAlert(message: "Numerous can not be 0")
            return
        }
        switch exchangeLabel.text {
        case "Poloniex":
            guard poloniexResult?.coins != nil else { return }
            for coin in poloniexResult!.coins {
                if coin.name == name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let startValue = numerous * (Double(coin.last[coin.last.startIndex..<index])!)
                    saveCurrency(name: name, exchange: exchangeLabel.text!, numerous: numerous, startValue: startValue)
                    NotificationCenter.default.post(name: NSNotification.Name("ShowPortfolio"), object: nil)
                    return
                }
            }
        case "Kraken":
            guard krakenResult?.coins != nil else { return }
            for coin in krakenResult!.coins {
                if coin.name == name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let startValue = numerous * (Double(coin.last[coin.last.startIndex..<index])!)
                    saveCurrency(name: name, exchange: exchangeLabel.text!, numerous: numerous, startValue: startValue)
                    NotificationCenter.default.post(name: NSNotification.Name("ShowPortfolio"), object: nil)
                    return
                }
            }
        case "Bittrex":
            guard bittrexResult?.coins != nil else { return }
            for coin in bittrexResult!.coins {
                if coin.name == name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let startValue = numerous * (Double(coin.last[coin.last.startIndex..<index])!)
                    saveCurrency(name: name, exchange: exchangeLabel.text!, numerous: numerous, startValue: startValue)
                    NotificationCenter.default.post(name: NSNotification.Name("ShowPortfolio"), object: nil)
                    return
                }
            }
        case "Bithumb":
            guard bithumbResult?.coins != nil else { return }
            for coin in bithumbResult!.coins {
                if coin.name == name {
                    let index = coin.last.index(coin.last.endIndex, offsetBy: -1)
                    let startValue = numerous * (Double(coin.last[coin.last.startIndex..<index])!)
                    saveCurrency(name: name, exchange: exchangeLabel.text!, numerous: numerous, startValue: startValue)
                    NotificationCenter.default.post(name: NSNotification.Name("ShowPortfolio"), object: nil)
                    return
                }
            }
        default:
            presentAlert(message: ("You have not chose the exchange"))
            return
        }
        presentAlert(message: ("There are no currencies with a name \(name!) on the exchange \(exchangeLabel.text!)"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = saveBarButton
        isMovable = false
    }
    
    private func setupGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        gesture.numberOfTapsRequired = 1
        chooseButton.addGestureRecognizer(gesture)
    }
    
    @objc func tapped() {
        self.nameTextField.endEditing(true)
        self.numerousTextField.endEditing(true)
        guard let pvc = storyboard?.instantiateViewController(withIdentifier: "popVC") else { return }
        pvc.modalPresentationStyle = .popover
        guard let popOverVC = pvc.popoverPresentationController else { return }
        popOverVC.delegate = self
        popOverVC.sourceView = self.chooseButton
        popOverVC.sourceRect = CGRect(x: self.chooseButton.bounds.midX, y: self.chooseButton.bounds.minY, width: 0, height: 0)
        pvc.preferredContentSize = CGSize(width: 250, height: 250)
        
        self.present(pvc, animated: true, completion: nil)
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let source = segue.source as? ExchangeChooseTableViewController else { return }
        guard let index = source.tableView.indexPathForSelectedRow?.row else { return }
        guard let choosenExchange = source.arrayOfExchanges[index] else { return }
        self.exchangeLabel.text = choosenExchange
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveCurrency(name: String, exchange: String, numerous: Double, startValue: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Currency", in: context)
        let currencyObject = NSManagedObject(entity: entity!, insertInto: context) as! Currency
        
        currencyObject.name = name
        currencyObject.numerous = numerous
        currencyObject.startValue = startValue
        currencyObject.exchange = exchange
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension AddCoinViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension AddCoinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            numerousTextField.becomeFirstResponder()
        } else if textField == numerousTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
