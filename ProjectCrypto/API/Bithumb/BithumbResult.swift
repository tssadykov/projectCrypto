//
//  BithumbResult.swift
//  ProjectCrypto
//
//  Created by Тимур on 22.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct BithumbResult:JSONDecodable
{
    var coins:[Coin]
}

extension BithumbResult
{
    init?(JSON: [String : AnyObject]) {
        coins=[]
        guard let data=JSON["data"] as? [String:AnyObject] else { return }
        for json in data
        {
            guard let info = json.value as? [String:AnyObject] else { continue }
            guard let priceString = info["average_price"] as? String else { continue }
            var price = Double(priceString)
            price = (price != nil)&&(price! > 1) ? round(price!) : round(price!*100)/100
            guard let openPriceString = info["opening_price"] as? String else { continue }
            var openPrice = Double(openPriceString)
            openPrice = (openPrice != nil)&&(openPrice! > 1) ? round(openPrice!) : round(openPrice!*100)/100
            guard let lowString = info["min_price"] as? String else { continue }
            var low = Double(lowString)
            low = (low != nil)&&(low! > 1) ? round(low!) : round(low!*100)/100
            guard let highString = info["max_price"] as? String else { continue }
            var high = Double(highString)
            high = (high != nil)&&(high! > 1) ? round(high!) : round(high!*100)/100
            guard let bidString = info["buy_price"] as? String else { continue }
            var bid = Double(bidString)
            bid = (bid != nil)&&(bid! > 1) ? round(bid!) : round(bid!*100)/100
            guard let askString = info["sell_price"] as? String else { continue }
            var ask = Double(askString)
            ask = (ask != nil)&&(ask! > 1) ? round(ask!) : round(ask! * 100)/100
            let percentChange = (openPrice! != 0) ? round((price!/openPrice! - 1)*100) : 0
            coins.append(Coin(name: json.key, last: (String(price!)+"₩").replacingOccurrences(of: ".0₩", with: "₩"), percentageChange: (String(percentChange)+"%").replacingOccurrences(of: ".0%", with: "%"), lowPrice: (String(low!)+"₩").replacingOccurrences(of: ".0₩", with: "₩"), highPrice: (String(high!)+"₩").replacingOccurrences(of: ".0₩", with: "₩"), openingPrice: (String(openPrice!)+"₩").replacingOccurrences(of: ".0₩", with: "₩"), askPrice: (String(ask!)+"₩").replacingOccurrences(of: ".0₩", with: "₩"), bidPrice: (String(bid!)+"₩").replacingOccurrences(of: ".0₩", with: "₩")))
        }
    }
}
