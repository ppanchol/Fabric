//
//  Task.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-20.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class Task: JsonObject, NSCoding {
    //MARK: Properties
    
    var name:String
    var desc:String
    var dueDate:NSDate
    //var timer:NSTimer
    var status:String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("tasks")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let desc = "description"
        static let dueDate = "dueDate"
        static let status = "status"
    }
    
    //MARK: Initialization
    
    init?(name: String, desc:String, dueDate:NSDate, status:String) {
        // Initialize stored properties.
        self.name = name
        self.desc = desc
        self.dueDate = dueDate
        self.status = status
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        //initialize
    }
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.name)
        aCoder.encodeObject(desc, forKey: PropertyKey.desc)
        aCoder.encodeObject(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encodeObject(status, forKey: PropertyKey.status)
        
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.name) as! String
        let desc = aDecoder.decodeObjectForKey(PropertyKey.desc) as? String
        let dueDate = aDecoder.decodeObjectForKey(PropertyKey.dueDate) as? NSDate
        let status = aDecoder.decodeObjectForKey(PropertyKey.status) as? String
        
        //Must call designated initializer.
        self.init(name:name, desc: desc!, dueDate: dueDate!, status: status!)
        
    }
    
    override func updateJsonEntries() {
        self.clear()
        
        let date = DateUtils.stringFromDate(self.dueDate, format: "yyyy:MM:dd:HH:mm")
        self.setEntry("name", obj: JsonString(str: self.name))
        self.setEntry("description", obj: JsonString(str: self.desc))
        self.setEntry("due_date", obj: JsonString(str: date))
        self.setEntry("status", obj: JsonString(str: self.status))
        self.setEntry("user", obj: JsonString(str: "TBD"))
    }
    
    /*override func toJson()->String {
        let date = DateUtils.stringFromDate(self.dueDate, format: "yyyy:MM:dd:HH:mm")
        /*let array = ["task_name": self.name, "description": self.desc, "due_date": date, "status": self.status, "user": "TBD"]
        return array*/
        return "{" + "\"task_name\":\"" + self.name + "\","
                    + "\"description\":\"" + self.desc + "\","
                    + "\"due_date\":\"" + date + "\","
                    + "\"status\":\"" + self.status + "\","
                    + "\"user\":\"" + "TBD" + "\"}"
    }*/
}

//date conversion utility
class DateUtils {
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
}
