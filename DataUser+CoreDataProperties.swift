//
//  DataUser+CoreDataProperties.swift
//  
//
//  Created by Ly Truong H. VN.Danang on 31/05/2023.
//
//

import Foundation
import CoreData


extension DataUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataUser> {
        return NSFetchRequest<DataUser>(entityName: "DataUser")
    }

    @NSManaged public var category: String?
    @NSManaged public var info: String?
    @NSManaged public var money: Int64
    @NSManaged public var descriptionInfo: String?

}
