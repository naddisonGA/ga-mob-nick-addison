//
//  HMACEncoding.swift
//  networking
//
//  Created by Nicholas Addison on 5/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

enum BinaryEncoding
{
    case UTF8, Base64, Hex
    
    //MARK: - decode from encoded data to binary data
    
    // converts an encoded String to data. eg decode base64 to binaary data
    func decode(fromEncodedString encodedString: String) -> NSData?
    {
        switch self {
        case .Base64:
            return NSData(base64EncodedString: encodedString, options: .allZeros)
            
        case .Hex:
            
            // based on https://github.com/CryptoCoinSwift/RIPEMD-Swift/blob/master/Classes/NSData%2BHexString.swift
            
            let encodedStringLength: Int = count(encodedString)
            
            // if there is an odd number of characters in the string
            if encodedStringLength % 2 == 1
            {
                // return nil as a hexadecimal string needs to be an even number
                return nil
            }
            
            // initialise variabled before looping through the characters in the encoded string
            var data = NSMutableData()
            var temp = ""
            
            // for each character in the encoded string
            for char in encodedString
            {
                temp.append(char)
                
                if(count(temp) == 2)
                {
                    let scanner = NSScanner(string: temp)
                    var value: CUnsignedInt = 0
                    scanner.scanHexInt(&value)
                    data.appendBytes(&value, length: 1)
                    temp = ""
                }
            }
            
            return data as NSData
            
        case .UTF8:
            return (encodedString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
    
    //MARK: - encode binary data to encoded data
    
    func encode(stringToEncode: String) -> String?
    {
        switch self {
            
        case .Base64:
            // convert string to be encoded to a Data object
            if let stringData = (stringToEncode as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            {
                // base64 encode the Data object and return the String
                return stringData.base64EncodedStringWithOptions(nil) as String
            }
            else
            {
                return nil
            }
            
        case .Hex:
            var encodedString = NSMutableString()
            
            // for each character in the String
            for char in stringToEncode.unicodeScalars
            {
                // convert ascii decimal value of character to hexidecimal value and then
                // append converted hexidecimal value to the encoded string
                encodedString.appendFormat("%02x", char.value)
            }
            
            return encodedString as String
            
        case UTF8:
            // nothing to convert so just return a copy of the string
            return String(stringToEncode)
        }
    }
    
    func encode(fromPointer: UnsafeMutablePointer<UInt8>, length: Int) -> String?
    {
        switch self {
            
        case .Base64:
            let data = NSData(bytesNoCopy: fromPointer, length: length)
            return data.base64EncodedStringWithOptions(nil) as String
            
        case .Hex:
            var hash = NSMutableString()
            
            for i in 0..<length {
                hash.appendFormat("%02x", fromPointer[i])
            }
            
            return hash as String
            
        case UTF8:
            var hash = NSMutableString()
            
            for i in 0..<length {
                hash.appendFormat("%c", fromPointer[i])
            }
            
            return hash as String
        }
    }
    
    func encode(stringToEncode: String) -> NSData?
    {
        switch self {
            
        case .Base64:
            // convert string to be encoded to a Data object
            if let stringData = (stringToEncode as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            {
                // base64 encode the Data object
                let encodedString: NSString = stringData.base64EncodedStringWithOptions(nil)
                
                // convert encoded string back to data object
                return encodedString.dataUsingEncoding(NSUTF8StringEncoding)
            }
            else
            {
                return nil
            }
            
        case .Hex:
            
            var encodedString = NSMutableString()
            
            // for each character in the String
            for char in stringToEncode.unicodeScalars
            {
                // convert ascii decimal value of character to hexidecimal value and then
                // append converted hexidecimal value to the encoded string
                encodedString.appendFormat("%02x", char.value)
            }
            
            return (encodedString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            
        case UTF8:
            // no convertion needed so just return data objet from string
            return stringToEncode.dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
}