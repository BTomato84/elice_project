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
    associatedtype ReusableViewType
}

protocol ItemMetaForRendering {
    var reuseIdentifier: String { get }
    func rendering(cell: UICollectionViewCell)
    func rendering(reusableView: UICollectionReusableView)
    func cellClass() -> AnyClass?
    func reusableClass() -> AnyClass?
    var selected: () -> Void { get }
}

final class ItemMeta<WV>: ItemMetaForCellType where WV: WrappedView {
    typealias CellType = Cell<WV>
    typealias ReusableViewType = ReusableView<WV>
    private let rm : WV.RM
    let reuseIdentifier: String
    let selected : (() -> Void)

    init(reuseIdentifier: String? = nil, rm: WV.RM, selected: @escaping (() -> Void) = { }) {
        self.reuseIdentifier = reuseIdentifier ?? CellType.description()
        self.rm = rm
        self.selected = selected
    }
}
extension ItemMeta: ItemMetaForRendering {
    func rendering(cell: UICollectionViewCell) {
        if let cell = cell as? CellType {
            cell.render(with: rm)
        }
    }

    func rendering(reusableView: UICollectionReusableView) {
        if let reusableView = reusableView as? ReusableViewType {
            reusableView.render(with: rm)
        }
    }

    func cellClass() -> AnyClass? {
        CellType.self
    }
    
    func reusableClass() -> AnyClass? {
        ReusableViewType.self
    }
}
