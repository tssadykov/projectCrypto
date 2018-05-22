//
//  NewsTableViewCell.swift
//  ProjectCrypto
//
//  Created by Тимур on 25.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfArticle: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var authorOfArticle: UILabel!
    
    var imageUrl: String? {
        didSet {
            imageParse()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageParse() {
        
        let graphPictureURL = URL(string: imageUrl!)!
        
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: graphPictureURL) { (data, response, error) in
            
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                
                if let res = response as? HTTPURLResponse {
                    print("Downloaded graph picture with response code \(res.statusCode)")
                    if let imageData = data {
                        DispatchQueue.main.async {
                            self.imageOfArticle.image = UIImage(data: imageData)
                        }
                        //self.activityIndicator.stopAnimating()
                        //self.activityIndicator.isHidden=true
                        
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
}
