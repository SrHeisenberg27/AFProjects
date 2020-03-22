//
//  CellDrawerProtocol.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 22/03/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

public protocol CellDrawerProtocol {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

    func drawCell (_ cell: UITableViewCell, withItem item: Any)
}
