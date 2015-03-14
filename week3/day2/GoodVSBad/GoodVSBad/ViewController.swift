//
//  ViewController.swift
//  GoodVSBad
//
//  Created by Jack Watson-Hamblin on 12/03/2015.
//  Copyright (c) 2015 ACME Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let superHero = SuperHero(name: "Supermane")
    let superVillain = SuperVillain(name: "Batman")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println("loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func superSwipe(sender: UIGestureRecognizer)
    {
        NSLog("hero swipe")
        superHero.attack(superVillain)
        
        checkForEndGame()
    }

    @IBAction func villainSwipe(sender: UIGestureRecognizer)
    {
        NSLog("villain swipe")
        superVillain.attack(superHero)
        
        checkForEndGame()
    }
    
    func checkForEndGame()
    {
        if (superHero.health <= 0 || superVillain.health <= 0)
        {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

