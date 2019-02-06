//
//  MediaModel1+CoreDataProperties.swift
//  
//
//  Created by hong  on 2019/2/3.
//
//

import Foundation
import CoreData


extension MediaModel1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MediaModel1> {
        return NSFetchRequest<MediaModel1>(entityName: "MediaModel1")
    }

    @NSManaged public var mediaSize: String?
    @NSManaged public var name: String?
    @NSManaged public var playedTimeLength: Int64
    @NSManaged public var playTimeLength: Int64
    @NSManaged public var rankNumber: Int64
    @NSManaged public var thumbnail: NSData?
    @NSManaged public var url: String?

}
