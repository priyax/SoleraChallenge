//
//  GroceryCellDelegate.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/24/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import Foundation

protocol GroceryCellDelegate {
  func didAddItem(_ tag: Int)
  func didRemoveItem(_ tag: Int)  
 
}
