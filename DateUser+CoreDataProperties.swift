//
//  DateUser+CoreDataProperties.swift
//  
//
//  Created by Ly Truong H. VN.Danang on 09/06/2023.
//
//

import Foundation
import CoreData


extension DateUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateUser> {
        return NSFetchRequest<DateUser>(entityName: "DateUser")
    }

    @NSManaged public var date: String?

}
