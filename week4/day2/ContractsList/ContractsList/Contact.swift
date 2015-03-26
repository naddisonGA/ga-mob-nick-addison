//
//  Contact.swift
//  ContractsList
//
//  Created by Nicholas Addison on 19/03/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

var id = 0

struct Contact
{
    let uid: Int
    let firstName: String
    let lastName: String
    let mobile: String?
    let email: String?
    
    init(firstName: String, lastName: String, mobile: String?, email: String?)
    {
        uid = id++
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.email = email
    }
}