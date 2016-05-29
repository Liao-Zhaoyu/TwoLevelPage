//
//  Book+CoreDataProperties.swift
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

extension Book {

    @NSManaged var date: NSDate?
    @NSManaged var img: NSData?
    @NSManaged var name: String?

}
