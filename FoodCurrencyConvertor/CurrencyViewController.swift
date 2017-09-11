//
//  ViewController.swift
//  FoodCurrencyConvertor
//
//  Created by Priya Xavier on 7/24/17.
//  Copyright © 2017 Copper Mobile. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
  
  
  //Outlet labels
  
  @IBOutlet weak var currencyPicker: UIPickerView!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  //Variables
  
  var checkoutTotalUSD: Float = 0.00
  var currencyMultiplier: Float = 1.0
  var selectedCurrency = "USD"
  var currencyData : [CurrencyExchangeRate] = [CurrencyExchangeRate(currency: "USD", rate: 1.0)]
  var numberFormatter = NumberFormatter()
  
  var groceryList = [GroceryItem]()
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    currencyPicker.delegate = self
    //loadGroceryList()
    GroceryManager.sharedInstance.loadGroceries(completion: { list in
    self.groceryList = list } )
    loadCurrencyData()
    
    //Get current conversion rates from API when app returns from background
    NotificationCenter.default.addObserver(self, selector: #selector(refreshRatesCall), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  //Make API Call when app returns from background
  func refreshRatesCall() {
    loadCurrencyData()
    currencyPicker.selectRow(0, inComponent: 0, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // Action buttons
  @IBAction func checkoutBtn(_ sender: UIButton) {
    self.totalLabel.text = currencyConversion()
  }
  @IBAction func clearAll(_ sender: UIButton) {
    
    self.checkoutTotalUSD = 0.00
    self.totalLabel.text = "0.00"
    for item in groceryList {
    item.qty = 0
    }
    tableView.reloadData()
  }
  
  //performs conversion of checkout basket
  func currencyConversion() -> String {
    let result = String(format: " %.2f", checkoutTotalUSD * currencyMultiplier) + "  " + selectedCurrency
    return result
  }
 
  
  //gets updated currency list
  
  func loadCurrencyData()  {
    ExchangeRateManager.sharedInstance.loadExchangeRate(completion: { rateData in
      self.currencyData = rateData
      DispatchQueue.main.async
        {
          self.currencyPicker.reloadAllComponents()
      }
      
    }, errorText: {error in
      let alertController = UIAlertController(title: "Network error", message: String(describing: error), preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      
      alertController.addAction(cancelAction)
      self.present(alertController, animated: true, completion: nil)
    })
  }
  
}

extension CurrencyViewController: UITableViewDataSource, UITableViewDelegate, GroceryCellDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  self.groceryList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = (indexPath as NSIndexPath).row
    let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as! GroceryCell
    cell.nameLabel.text = groceryList[row].name
    cell.qtyLabel.text = numberFormatter.string(from: NSNumber(value: groceryList[row].qty)) //String(groceryList[row].qty)
    cell.groceryCellDelegate = self
    cell.tag = row
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.contentView.backgroundColor = UIColor.white
  }
  
  func didAddItem(_ tag: Int) {
    print("I have added an item with a price tag \(self.groceryList[tag].price)")
    checkoutTotalUSD +=  self.groceryList[tag].price
    self.groceryList[tag].qty += 1
    print(checkoutTotalUSD)
    tableView.reloadData()
  }
  
  func didRemoveItem(_ tag: Int) {
    
    if self.groceryList[tag].qty > 0  {
      checkoutTotalUSD -= self.groceryList[tag].price
      self.groceryList[tag].qty -= 1
      print(checkoutTotalUSD)
      print("I have removed an item with a price tag \(self.groceryList[tag].price)")
      tableView.reloadData()
    }
  }
}

extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return currencyData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return currencyData[row].currency
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    currencyMultiplier = currencyData[row].rate
    selectedCurrency = currencyData[row].currency
    print("The currency conversion rate = \(currencyMultiplier)")
  }
}
