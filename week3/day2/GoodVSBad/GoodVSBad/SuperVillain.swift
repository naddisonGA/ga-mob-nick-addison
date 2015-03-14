//
//  SuperVillain.swift
//  GoodVSBad
//
//  Created by Jack Watson-Hamblin on 12/03/2015.
//  Copyright (c) 2015 ACME Inc. All rights reserved.
//

import Foundation

class SuperVillain :BadGuy {
    override func attack(player: GoodGuy) {
        println("*heavy breathing*")
        super.attack(player)
    }
}