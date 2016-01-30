//
//  ProjectsDAO.swift
//  TimeBoxer
//
//  Created by Tomasz Urbanowicz on 30/01/16.
//  Copyright © 2016 Tomasz Urbanowicz. All rights reserved.
//

import UIKit

class ProjectsDAO: NSObject {
    let persistenceKey = "persistenceKey"
    
    func saveProjects(projects: Array<Project>) {
        let dataFilePath = self.dataFilePath()
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(projects, forKey: persistenceKey)
        archiver.finishEncoding()
        data.writeToFile(dataFilePath, atomically: true)
    }
    
    func loadProjects() -> Array<Project>? {
        let dataFilePath = self.dataFilePath()
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(dataFilePath) {
            let data = NSMutableData(contentsOfFile: dataFilePath)!
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            let projects = unarchiver.decodeObjectForKey(persistenceKey) as? Array<Project>
            unarchiver.finishDecoding()
            return projects
        } else {
            return nil
        }
    }
    
    private func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask,true)
        let documentsDirectory = paths[0] as NSString
        return documentsDirectory.stringByAppendingPathComponent("data.plist") as String
    }
}
