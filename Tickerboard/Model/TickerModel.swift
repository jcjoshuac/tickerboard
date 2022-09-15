//
//  TickerModel.swift
//  Tickerboard
//
//  Created by Joshua on 9/6/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

struct TickerModel {
    
    let symbol: String
    let companyName: String
    let primaryExchange: String
    let open: Float?
    let close: Float?
    let previousClose: Float?
    let high: Float?
    let low: Float?
    let marketCap: Int?
    let peRatio: Float?
    let week52High: Float?
    let week52Low: Float?
    let volume: Int?
    let latestPrice: Float?
    let latestSource: String
    let latestTime: String
    let isUSMarketOpen: Bool
    
}
