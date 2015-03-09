//
//  ThirdViewController.swift
//  Lesson02
//
//  Created by Rudd Taylor on 9/28/14.
//  Copyright (c) 2014 General Assembly. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var messageField: UILabel!
    
/*
    TODO six: Hook up the number input text field, button and text label to this class. When the button is pressed, a message should be printed to the label indicating whether the number is even.

*/
    @IBAction func calculate(sender: AnyObject)
    {
        if (numberField.text.isEmpty)
        {
            messageField.text = "enter number"
        }
        else
        {
            var number: Int? = numberField.text.toInt()
            
            if (number == nil)
            {
                messageField.text = "number must be an integer"
            }
            else
            {
                messageField.text = isEvenOrOddText(number!)
            }
        }
    }
    
    private func isEvenOrOddText(number: Int) -> String
    {
        if (number % 2 == 0)
        {
            return "is even"
        }
        else
        {
            return "is odd"
        }
    }
}
