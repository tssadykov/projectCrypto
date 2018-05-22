//
//  PoloniexAPIManager.swift
//  ProjectCrypto
//
//  Created by Тимур on 22.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

final class APIPoloniexManager : APIManager
{
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    
    let url=URL(string: "https://poloniex.com/public?command=returnTicker")
    
    init (sessionConfiguration:URLSessionConfiguration){
        self.sessionConfiguration=sessionConfiguration
    }
    
    convenience init ()
    {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchCurrentWith(isAsync: Bool, completionHandler: @escaping (APIResult<PoloniexResult>) -> Void){
        let request=URLRequest(url: url!)
        
        fetch(request: request, isAsync: isAsync, parse: { (json) -> PoloniexResult? in
            return PoloniexResult(JSON: json)
        }, completionHandler: completionHandler)
    }
}
