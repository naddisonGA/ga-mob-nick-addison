//
//  SecondViewController.swift
//  Lesson02
//
//  Created by Rudd Taylor on 9/28/14.
//  Copyright (c) 2014 General Assembly. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var number: Float = 0
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var resultField: UILabel!
    
    //TODO five: Display the cumulative sum of all numbers added every time the ‘add’ button is pressed. Hook up the label, text box and button to make this work.
    @IBAction func addNumber(sender: AnyObject)
    {
        if (numberField.text.isEmpty)
        {
            resultField.text = "enter number"
        }
        else
        {
            number += (numberField.text as NSString).floatValue
            
            resultField.text = "\(number)"
        }
    }
}
