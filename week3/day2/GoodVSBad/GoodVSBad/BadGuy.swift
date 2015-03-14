//
//  BadGuy.swift
//  GoodVSBad
//
//  Created by Jack Watson-Hamblin on 12/03/2015.
//  Copyright (c) 2015 ACME Inc. All rights reserved.
//

import Foundation

class BadGuy : Player {
    func attack(player: GoodGuy) {
        super.attackOpponent(player)
    }
}