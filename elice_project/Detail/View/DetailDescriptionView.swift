//
//  DetailDescriptionView.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import FlexLayout

class DetailDescriptionView : BaseWrappedView<LabelRenderingData> {
    private let description : UILabel = .init()

    override func initialized() {
        view.flex.define {
            $0.addItem(description).width(100%)
        }
    }

    override func render(rm: LabelRenderingData?) {
        guard let rm else { return }
        description.render(rm)
        description.flex.markDirty()
    }
}
