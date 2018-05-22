//
//  PoloniexResult.swift
//  ProjectCrypto
//
//  Created by Тимур on 22.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct PoloniexResult:JSONDecodable
{
    var coins:[Coin]
}

extension PoloniexResult
{
    init?(JSON: [String : AnyObject]) {
        coins=[]
        for json in JSON
        {
            if json.key[json.key.startIndex]=="B" || json.key[json.key.startIndex]=="E" || json.key[json.key.startIndex]=="X"
            {
                continue
            }
            
            guard let info = json.value as? [String:AnyObject] else { continue }
            guard let priceString = info["last"] as? String else { continue }
            var price = Double(priceString)
            price = (price != nil)&&(price! > 1) ? round(price!) : round(price!*100)/100
            guard let percentageChangeString = info["percentChange"] as? String else { continue }
            var percentChange = Double(percentageChangeString)
            let openPrice = (price! / (1+percentChange!)) > 1 ? round((price! / (1+percentChange!))) : round((price! / (1+percentChange!))*100)/100
            percentChange = round(percentChange!*100)
            guard let askString = info["lowestAsk"] as? String else { continue }
            var ask = Double(askString)
            ask = (ask != nil)&&(ask! > 1) ? round(ask!) : round(ask! * 100)/100
            guard let bidString = info["highestBid"] as? String else { continue }
            var bid = Double(bidString)
            bid = (bid != nil)&&(bid! > 1) ? round(bid!) : round(bid!*100)/100
            guard let highString = info["high24hr"] as? String else { continue }
            var high = Double(highString)
            high = (high != nil)&&(high! > 1) ? round(high!) : round(high!*100)/100
            guard let lowString = info["low24hr"] as? String else { continue }
            var low = Double(lowString)
            low = (low != nil)&&(low! > 1) ? round(low!) : round(low!*100)/100
            coins.append(Coin(name: json.key.replacingOccurrences(of: "USDT_", with: ""), last: (String(price!)+"$").replacingOccurrences(of: ".0$", with: "$"), percentageChange: (String(percentChange!)+"%").replacingOccurrences(of: ".0%", with: "%"), lowPrice: (String(low!)+"$").replacingOccurrences(of: ".0$", with: "$"), highPrice: (String(high!)+"$").replacingOccurrences(of: ".0$", with: "$"), openingPrice: (String(openPrice)+"$").replacingOccurrences(of: ".0$", with: "$"), askPrice: (String(ask!)+"$").replacingOccurrences(of: ".0$", with: "$"), bidPrice: (String(bid!)+"$").replacingOccurrences(of: ".0$", with: "$")))
        }
    }
}
