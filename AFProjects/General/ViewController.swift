//
//  ViewController.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 21/03/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet public weak var generalTableView: UITableView!

    var arrayCells = ["MapKitVC", "CarrouselSectionBoxVC", "ImageViewerExternalVC", "WhereIsMyMoneyVC", "RealmSwiftVC", "ToDoAppVC"]

    var cells = [DrawerProtocol]()

    override func viewDidLoad() {
        super.viewDidLoad()

        createNavBar()
        createTableView()
    }

    fileprivate func createNavBar() {
        self.navigationItem.title = "AFProject"
    }

    fileprivate func createTableView() {
        cells = []

        registerTableViewCells()
        configurateTableView()
        createTableViewCells()
    }

    fileprivate func registerTableViewCells() {
        generalTableView.register(UINib.init(nibName: "CustomGeneralCell", bundle: nil), forCellReuseIdentifier: "CustomGeneralCellID")
        generalTableView.register(UINib.init(nibName: "SeparatorGeneralCell", bundle: nil), forCellReuseIdentifier: "SeparatorGeneralCellID")
    }

    fileprivate func configurateTableView() {
        generalTableView.delegate = self
        generalTableView.dataSource = self
        generalTableView.separatorStyle = .none
    }

    fileprivate func createTableViewCells() {
        for i in 0...arrayCells.count - 1 {
            cells.append(CustomGeneralCellModel(labelText: arrayCells[i]))
            cells.append(SeparatorGeneralCellModel(colorSeparatorView: UIColor.lightGray))
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cells[indexPath.row]
        let drawer = item.cellDrawer
        let cell = drawer.tableView(tableView, cellForRowAt: indexPath)
        drawer.drawCell(cell, withItem: item)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var paramSelected: Int = 0
        let indexPathRow = indexPath.row
        if cell.isKind(of: CustomGeneralCell.self) {
            switch indexPathRow {
            case 0:
                paramSelected = 0
            default:
                paramSelected = indexPathRow / 2
            }

            switch arrayCells[paramSelected] {
            case "RealmSwiftVC":
                performSegue(withIdentifier: "RealmSwiftVC", sender: cell)
            case "MapKitVC":
                performSegue(withIdentifier: "MapKitVC", sender: cell)
            case "CarrouselSectionBoxVC":
                performSegue(withIdentifier: "CarrouselSectionBoxVC", sender: cell)
            case "ImageViewerExternalVC":
                performSegue(withIdentifier: "ImageViewerExternalVC", sender: cell)
            case "WhereIsMyMoneyVC":
                performSegue(withIdentifier: "WhereIsMyMoneyVC", sender: cell)
            case "ToDoAppVC":
                performSegue(withIdentifier: "ToDoAppVC", sender: cell)
            default:
                break
            }
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 2 {
        case 0:
            return 70
        default:
            return 1
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
