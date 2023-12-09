//
//  DetailContentHeader.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import FlexLayout

struct DetailContentSectionHeaderRM : Equatable {
    var label : LabelRenderingData
    var devider : ViewRenderingData

    static func instance(text: String) -> DetailContentSectionHeaderRM {
        let label : LabelRenderingData = .init(font: .systemFont(ofSize: 14.0, weight: .bold), text: text, color: .init(hexString: "#524FA1"))
        let divider : ViewRenderingData = .init(backgroundColor: .init(hexString: "#AEAEAE"))
        return DetailContentSectionHeaderRM(label: label, devider: divider)
    }
}

class DetailContentSectionHeaderView : BaseWrappedView<DetailContentSectionHeaderRM> {
    let label : UILabel = .init()
    let divider : UIView = .init()

    override func initialized() {
        view.flex.direction(.column).paddingTop(8.0).define {
            $0.addItem(label).height(20.0).marginBottom(10.0)
            $0.addItem(divider).width(100%).height(1.0)
        }
    }

    override func render(rm: DetailContentSectionHeaderRM?) {
        guard let rm else { return }
        label.render(rm.label)
        divider.render(rm.devider)
    }
}
