//
//  Fib.swift
//  Lesson02
//
//  Created by Nicholas Addison on 6/03/2015.
//  Copyright (c) 2015 General Assembly. All rights reserved.
//

import Foundation

/*
TODO seven: Hook up the text input box, label and and a ‘calculate’ button. Create a ‘fibonacci adder’ class with a method ‘fibonacciNumberAtIndex' which takes indexOfFibonacciNumber (an integer).  When the button is pressed, create an instance of that class, call the method, and print out the appropriate fibonacci number of an inputted integer.
The first fibonacci number is 0, the second is 1, the third is 1, the fourth is two, the fifth is 3, the sixth is 5, etc. The Xth fibonacci number is the sum of the X-1th fibonacci number and the X-2th fibonacci number.
*/

public class FibAdder {
    
    public func fibonacciNumberAtIndex(indexOfFibonacciNumber: Int) -> Int
    {
        if (indexOfFibonacciNumber <= 1)
        {
            return 0
        }
        else if (indexOfFibonacciNumber == 2)
        {
            return 1
        }
        
        var lastNumber: Int = 0
        var fibNumber: Int = 1
        
        for i in 1...indexOfFibonacciNumber - 2
        {
            var newLastNumber = fibNumber
            
            fibNumber = lastNumber + fibNumber
            
            lastNumber = newLastNumber
        }
        
        return fibNumber
    }
}