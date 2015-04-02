//
//  ViewController.swift
//  Calculator
//
//  Created by Nicholas Addison on 31/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Fields
    @IBOutlet weak var displayField: UITextField!
    
    var calculator = Calculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleSwipeGesture(sender: AnyObject)
    {
        calculator.reset()
        
        displayField.text = "0"
    }
    
    @IBAction func operatorButtonPressed(sender: AnyObject)
    {
        let charPressed = getButtonChar(sender)
        
        switch charPressed {
        case "+":
            displayField.text = calculator.setOperation(.Plus)
            
        case "-":
            displayField.text = calculator.setOperation(.Minus)
            
        case "X":
            displayField.text = calculator.setOperation(.Times)
            
        case "÷":
            displayField.text = calculator.setOperation(.Div)
            
        default:
            displayField.text = "Error"
        }
    }
    
    @IBAction func digitButton(sender: AnyObject)
    {
        let charPressed = getButtonChar(sender)
        
        displayField.text = calculator.addDigitToDisplay(charPressed)
    }
    
    @IBAction func equalButton(sender: AnyObject)
    {
        displayField.text = calculator.equals()
    }
    
    func getButtonChar(sender: AnyObject) -> Character
    {
        let buttonPressed = sender as UIButton
        
        let charPressed: Character = Array(buttonPressed.titleLabel!.text!)[0]
        
        NSLog("pressed button = \(charPressed)")
        
        return charPressed
    }
}

