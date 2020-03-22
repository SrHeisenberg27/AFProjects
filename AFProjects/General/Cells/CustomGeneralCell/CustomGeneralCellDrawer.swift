//
//  CustomGeneralCellDrawer.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 22/03/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

public final class CustomGeneralCellDrawer: CellDrawerProtocol {
    private struct Constants {
        static let reuseID = "CustomGeneralCellID"
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.reuseID, for: indexPath)
    }

    public func drawCell(_ cell: UITableViewCell, withItem item: Any) {
        guard let cell = cell as? CustomGeneralCell,
            let item = item as? CustomGeneralCellModel else { return }

        cell.selectionStyle = .none
        cell.customGeneralCellLabel.text = item.labelText
        cell.iconImage.image = UIImage(named: "arrow")
    }
}

extension CustomGeneralCellModel: DrawerProtocol {
    public var cellDrawer: CellDrawerProtocol {
        return CustomGeneralCellDrawer()
    }
}
