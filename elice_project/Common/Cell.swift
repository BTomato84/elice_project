//
//  Cell.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

final class Cell<Content>: UICollectionViewCell where Content: WrappedView {
    lazy var wrappedView: Content = .init(with: contentView)
    override init(frame: CGRect) {
        super.init(frame: frame)
        let _ = wrappedView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let _ = wrappedView
    }

    func render(with rm: Content.RM) {
        wrappedView.render(rm: rm)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return wrappedView.cacluatingSize(size: targetSize, requiredVertical: verticalFittingPriority == .required)
    }
}
