//
//  TaskDrawer.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

public final class TaskCellDrawer: CellDrawerProtocol {
    private struct Constants {
        static let reuseID = "TaskCellID"
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }

    public func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? TaskCell,
            let item = item as? TaskCellModel else { return }

        cell.selectionStyle = .none
        cell.customGeneralCellLabel.text = item.labelText
        cell.iconImage.image = UIImage(named: "arrow")
    }
}

extension TaskCellModel: DrawerProtocol {
    public var cellDrawer: CellDrawerProtocol {
        return TaskCellDrawer()
    }
}
