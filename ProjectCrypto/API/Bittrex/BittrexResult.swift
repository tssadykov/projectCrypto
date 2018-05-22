//
//  BittrexResult.swift
//  ProjectCrypto
//
//  Created by Тимур on 22.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct BittrexResult:JSONDecodable
{
    var coins:[Coin]
}

extension BittrexResult
{
    init?(JSON: [String : AnyObject]) {
        coins=[]
        guard let jsonResult=JSON["result"] as? [[String:AnyObject]] else { return }
        for json in jsonResult
        {
            guard let name = json["MarketName"] as? String else { continue }
            if name[name.startIndex] == "B" || name[name.startIndex] == "E"
            {
                continue
            }
            guard var price = json["Last"] as? Double else { continue }
            price = (price > 1) ? round(price) : round(price*100)/100
            guard var high = json["High"] as? Double else { continue }
            high = (high > 1) ? round(high) : round(high*100)/100
            guard var low = json["Low"] as? Double else { continue }
            low = (low > 1) ? round(low) : round(low*100)/100
            guard var bid = json["Bid"] as? Double else { continue }
            bid = (bid > 1) ? round(bid) : round(bid*100)/100
            guard var ask = json["Ask"] as? Double else { continue }
            ask = (ask > 1) ? round(ask) : round(ask*100)/100
            guard var openPrice = json["PrevDay"] as? Double else { continue }
            openPrice = (openPrice > 1) ? round(openPrice) : round(openPrice*100)/100
            let percent = round((price / openPrice - 1)*100)
            coins.append(Coin(name: name.replacingOccurrences(of: "USDT-", with: ""), last: (String(price)+"$").replacingOccurrences(of: ".0$", with: "$"), percentageChange: (String(percent)+"%").replacingOccurrences(of: ".0%", with: "%"), lowPrice: (String(low)+"$").replacingOccurrences(of: ".0$", with: "$"), highPrice: (String(high)+"$").replacingOccurrences(of: ".0$", with: "$"), openingPrice: (String(openPrice)+"$").replacingOccurrences(of: ".0$", with: "$"), askPrice: (String(ask)+"$").replacingOccurrences(of: ".0$", with: "$"), bidPrice: (String(bid)+"$").replacingOccurrences(of: ".0$", with: "$")))
        }
    }
}
