// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

public class FibAdder {
    
    func fibonacciNumberAtIndex(indexOfFibonacciNumber: Int) -> Int
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

let fibAdder = FibAdder()

fibAdder.fibonacciNumberAtIndex(8)
