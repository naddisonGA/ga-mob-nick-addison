//
//  ViewController.swift
//  CustomView
//
//  Created by Nicholas Addison on 24/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topLeftView: CustomView!
    @IBOutlet weak var topRightView: CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topLeftView.first = "runtime"
        
        topRightView.second = "Baxter"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

