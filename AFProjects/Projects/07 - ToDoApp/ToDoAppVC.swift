//
//  ToDoAppVC.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

class ToDoAppVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var cells = [DrawerProtocol]()

    var taskList = TaskListModel()
    var task1 = TaskModel()
    var task2 = TaskModel()
    var task3 = TaskModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        cells = []

        let backbutton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = backbutton
        self.navigationItem.title = "ToDoApp"

        self.createTaskList()
        self.registerTableViewCells()
        self.createTableViewCells()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    fileprivate func createTaskList() {
        taskList.name = "Main TaskList"

        task1 = TaskModel(name: "Ir al super", date: NSDate(), note: "Hola hola", isCompleted: false)
        taskList.tasks?.append(task1)
        task2 = TaskModel(name: "Ir a comer", date: NSDate(), note: "Hola hola", isCompleted: false)
        taskList.tasks?.append(task2)
        task3 = TaskModel(name: "Ir al cenar", date: NSDate(), note: "Hola hola", isCompleted: false)
        taskList.tasks?.append(task3)
    }

    fileprivate func registerTableViewCells() {
        tableView.register(UINib.init(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCellID")
        tableView.register(UINib.init(nibName: "SeparatorGeneralCell", bundle: nil), forCellReuseIdentifier: "SeparatorGeneralCellID")
    }

    fileprivate func createTableViewCells() {
        for i in 0...(taskList.tasks?.count ?? -1) - 1 {
            cells.append(TaskCellModel(labelText: taskList.tasks?[i].name ?? ""))
            cells.append(SeparatorGeneralCellModel(colorSeparatorView: UIColor.lightGray))
        }
    }

    @objc func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ToDoAppVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tasksCount = taskList.tasks?.count {
            return tasksCount
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cells[indexPath.row]
        let drawer = item.cellDrawer
        let cell = drawer.tableView(tableView, cellForRowAt: indexPath)
        drawer.drawCell(cell, withItem: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 2 {
        case 0:
            return 70
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("misco")
    }
}
