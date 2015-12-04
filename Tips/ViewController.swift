//
//  ViewController.swift
//  Tips
//
//  Created by Eric Zim on 11/30/15.
//  Copyright © 2015 Eric Zim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!

    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var intValue = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (defaults.boolForKey("default_tip")) {
            intValue = defaults.integerForKey("default_tip")
        }
        
        print(defaults.integerForKey("default_tip"))
        
        tipControl.selectedSegmentIndex = intValue
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        let tipPercent = getTipPercentage(tipControl.selectedSegmentIndex)
        
        let billAmount = NSString(string: billField.text!).doubleValue
        let tip = billAmount * tipPercent
        let total = billAmount + tip
        
        tipLabel.text = String (format: "$%.2f", tip)
        totalLabel.text = String (format: "$%.2f", total)
        
    }

    func getTipPercentage(index: Int) -> Double {
        let tipPercentages = [ 0.18, 0.2, 0.22, 0.25 ]
        
        return tipPercentages[index]
        
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
}

