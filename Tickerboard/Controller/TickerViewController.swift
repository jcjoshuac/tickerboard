//
//  TickerViewController.swift
//  Tickerboard
//
//  Created by Joshua on 9/6/20.
//  Copyright © 2020 Joshua. All rights reserved.
//
//  Description: Tickerboard is a dashboard for financial information regarding a stock ticker symbol
//  To-do List: 1) Format floats to one decimal place 2) Add more labels and design ResultViewController 3) Ensure that all the text in ResultViewController shows up properly
//  References: BMI Calculator app from Udemy's iOS 13 & Swift 5 - The Complete iOS App Development Bootcamp by Angela Yu
//  API: https://iexcloud.io

import UIKit

class TickerViewController: UIViewController {
    
    @IBOutlet weak var tickerSymbolTextField: UITextField!
    
    var tickerSymbol: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Common pitfall: Forgetting to assign the delegate!
        tickerSymbolTextField.delegate = self
    }

}

//MARK: - UITextFieldDelegate

extension TickerViewController: UITextFieldDelegate {
    
    // When the search button is pressed
    @IBAction func searchPressed(_ sender: UIButton) {
        tickerSymbolTextField.endEditing(true)
    }
    
    // When the return key is pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tickerSymbolTextField.endEditing(true)
        return true
    }
    
    // To check the user's input to determine whether to proceed or ask the user to rectify his input
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "E.g. AAPL"
            return false
        }
    }
    
    // What happens next after user's input has been checked
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        tickerSymbol = tickerSymbolTextField.text
        
        performSegue(withIdentifier: "goToResult", sender: self) // Important!
    
        tickerSymbolTextField.text = ""
    }
    
    // To send information to the destination view controller
    // Used with the performSegue function above
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.tickerSymbol = tickerSymbol
        }
    }
}
