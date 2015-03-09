//
//  FirstViewController.swift
//  Lesson02
//
//  Created by Rudd Taylor on 9/28/14.
//  Copyright (c) 2014 General Assembly. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var displayText: UILabel!

    
//    TODO one: hook up a button in interface builder to a new function (to be written) in this class. Also hook up the label to this class. When the button is clicked, the function to be written must make a label say ‘hello world!’
    @IBAction func displayHelloWorld(sender: AnyObject)
    {
        displayText.text = "Hellow world!"
    }
    
    // TODO two: Connect the ‘name’ and ‘age’ text boxes to this class. Hook up the button to a NEW function (in addition to the function previously defined). That function must look at the string entered in the text box and print out “Hello {name}, you are {age} years old!”
    @IBAction func displayGreeting(sender: AnyObject)
    {
        displayText.text = createGreeting(name: name.text, age: age.text)
    }
    
    // TODO three: Hook up the button to a NEW function (in addition to the two above). Print “You can drink” below the above text if the user is above 21. If they are above 18, print “you can vote”. If they are above 16, print “You can drive”
    @IBAction func displayGreetingCapability(sender: AnyObject)
    {
        displayText.text = createGreeting(name: name.text, age: age.text) +
            "\n" + createCapabilities(age.text.toInt()!)
    }
    
    // TODO four: Hook up the button to a NEW function (in additino to the three above). Print “you can drive” if the user is above 16 but below 18. It should print “You can drive and vote” if the user is above 18 but below 21. If the user is above 21, it should print “you can drive, vote and drink (but not at the same time!”.
    @IBAction func displayCapability(sender: AnyObject)
    {
        if (age.text.isEmpty)
        {
            displayText.text = "you must enter your age"
        }
        else
        {
            displayText.text = createCapability(age.text.toInt()! )
        }
    }
    
    func createCapability(age: Int) -> String
    {
        if (age >= 21)
        {
            return "you can drive, vote and drink (but not at the same time!"
        }
        else if (age >= 18)
        {
            return "You can drive and vote"
        }
        else if (age >= 16)
        {
            return "you can drive"
        }
        else
        {
            return "you can't do anything!"
        }
    }
    
    func createGreeting(#name: String, age: String) -> String
    {
        return "Hello \(name), you are \(age) years old"
    }
    
    
    func createCapabilities(age: Int) -> String
    {
        var capabilityMsg: String = ""
        
        if (age >= 21)
        {
            capabilityMsg = "You can drink"
        }
        
        if (age >= 18)
        {
            capabilityMsg += "\nYou can vote"
        }
        
        if (age >= 16)
        {
            capabilityMsg += "\nYou can drive"
        }
        
        return capabilityMsg
    }
}



