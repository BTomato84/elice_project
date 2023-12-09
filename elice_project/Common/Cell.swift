//
//  Cell.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

final class Cell<Content>: UICollectionViewCell where Content : WrappedView {
    private let wrappedView: Content = .init(with: nil)
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(wrappedView.view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(wrappedView.view)
    }

    func render(with rm: Content.RM) {
        wrappedView.render(rm: rm)
        wrappedView.view.flex.layout(mode: .adjustHeight)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return wrappedView.cacluatingSize(size: targetSize, requiredVertical: verticalFittingPriority == .required)
    }
}

final class ReusableView<Content> : UICollectionReusableView where Content : WrappedView {
    private var wrappedView: Content = .init(with: nil)
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(wrappedView.view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(wrappedView.view)
    }

    func render(with rm: Content.RM) {
        wrappedView.render(rm: rm)
        wrappedView.view.flex.layout(mode: .adjustHeight)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return wrappedView.cacluatingSize(size: targetSize, requiredVertical: verticalFittingPriority == .required)
    }
}
