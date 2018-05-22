//
//  BithumbAPIManager.swift
//  ProjectCrypto
//
//  Created by Тимур on 22.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

final class APIBithumbManager : APIManager
{
    
    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    
    let url=URL(string: "https://api.bithumb.com/public/ticker/ALL")
    
    init (sessionConfiguration:URLSessionConfiguration){
        self.sessionConfiguration=sessionConfiguration
    }
    
    convenience init ()
    {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchCurrentWith(isAsync: Bool, completionHandler: @escaping (APIResult<BithumbResult>) -> Void){
        let request=URLRequest(url: url!)
        
        fetch(request: request, isAsync: isAsync, parse: { (json) -> BithumbResult? in
            return BithumbResult(JSON: json)
        }, completionHandler: completionHandler)
    }
}
