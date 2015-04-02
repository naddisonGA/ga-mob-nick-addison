//
//  Calculator.swift
//  Calculator
//
//  Created by Nicholas Addison on 31/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

enum MathOperation {
    case Plus
    case Minus
    case Times
    case Div
}

class Calculator
{
    //MARK: - Private properties
    
    // private properties so they can only be mutated via the mutating functions
    private var _display: String = "0"
    private var _firstDigit = true
    private var _decimalDisplay = false
    
    private var _memory: Double = 0
    
    private var _operation = MathOperation.Plus
    
    //MARK: - Getters
    
    var display: String {
        // TODO add number formatting
        return _display
    }
    
    //MARK: - Mutating functions
    
    func reset()
    {
        _display = "0"
        _firstDigit = true
        _decimalDisplay = false
        
        _memory = 0
        
        _operation = MathOperation.Plus
    }
    
    func addDigitToDisplay(digit: Character) -> String
    {
        // if first digit of a new number has been added
        if _firstDigit
        {
            if digit != "."
            {
                // set display to an empty string so when the digit is appended below the display will equal the added digit
                _display = ""
            }
            else
            {
                // if the digit is a decimal then set to "0" so after the below append the display becomes "0."
                _display = "0"
            }
        }
        
        // if a decimal was entered
        if digit == "."
        {
            // if the display is already a decimal
            if _decimalDisplay
            {
                // don't need to do anything
                return _display
            }
            else
            {
                // flag the display is a decimal
                _decimalDisplay = true
            }
        }
        
        _display.append(digit)
        _firstDigit = false
        
        return _display
    }
    
    // performs the calculation and sets the new operation for the next calculation
    func setOperation(operation: MathOperation) -> String
    {
        // need to perform calc against old operation
        performOperation()
        
        // set new operation for the next calculation
        _operation = operation
        
        // about to enter a new number so reset flags
        _firstDigit = true
        _decimalDisplay = false
        
        // return calculated number as a string
        return _display
    }
    
    func equals() -> String
    {
        performOperation()
        
        _memory = 0
        _operation = MathOperation.Plus
        _firstDigit = true
        _decimalDisplay = false
        
        return _display
    }
    
    // performs the maths operation against the display and what is in memory
    // the calculate number is converted back to a string and stored in the private _display property
    func performOperation()
    {
        // convert the private display of type String to a Double type
        let display = (_display as NSString).doubleValue
        
        // perform operation of display against what is in memory
        switch _operation {
        case .Plus:
            _memory += display
            
        case .Minus:
            _memory -= display
            
        case .Times:
            _memory *= display
            
        case .Div:
            if display == 0
            {
                // can not divide by 0
                reset()
                _display = "Error"
                return
            }
            else
            {
                _memory /= display
            }
        }
        
        // convert _memory of type Double to a String
        _display = formatNumber(_memory)
    }
    
    //MARK: - immutable functions
    
    func formatNumber(number: Double) -> String
    {
        return String(format:"%g", number)
    }
}