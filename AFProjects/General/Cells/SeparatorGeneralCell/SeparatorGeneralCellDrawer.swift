//
//  SeparatorGeneralCellDrawer.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 22/03/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

public final class SeparatorGeneralCellDrawer: CellDrawerProtocol {
    private struct Constants {
        static let reuseID = "SeparatorGeneralCellID"
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }

    public func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? SeparatorGeneralCell,
            let item = item as? SeparatorGeneralCellModel else { return }

        cell.selectionStyle = .none
        cell.separatorView.backgroundColor = item.colorSeparatorView
    }
}

extension SeparatorGeneralCellModel: DrawerProtocol {
    public var cellDrawer: CellDrawerProtocol {
        return SeparatorGeneralCellDrawer()
    }
}
