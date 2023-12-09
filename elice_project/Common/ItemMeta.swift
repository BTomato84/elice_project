//
//  ItemMeta.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

protocol ItemMetaForCellType {
    associatedtype CellType
}

protocol ItemMetaForRendering {
    var reuseIdentifier: String { get }
    func rendering(cell: UICollectionViewCell)
    func Class() -> AnyClass?
    var selected: () -> Void { get }
}

final class ItemMeta<WV>: ItemMetaForCellType where WV: WrappedView {
    typealias CellType = Cell<WV>
    private let rm : WV.RM
    let reuseIdentifier: String
    let selected : (() -> Void)

    init(reuseIdentifier: String? = nil, rm: WV.RM, selected: @escaping (() -> Void) = { }) {
        self.reuseIdentifier = reuseIdentifier ?? CellType.description()
        self.rm = rm
        self.selected = selected
    }
}
