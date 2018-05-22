//
//  News.swift
//  ProjectCrypto
//
//  Created by Тимур on 23.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation
import UIKit

struct News {
    let sourceName: String
    let author: String
    let title: String
    let urlOfNews: String
    let urlOfImage: String
    var image: UIImage?
    init?() {
        self.sourceName=""
        self.author="author"
        self.title="title"
        self.urlOfNews = "urlOfNews"
        self.urlOfImage = "urlOfImage"
    }
}
extension News: JSONDecodable{
    init?(JSON: [String : AnyObject]) {
        if let title=JSON["title"] as? String
        {
            self.title=title
        }
        else
        {
            self.title=""
        }
        if let sourceName=JSON["source"]!["name"] as? String
        {
            self.sourceName=sourceName
        }
        else
        {
            self.sourceName=""
        }
        if let author=JSON["author"] as? String
        {
            self.author=author
        }
        else
        {
            self.author=""
        }
        if let urlOfNews=JSON["url"] as? String
        {
            self.urlOfNews=urlOfNews
        }
        else
        {
            self.urlOfNews=""
        }
        if let urlOfImage=JSON["urlToImage"] as? String
        {
            self.urlOfImage=urlOfImage
        }
        else
        {
            self.urlOfImage=""
        }
    }
}
