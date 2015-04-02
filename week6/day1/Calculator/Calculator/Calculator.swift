//
//  Calculator.swift
//  Calculator
//
//  Created by Nicholas Addison on 31/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

// calculator's allowed mathematical operations
enum MathOperation {
    case Plus
    case Minus
    case Times
    case Div
}

// delegate class for the calculator view controller
class Calculator
{
    //MARK: - Private properties
    
    // private properties so they can only be mutated via the mutating functions
    // the following hold the number currently being entered
    private var _display: String = "0"
    // a flag to mark if the digit being added in the display is the first number or decimal point
    private var _firstDigit = true
    // flag to mark if the number being entered is a decimal. The is to prevent multiple decimal points being entered into a number
    private var _decimalDisplay = false
    
    // holds the last calculated value. Defaults to 0 on load
    private var _memory: Double = 0
    
    // stores the mathimatical operation to be performed next by the calculator
    private var _operation = MathOperation.Plus
    
    //MARK: - Getters
    
    // simple getter to the private _display property that can only be mutated by the mutating functions
    var display: String {
        // TODO add number formatting
        return _display
    }
    
    //MARK: - Mutating functions
    
    // resets the calculator to 0 with a plus operator and zero in memory
    func reset()
    {
        _display = "0"
        _firstDigit = true
        _decimalDisplay = false
        
        _memory = 0
        
        _operation = MathOperation.Plus
    }
    
    // adds a number or decimal 
    func addDigitToDisplay(digit: Character) -> String
    {
        // if first digit of a new number has been added
        if _firstDigit
        {
            if digit == "."
            {
                // if the digit is a decimal then set to "0" so after the below append the display becomes "0."
                _display = "0"
            }
            else
            {
                // set display to an empty string so when the digit is appended below the display will equal the added digit
                _display = ""
            }
        }
        
        // no need to append a 0 to a 0
        if _display == "0" && digit == "0"
        {
            return "0"
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
    
    // performs the stored mathematical operation against the display and what is in memory
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
    
    // converts a double number to string
    func formatNumber(number: Double) -> String
    {
        return String(format:"%g", number)
    }
}