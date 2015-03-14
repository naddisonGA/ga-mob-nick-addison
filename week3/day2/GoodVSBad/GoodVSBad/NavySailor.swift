//
//  NavySailor.swift
//  GoodVSBad
//
//  Created by Jack Watson-Hamblin on 12/03/2015.
//  Copyright (c) 2015 ACME Inc. All rights reserved.
//

import Foundation

class NavySailor : GoodGuy {
    override func attack(player: BadGuy) {
        println("Eeep")
        super.attack(player)
    }
}