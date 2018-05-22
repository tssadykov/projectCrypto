//
//  MainVC.swift
//  ProjectCrypto
//
//  Created by Тимур on 21.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var newsArray:[News]=[]
    var images:[UIImage?]=[]
    
    @IBOutlet weak var newsTableView: UITableView!
    lazy var newsManager=APINewsManager(apiKey: "b3fb1677ce01409cabd625ade46422eb")
    
    let refreshController = UIRefreshControl()
    override func viewDidLoad() {
        
        self.newsTableView.delegate=self
        self.newsTableView.dataSource=self
        
        refreshController.addTarget(self, action: #selector(fetch), for: .valueChanged)
        newsTableView.refreshControl = refreshController
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isMovable = true
        let imageView = UIImageView(image: UIImage(named: "Rectangle")!)
        self.navigationItem.title = "NEWS"
        self.newsTableView.backgroundView = imageView
        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#2D98DA")
    }
    
    @objc func fetch() {
        refreshController.endRefreshing()
        SVProgressHUD.show()
        newsManager.fetchCurrentNewsWith(theme: "everything?sources=crypto-coins-news") { (result) in
            switch result
            {
            case .Success(let dictionaries):
                self.newsArray = []
                for res in dictionaries
                {
                    let news=News(JSON: res)
                    self.newsArray.append(news!)
                }
                if (self.newsTableView != nil) {
                    self.newsTableView.reloadData()
                }
                for index in 0..<self.newsArray.count {
                    self.imageParse(urlStr: self.newsArray[index].urlOfImage, index: index)
                }
                SVProgressHUD.dismiss()
            case .Failure(let error):
                let al=UIAlertController(title: "Unable get data", message: error.localizedDescription, preferredStyle: .alert)
                let ac=UIAlertAction(title: "Ok", style: .default, handler: nil)
                al.addAction(ac)
                SVProgressHUD.dismiss()
                self.present(al, animated: true, completion: nil)
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count==0 ? 0:newsArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row==0)
        {
            let cell=tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as! MainImageTableViewCell
            if self.newsArray[0].image != nil
            {
                cell.mainImage.image=self.newsArray[0].image
                cell.mainImage.layer.cornerRadius=15
                cell.mainImage.layer.masksToBounds=true
            }
            return cell
        }
        let cell=tableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as! NewsTableViewCell
        if self.newsArray[indexPath.row-1].image != nil {
            cell.imageOfArticle.image = self.newsArray[indexPath.row-1].image
            cell.imageOfArticle.layer.cornerRadius=15
            cell.imageOfArticle.layer.shadowRadius=30
            cell.imageOfArticle.layer.masksToBounds = true
        }
        cell.newsTitleLabel.text=newsArray[indexPath.row-1].title
        cell.authorOfArticle.text=newsArray[indexPath.row-1].author
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    //More
    @IBAction func onMoreTapped(){
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showContent"
        {
            if let index=newsTableView.indexPathForSelectedRow?.row
            {
                let cvc=segue.destination as! NewsContentTableViewController
                cvc.titleOfNews=newsArray[index-1].title
                cvc.urlImage=newsArray[index-1].urlOfImage
                cvc.imageOfNews=newsArray[index-1].image
                
                cvc.urlOfNews=newsArray[index-1].urlOfNews
            }
        }
    }
    
    
    func imageParse(urlStr:String, index: Int)
    {
        let graphPictureURL = URL(string: urlStr)!
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: graphPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded graph picture with response code \(res.statusCode)")
                    if let imageData = data {
                        
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            if (self.newsTableView != nil) {
                                self.newsArray[index].image = image
                                if index==0 {
                                    self.newsTableView.reloadRows(at: [IndexPath(row:0,section:0)], with: .automatic)
                                }
                                let indexPath = IndexPath(row: index+1, section: 0)
                                self.newsTableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                        //self.activityIndicator.stopAnimating()
                        //self.activityIndicator.isHidden=true
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
