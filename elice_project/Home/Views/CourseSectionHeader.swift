//
//  CourseSectionHeader.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

struct CourseSectionHeaderRM : Equatable {
    var label : LabelRenderingData

    static func instance(text: String) -> CourseSectionHeaderRM {
        let label : LabelRenderingData = .init(font: .systemFont(ofSize: 16.0, weight: .bold), text: text, color: .black)
        return CourseSectionHeaderRM(label: label)
    }
}

class CourseSectionHeaderView : BaseWrappedView<CourseSectionHeaderRM> {
    let label : UILabel = .init()

    override func initialized() {
        view.flex.paddingTop(8.0).addItem(label)
    }

    override func render(rm: CourseSectionHeaderRM?) {
        guard let rm else { return }
        label.render(rm.label)
    }
}
