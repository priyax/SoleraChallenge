//
//  CurrencyList.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/24/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import Foundation

class CurrencyExchangeRate {
  var currency: String = "USD"
  var rate: Float = 1.0
  
  init(currency: String, rate: Float) {
    self.currency = currency
    self.rate = rate
  }
  
}
