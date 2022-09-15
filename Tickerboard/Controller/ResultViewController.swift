//
//  ResultViewController.swift
//  Tickerboard
//
//  Created by Joshua on 9/6/20.
//  Copyright © 2020 Joshua. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var primaryExchangeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var week52HighLabel: UILabel!
    @IBOutlet weak var week52LowLabel: UILabel!
    @IBOutlet weak var peRatioLabel: UILabel!
    @IBOutlet weak var previousCloseLabel: UILabel!
    
    var tickerManager = TickerManager()
    
    var tickerSymbol: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Common pitfall: Forgetting to assign the delegate!
        tickerManager.delegate = self
        
        // Optional binding because tickerSymbol is an optional string
        if let safeTickerSymbol = tickerSymbol {
            print("safeTickerSymbol: \(safeTickerSymbol)")
            tickerManager.fetchTicker(tickerSymbol: safeTickerSymbol)
        }
    }
}

extension ResultViewController: TickerManagerDelegate {
    
    // Code credits: StackOverflow thread "iOS convert large numbers to smaller format"
    // Answered by Luca Iaco, edited by saiday
    // Converts large numbers into a smaller format. E.g. 5000000 -> 5.0M
    func suffixNumber(number:NSNumber) -> String {

        var num:Double = number.doubleValue;
        let sign = ((num < 0) ? "-" : "" );

        num = fabs(num);

        if (num < 1000.0){
            return "\(sign)\(num)" as String;
        }

        let exp:Int = Int(log10(num) / 3.0 ); // log10(1000));

        let units:[String] = ["K","M","G","T","P","E"];

        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;

        return "\(sign)\(roundedNum)\(units[exp-1])" as String;
    }
    
    func didUpdateTicker(_ tickerManager: TickerManager, ticker: TickerModel) {
        
        DispatchQueue.main.async {
            self.symbolLabel.text = ticker.symbol
            self.companyNameLabel.text = ticker.companyName
            self.primaryExchangeLabel.text = ticker.primaryExchange
            
            // Some values returned from the API can be nil; must check for nil values
            if ticker.open == nil {
                self.openLabel.text = "-"
            } else {
                self.openLabel.text = String(ticker.open!)
            }
            if ticker.close == nil {
                self.closeLabel.text = "-"
            } else {
                self.closeLabel.text = String(ticker.close!)
            }
            if ticker.high == nil {
                self.highLabel.text = "-"
            } else {
                self.highLabel.text = String(ticker.high!)
            }
            if ticker.low == nil {
                self.lowLabel.text = "-"
            } else {
                self.lowLabel.text = String(ticker.low!)
            }
            if ticker.marketCap == nil {
                self.marketCapLabel.text = "-"
            } else {
                self.marketCapLabel.text = self.suffixNumber(number: ticker.marketCap! as NSNumber)
                //self.marketCapLabel.text = String(ticker.marketCap!)
            }
            if ticker.volume == nil {
                self.volumeLabel.text = "-"
            } else {
                self.volumeLabel.text = self.suffixNumber(number: ticker.volume! as NSNumber)
                //self.volumeLabel.text = String(ticker.volume!)
            }
            if ticker.peRatio == nil {
                self.peRatioLabel.text = "-"
            } else {
                self.peRatioLabel.text = self.suffixNumber(number: ticker.peRatio! as NSNumber)
            }
            if ticker.week52Low == nil {
                self.week52LowLabel.text = "-"
            } else {
                self.week52LowLabel.text = self.suffixNumber(number: ticker.week52Low! as NSNumber)
            }
            if ticker.week52High == nil {
                self.week52HighLabel.text = "-"
            } else {
                self.week52HighLabel.text = self.suffixNumber(number: ticker.week52High! as NSNumber)
            }
            if ticker.previousClose == nil {
                self.previousCloseLabel.text = "-"
            } else {
                self.previousCloseLabel.text = self.suffixNumber(number: ticker.previousClose! as NSNumber)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
