//
//  Page+CoreDataProperties.swift
//  book
//
//  Created by lzy-os on 16/5/29.
//  Copyright © 2016年 lzy-os. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Page {

    @NSManaged var date: NSDate?
    @NSManaged var bookdate: String?
    @NSManaged var ink: NSData?
    @NSManaged var text: String?
    @NSManaged var name: String?

}
