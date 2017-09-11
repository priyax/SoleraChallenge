//
//  ExchangeRateManager.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 8/2/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import Foundation

class ExchangeRateManager {
  
  static let sharedInstance = ExchangeRateManager()
  
  private init() {}
  
  private let domain =  "http://www.apilayer.net/api/live"
  private let APIkey = "access_key=1d5f49755791b82322fc09165b2f1f97"
  private let parameters = "&currencies=AUD,CHF,EUR,GBP,PLN,INR&format=1"
  
  func loadExchangeRate(completion: @escaping ([CurrencyExchangeRate]) -> (), errorText: @escaping (String) -> ()) {
    
    var currencyData = [CurrencyExchangeRate]()
    let url = URL(string: "\(domain)?\(APIkey)\(parameters)")!
    
    print("URL = \(url)")
    let session = URLSession.shared
    
    let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
      
      
      if error == nil
      {
        
        do
        {
          let jsonDict = try JSONSerialization.jsonObject(with: data!, options: [] ) as! NSDictionary
          
          print(data!)
          // let source = (jsonDict["source"] as? String)!
          //  print("source = \(source)")
          
          let quotesDict = (jsonDict["quotes"] as? NSDictionary)!
          
          
          for (key, value) in quotesDict
          {
            print("\(key as! String) = \(value as! Float)")
            var key = key as! String
            //Remove USD prefixes of currencies
            key = key.replacingOccurrences(of: "USD", with: "")
            currencyData.append(CurrencyExchangeRate(currency: key, rate: value as! Float))
          }
          
          completion(currencyData)
          
        } catch {
          print("NSData or NSJSONSerialization Error: \(error)")
          errorText("NSData or NSJSONSerialization Error: \(error)")
          }
        
      } else {
        print("NSURLSession Error: \(String(describing: error))")
        //let alertController = UIAlertController(title: "Network error", message: String(describing: error?.localizedDescription), preferredStyle: .alert)
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        //alertController.addAction(cancelAction)
        //self.present(alertController, animated: true, completion: nil)
        
        errorText("NSURLSession Error: \(String(describing: error))")
      }
    })
    
    task.resume()
  }
  
  
}


