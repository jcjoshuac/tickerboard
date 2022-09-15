//
//  TickerManager.swift
//  Tickerboard
//
//  Created by Joshua on 9/6/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import Foundation

protocol TickerManagerDelegate {
    func didUpdateTicker(_ tickerManager: TickerManager, ticker: TickerModel)
    func didFailWithError(error: Error)
}

struct TickerManager {

    var delegate: TickerManagerDelegate?
    
    // Obtain the URL before performRequest
    func fetchTicker(tickerSymbol: String) {
        let urlString = "https://cloud.iexapis.com/stable/stock/\(tickerSymbol)/quote?token=pk_cebc9fc78abc4ccb82b1f68f1cc6226b"
        print("URLString: \(urlString)")
        performRequest(with: urlString)
    }
    
    // Search the URL with URLSession
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let ticker = self.parseJSON(safeData) {
                        self.delegate?.didUpdateTicker(self, ticker: ticker)
                    }
                }
            }
            task.resume()
        }
    }
    
    // Parse JSON produced by the API to extract relevant information
    func parseJSON(_ tickerData: Data) -> TickerModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TickerData.self, from: tickerData)
            
            let symbol = decodedData.symbol
            print("symbol: \(symbol)")
            let companyName = decodedData.companyName
            print("companyName: \(companyName)")
            let primaryExchange = decodedData.primaryExchange
            let open = decodedData.open
            let close = decodedData.close
            let previousClose = decodedData.previousClose
            let high = decodedData.high
            let low = decodedData.low
            print("low: \(low)")
            let marketCap = decodedData.marketCap
            let peRatio = decodedData.peRatio
            let week52High = decodedData.week52High
            let week52Low = decodedData.week52Low
            let volume = decodedData.volume
            print("volume: \(volume)")
            let latestPrice = decodedData.latestPrice
            let latestSource = decodedData.latestSource
            print("latestSource: \(latestSource)")
            let latestTime = decodedData.latestTime
            let isUSMarketOpen = decodedData.isUSMarketOpen
            print("isUSMarketOpen: \(isUSMarketOpen)")
            
            let ticker = TickerModel(symbol: symbol, companyName: companyName, primaryExchange: primaryExchange, open: open, close: close, previousClose: previousClose, high: high, low: low, marketCap: marketCap, peRatio: peRatio, week52High: week52High, week52Low: week52Low, volume: volume, latestPrice: latestPrice, latestSource: latestSource, latestTime: latestTime, isUSMarketOpen: isUSMarketOpen)
            return ticker
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
