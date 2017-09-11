//
//  GroceryList.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/31/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import Foundation

class GroceryManager {
  
  //This gives access to the one and only instance
  static let sharedInstance = GroceryManager()
  
  private init() {}
  
 
  
  func loadGroceries(completion: (([GroceryItem]) -> Void))  {
    
    let jsonString = readFileFromResources(fileName: "groceryItems", fileType: ".json")
    let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    var groceryData: [GroceryItem] = []
    
    do {
      let groceryArray = try JSONSerialization.jsonObject(with:jsonData, options: []) as! NSArray
      
      for item in groceryArray {
        let itemDictionary = item as! NSDictionary
        let name = itemDictionary["name"] as! String
        let price = itemDictionary["price"] as! Float
        let qty = itemDictionary["qty"] as! Int
        
        groceryData.append(GroceryItem(name: name, price: price, qty: qty))
      }
      
      completion(groceryData)
    } catch {
      print("Serialization error")
    }
  }
  
  
  func readFileFromResources(fileName: String, fileType: String, encoding: String.Encoding = String.Encoding.utf8) -> String {
    
    let absoluteFilePath = Bundle.main.path(forResource: fileName, ofType: fileType)
    
    if let absoluteFilePath = absoluteFilePath {
      
      if let fileData = try? Data.init(contentsOf: URL(fileURLWithPath: absoluteFilePath)) {
        
        if let fileAsString = NSString(data: fileData, encoding: encoding.rawValue) {
          return fileAsString as String
        } else {
          print("readFileFromResources failed on: \(fileName). Failed to convert data to String!")
          return  ""
        }
        
      } else {
        print("readFileFromResources failed on: \(fileName). Failed to load any data!")
        return  ""
      }
    }
    
    print("readFileFromResources failed on: \(fileName). File does not exist!")
    return  ""
  }
  
}
