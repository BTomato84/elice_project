//
//  DetailLectureView.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import FlexLayout

struct DetailLectureRM : Equatable {
    let topLine     : ViewRenderingData
    let circle      : ViewRenderingData
    let bottomLine  : ViewRenderingData
    let title       : LabelRenderingData
    let description : LabelRenderingData

    static func instance(title: String, description: String, isFirst: Bool, isLast: Bool) -> DetailLectureRM {
        let topLine : ViewRenderingData = isFirst ? .init(isHidden: true) : .init(backgroundColor: .init(hexString: "#5A2ECC"), isHidden: false)
        let circle : ViewRenderingData = .init(backgroundColor: .white, borderWidth: 1.0, borderColor: .init(hexString: "#5A2ECC"), cornerRadius: 8.0)
        let bottomLine : ViewRenderingData = isLast ? .init(isHidden: true) : .init(backgroundColor: .init(hexString: "#5A2ECC"), isHidden: false)
        let title : LabelRenderingData = .init(font: .systemFont(ofSize: 18.0, weight: .bold), text: title, color: .black)
        let description : LabelRenderingData = .init(font: .systemFont(ofSize: 14.0), text: description, color: .black, numberOfLines: 0)
        return DetailLectureRM(topLine: topLine, circle: circle, bottomLine: bottomLine, title: title, description: description)
    }
}

class DetailLectureView : BaseWrappedView<DetailLectureRM> {
    private let topLine : UIView = .init()
    private let bottomLine : UIView = .init()
    private let circle : UIView = .init()
    private let lineHolder : UIView = .init()

    private let title : UILabel = .init()
    private let description : UILabel = .init()
    private let contentHolder : UIView = .init()

    override func initialized() {
        view.flex.direction(.row).define {
            $0.addItem(lineHolder).width(16.0).height(100%).marginRight(8.0)
            $0.addItem(contentHolder).grow(1).shrink(1)
        }
        lineHolder.flex.define {
            $0.addItem(topLine).position(.absolute).width(2.0).top(0).left(7.0).right(7.0).height(22.0)
            $0.addItem(bottomLine).position(.absolute).width(2.0).top(22.0).left(7.0).right(7.0).bottom(0)
            $0.addItem(circle).position(.absolute).width(16.0).height(16.0).top(14.0).left(0.0).right(0.0)
        }
        contentHolder.flex.padding(8.0, 0.0, 8.0, 0.0).direction(.column).define {
            $0.addItem(title).height(28.0).marginBottom(4.0)
            $0.addItem(description)
        }
    }

    override func render(rm: DetailLectureRM?) {
        guard let rm else { return }
        topLine.render(rm.topLine)
        circle.render(rm.circle)
        bottomLine.render(rm.bottomLine)
        title.render(rm.title)
        title.flex.markDirty()
        description.render(rm.description)
        description.flex.markDirty()
    }
}
