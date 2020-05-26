//
//  TaskModel.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit
import RealmSwift

class TaskModel: Object {

    dynamic var name: String?
    dynamic var date: NSDate?
    dynamic var note: String?
    dynamic var isCompleted: Bool?

    convenience init(name: String, date: NSDate, note: String, isCompleted: Bool) {
        self.init()
        self.name = name
        self.date = date
        self.note = note
        self.isCompleted = isCompleted
    }
}
