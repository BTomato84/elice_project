//
//  DetailViewHeader.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import UIKit
import FlexLayout

struct DetailHeaderRM : Equatable {
    var back : ButtonRenderingData
    var backgorund : ViewRenderingData

    static func `default`() -> DetailHeaderRM {
        let background : ViewRenderingData = .init(backgroundColor: .white, borderWidth: 0.0, borderColor: .clear, cornerRadius: 0.0, contentMode: .topLeft, isHidden: false)
        let back : ButtonRenderingData = .init(buttonImageName: "Back", buttonTitle: nil)
        return DetailHeaderRM(back: back, backgorund: background)
    }
}

class DetailHeaderView : BaseWrappedView<DetailHeaderRM> {
    private var back : UIButton = .init()
    var backSelected : (() -> Void) = { }

    func setupTopSafeAreaHeight(_ height: CGFloat) {
        view.flex.paddingTop(16.0 + height)
        view.flex.layout(mode: .adjustHeight)
    }

    override func initialized() {
        view.flex.padding(4.0, 4.0, 4.0, 4.0).direction(.row).justifyContent(.spaceBetween).define {
            $0.addItem(back).width(48.0).height(48.0)
        }
        back.addAction(.init(handler: { [weak self] (_) in self?.backSelected() }), for: .touchUpInside)
    }

    override func render(rm: DetailHeaderRM?) {
        guard let rm else { return }
        back.render(rm.back)
        view.render(rm.backgorund)
        view.flex.layout(mode: .adjustHeight)
    }
}

