//
//  KrakenAPIManager.swift
//  ProjectCrypto
//
//  Created by Тимур on 22.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

final class APIKrakenManager : APIManager
{
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    let url=URL(string: "https://api.kraken.com/0/public/Ticker?pair=BCHUSD,XXBTZUSD,DASHUSD,EOSUSD,GNOUSD,XETCZUSD,XETHZUSD,XLTCZUSD,XREPZUSD,XXBTZUSD,XXLMZUSD,XXMRZUSD,XXRPZUSD,XZECZUSD")
    
    init (sessionConfiguration:URLSessionConfiguration){
        self.sessionConfiguration=sessionConfiguration
    }
    
    convenience init ()
    {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchCurrentWith(isAsync: Bool,completionHandler: @escaping (APIResult<KrakenResult>) -> Void){
        let request=URLRequest(url: url!)
        
        fetch(request: request, isAsync: isAsync, parse: { (json) -> KrakenResult? in
            if let dictionary=json["result"] as? [String:AnyObject] {
                return KrakenResult(JSON: dictionary)
            } else{
                return nil
            }
        }, completionHandler: completionHandler)
    }
}
