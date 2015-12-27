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
    
    @IBOutlet weak var billText: UILabel!
    
    @IBOutlet weak var tipText: UILabel!
    
    @IBOutlet weak var totalText: UILabel!
    
    @IBOutlet weak var barDivider: UIView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // sets segmented control to unselected as a default
    var intValue = -1
    
    var normalSize = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // compare stored closing date to now
        // and use if less than 10 minutes
        if (NSDate().timeIntervalSinceDate(defaults.objectForKey("time_closed") as! NSDate) < 600)
        {
            billField.text = (defaults.objectForKey("recent_bill") as! String)
            
        }
        
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        print("Will appear")
        
        // loads default tip setting, if it has been set
        if (defaults.objectForKey("default_tip") != nil) {
            intValue = defaults.integerForKey("default_tip")
            
            print("Found default tip")
            print(intValue)
        }

        print(defaults.integerForKey("default_tip"))
        
        // uses the default value, using -1 if none exists
        tipControl.selectedSegmentIndex = intValue
        
        updateLabels()

    }
    
    override func viewDidAppear(animated: Bool) {
        
        // set bill field to first responder
        // autoload the keyboard
        billField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        
        updateLabels()

    }
    
    // $ prefix for billField
    func makePrefix() {
        let attributedString = NSMutableAttributedString(string: "$")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0,1))
        
        billField.attributedText = attributedString
    }
    


    // store the segment values/array in its own function
    func getTipPercentage(index: Int) -> Double {
        if (index >= 0)
        {
            let tipPercentages = [ 0.18, 0.2, 0.22, 0.25 ]
            
            return tipPercentages[index]
        }
        else // in case of -1
        {
            return (0.0)
        }
    }
    
    // function to use anytime data may have changed
    func updateLabels()
    {
        
        // pass the segment control to the percentage func
        let tipPercent = getTipPercentage(tipControl.selectedSegmentIndex)
        
        let billAmount = NSString(string: billField.text!).doubleValue
        
        print("billField: \(billField.text!)")
        print("billAmount: \(billAmount)")
        
        let tip = billAmount * tipPercent
        let total = billAmount + tip
                
        tipLabel.text = String (format: "$%.2f", tip)
        totalLabel.text = String (format: "$%.2f", total)

        // store the latest bill entry for later
        defaults.setValue(billField.text!, forKey: "recent_bill")
        
        defaults.synchronize()

    }
    
    // close the keyboard upon taking any part of the screen
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // screen animation control
    func activateScreenElements(turnOn: Bool)
    {
        let animOption = UIViewAnimationOptions.CurveEaseIn
        
        print("animation call")
        
        if (!turnOn)
        {
            UIView.animateWithDuration(1.0, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseOut,
                animations:
                {
                    self.alphaModify(0)
                    self.growBillField(!turnOn)
                },
                completion: {
                    (Bool) in
/*                    self.billField.font = UIFont.systemFontOfSize(64);                    self.billField.transform = CGAffineTransformScale(self.billField.transform, 1.0, 1.0)
*/                    print("elements off")
                    
            })
            
            normalSize = false
        }
        else // make screen elements visible
        {
            UIView.animateWithDuration(1.0, delay: 0.25, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: animOption,
                animations: {
                    
                    self.alphaModify(1)
                    self.growBillField(!turnOn)
                    
                },
                completion: {
                    (Bool) in
/*                    self.billField.font = UIFont.systemFontOfSize(16);
                    self.billField.transform = CGAffineTransformScale(self.billField.transform, 1.0, 1.0)
*/                   print("elements on")
            })
            
            normalSize = true
        }
        
    }

    func leftSwoop()
    {
        tipLabel.center.x += view.bounds.width
        totalLabel.center.x += view.bounds.width
        tipControl.center.x += view.bounds.width
        billText.center.x += view.bounds.width
        tipText.center.x += view.bounds.width
        totalText.center.x += view.bounds.width
        barDivider.center.x += view.bounds.width

    }
    
    func alphaModify(newAlpha: CGFloat)
    {
        tipLabel.alpha = newAlpha
        totalLabel.alpha = newAlpha
        tipControl.alpha = newAlpha
        billText.alpha = newAlpha
        tipText.alpha = newAlpha
        totalText.alpha = newAlpha
        barDivider.alpha = newAlpha
    }
    
    // control billField size
    func growBillField(grow: Bool)
    {

        if (grow)
        {
            print("grow true")
            
            billField.bounds.size = CGSize(width: 124, height: 60)
                        
        }
        else
        {
            print("grow false")
            
            billField.bounds.size = CGSize(width: 124, height: 30)
            
        }

    }

}

