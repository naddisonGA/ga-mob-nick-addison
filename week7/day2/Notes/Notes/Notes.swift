//
//  Notes.swift
//  Notes
//
//  Created by Nicholas Addison on 9/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import CoreData

class Notes: NSManagedObject {

    @NSManaged var text: String
    @NSManaged var title: String

}
