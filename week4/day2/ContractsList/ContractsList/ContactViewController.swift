//
//  ContactViewController.swift
//  ContractsList
//
//  Created by Nicholas Addison on 19/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController
{

    var firstName = "inital name"
    var contact: Contact?
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func renderForm() -> Contact
    {
        return Contact(
            firstName: firstNameField!.text,
            lastName: lastNameField!.text,
            mobile: mobileField!.text,
            email: emailField!.text)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
}
