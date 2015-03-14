//
//  GoodGuy.swift
//  GoodVSBad
//
//  Created by Jack Watson-Hamblin on 12/03/2015.
//  Copyright (c) 2015 ACME Inc. All rights reserved.
//

import Foundation

class GoodGuy : Player {
    func attack(player: BadGuy) {
        super.attackOpponent(player)
    }
}