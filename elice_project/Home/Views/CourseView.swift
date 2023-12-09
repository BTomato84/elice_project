//
//  CourseView.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import FlexLayout

struct CourseTagRM : Equatable {
    var label : LabelRenderingData
    var background : ViewRenderingData

    static func instance(text: String) -> CourseTagRM {
        let label : LabelRenderingData = .init(font: .systemFont(ofSize: 8.0), text: text, color: .black)
        let background : ViewRenderingData = .init(backgroundColor: .init(hexString: "#E4E4E4"), borderWidth: 0.0, borderColor: .clear, cornerRadius: 4.0, contentMode: .topLeft, isHidden: false)
        return CourseTagRM(label: label, background: background)
    }
}

class CourseTagView : BaseWrappedView<CourseTagRM> {
    private var label : UILabel = .init()

    override func initialized() {
        view.flex.padding(2.0, 4.0).marginRight(4.0).marginBottom(4.0).define {
            $0.addItem(label).height(12.0)
        }
    }

    override func render(rm: CourseTagRM?) {
        guard let rm else { return }
        view.render(rm.background)
        label.render(rm.label)
        label.flex.markDirty()
    }
}

struct CourseViewRM : Equatable {
    var image : ImageRenderingData
    var title : LabelRenderingData
    var description : LabelRenderingData
    var tags : [CourseTagRM]
    var background : ViewRenderingData
}

class CourseView : BaseWrappedView<CourseViewRM> {
    private let image : UIImageView = .init()
    private let title : UILabel = .init()
    private let description : UILabel = .init()
    private let tagHolder : UIView = .init()
    private var tags : [CourseTagView] = []

    override func initialized() {
        view.flex.width(200.0).height(220.0).direction(.column).define {
            $0.addItem(image).width(100%).height(100.0).marginBottom(8.0)
            $0.addItem(title).width(100%).marginBottom(2.0)
            $0.addItem(description).width(100%).marginBottom(8.0)
            $0.addItem(tagHolder).padding(8.0, 0.0, 4.0, 0.0).width(100%).direction(.row).wrap(.wrap).maxHeight(52.0)
        }
        tagHolder.clipsToBounds = true
    }

    override func render(rm: CourseViewRM?) {
        guard let rm else { return }
        image.render(rm.image)
        title.render(rm.title)
        title.flex.markDirty()
        description.render(rm.description)
        description.flex.markDirty()
        tags.forEach { $0.view.removeFromSuperview() }
        tags = rm.tags.map {
            let view = CourseTagView()
            view.render(rm: $0)
            tagHolder.flex.addItem(view.view)
            return view
        }
    }
}
