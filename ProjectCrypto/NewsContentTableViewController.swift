//
//  NewsContentTableViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 26.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import SwiftSoup
import SVProgressHUD

class NewsContentTableViewController: UITableViewController {

    var urlImage:String? = nil
    var urlOfNews:String? = nil
    var titleOfNews:String? = nil
    var imageOfNews:UIImage? = nil
    var newsContent:String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if urlOfNews != "" {
            parsingURL()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        isMovable = false
        self.tableView.backgroundView=UIImageView(image: UIImage(named: "Rectangle")!)
    }
    func parsingURL () {
        SVProgressHUD.show()
        let myURL = URL(string: urlOfNews!)
        let URLTask = URLSession.shared.dataTask(with: myURL!){
            myData, response, error in
            
            guard error == nil else { return }
            
            let htmlContent = String(data: myData!, encoding: String.Encoding.utf8)
            do
            {
                var doc:Document = try SwiftSoup.parse(htmlContent!)
                let html = try doc.getElementsByClass("entry-content").toString()
                doc=try SwiftSoup.parse(html)
                let pbTags = try doc.select("p,b").array()
                self.newsContent=""
                for i in 0..<pbTags.count {
                    let text=try pbTags[i].text()
                    print(text)
                    self.newsContent=self.newsContent!+text+"\n\n"
                }
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 2, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    print(self.newsContent!)
                }
            }
            catch
            {
                let al=UIAlertController(title: "Error", message: "Enable to get news content", preferredStyle: .alert)
                let ac=UIAlertAction(title: "Ok", style: .default, handler: nil)
                al.addAction(ac)
                self.present(al, animated: true, completion: nil)
            }
            SVProgressHUD.dismiss()
        }
        URLTask.resume()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row==0
        {
            let cell=tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageTableViewCell
            cell.imageUrl = urlImage
            cell.backgroundColor = .clear
            return cell
        }
        if indexPath.row==1
        {
            let cell=tableView.dequeueReusableCell(withIdentifier: "titleCell") as! TitleTableViewCell
            cell.titleLabel.text=titleOfNews!
            return cell
        }
        let cell=tableView.dequeueReusableCell(withIdentifier: "contentCell") as! ContentTableViewCell
        cell.backgroundColor = .clear
        cell.contentLabel.text=self.newsContent
        return cell
    }
}



