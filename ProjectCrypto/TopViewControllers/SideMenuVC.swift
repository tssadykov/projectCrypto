//
//  SideMenuVC.swift
//  ProjectCrypto
//
//  Created by Тимур on 21.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class SideMenuVC: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.backgroundView=UIImageView(image: UIImage(named: "Rectangle")!)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch (indexPath.row)
        {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("ShowNews"), object: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("ShowPoloniex"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("ShowKraken"), object: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("ShowBittrex"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("ShowBithumb"), object: nil)
        case 5:
            NotificationCenter.default.post(name: NSNotification.Name("ShowPortfolio"), object: nil)
        case 6:
            NotificationCenter.default.post(name: NSNotification.Name("ShowSendEmail"), object: nil)
        case 7:
            NotificationCenter.default.post(name: NSNotification.Name("ShowReview"), object: nil)
        default:
            break
        }
    }
}
