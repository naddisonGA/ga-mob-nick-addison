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
    
    // handles swipe gesture to clear the calculator
    @IBAction func handleSwipeGesture(sender: AnyObject)
    {
        calculator.reset()
        
        displayField.text = "0"
    }
    
    // handle operator buttons plus, minus, times and div
    @IBAction func operatorButtonPressed(sender: UIButton)
    {
        let charPressed = getButtonChar(sender)
        
        switch charPressed {
        case "+":
            displayField.text = calculator.setOperation(.Plus)
            
        case "-":
            displayField.text = calculator.setOperation(.Minus)
            
        case "x":
            displayField.text = calculator.setOperation(.Times)
            
        case "÷":
            displayField.text = calculator.setOperation(.Div)
            
        default:
            displayField.text = "Error"
        }
    }
    
    // handle number and decimal point buttons pressed
    @IBAction func digitButton(sender: UIButton)
    {
        let charPressed = getButtonChar(sender)
        
        displayField.text = calculator.addDigitToDisplay(charPressed)
    }
    
    // handles the equals button being pressed
    @IBAction func equalButton(sender: AnyObject)
    {
        displayField.text = calculator.equals()
    }
    
    // gets the first character from button title
    func getButtonChar(buttonPressed: UIButton) -> Character
    {
        let buttonTitle = buttonPressed.titleForState(.Normal)
        
        // get the first character in the String
        let charPressed: Character = Array(buttonTitle!)[0]
        
        NSLog("pressed button = \(charPressed)")
        
        return charPressed
    }
}

