//
//  APINewsManager.swift
//  ProjectCrypto
//
//  Created by Тимур on 23.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

enum ForecastType:FinalURLPoint
{
    case Current(apiKey:String,theme:String)
    
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2/")!
    }
    var path: String{
        switch self{
        case .Current(let apiKey, let theme):
            return "\(theme)&apiKey=\(apiKey)"
        }
    }
    
    var request: URLRequest{
        let url=URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}


final class APINewsManager : APIManager
{
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    let apiKey:String
    
    init (sessionConfiguration:URLSessionConfiguration,apiKey:String){
        self.sessionConfiguration=sessionConfiguration
        self.apiKey=apiKey
    }
    
    convenience init (apiKey:String)
    {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentNewsWith(theme:String, completionHandler: @escaping (APIResult<[[String:AnyObject]]>) -> Void){
        let request=ForecastType.Current(apiKey: self.apiKey, theme: theme).request
        print(request)
        fetch(request: request, isAsync: true, parse: { (json) -> [[String:AnyObject]] in
            if let dictionary=json["articles"] as? [[String:AnyObject]] {
                return dictionary
            } else{
                return [[:]]
            }
        }, completionHandler: completionHandler)
    }
}
