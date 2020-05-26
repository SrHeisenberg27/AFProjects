//
//  TaskListModel.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListModel: Object {
    dynamic var name: String?
    var tasks: [TaskModel]? = []
}
