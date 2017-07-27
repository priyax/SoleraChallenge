//
//  GroceryItem.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/24/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import Foundation

class GroceryItem {
  var name: String = ""
  var price: Float = 0.0
  var qty: Int = 0
  
  init(name: String, price: Float, qty: Int) {
    self.name = name
    self.price = price
    self.qty = qty
  }
  
}
