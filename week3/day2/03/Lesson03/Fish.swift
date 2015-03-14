//
//  Fish.swift
//  Lesson03
//
//  Created by Nicholas Addison on 14/03/2015.
//  Copyright (c) 2015 General Assembly. All rights reserved.
//

import Foundation

enum FishType {
    case Salt
    case Fresh
    case Both
}

class Fish: Animal {
    
    let type: FishType
    
    init(name: String, type: FishType)
    {
        self.type = type
        super.init(name: name)
    }
    
    override func prettyAnimalName() -> String {
        
        var typeDisplay: String
        
        switch self.type {
            
        case FishType.Salt:
            typeDisplay = "is a salt water fish"
            
        case .Fresh:
            typeDisplay = "is a fresh water fish"
            
        case .Both:
            typeDisplay = "can swim in any water"
        }
        
        return "Fish name: \(super.name) \(typeDisplay)"
    }
}
