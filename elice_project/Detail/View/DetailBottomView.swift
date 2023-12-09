//
//  DetailBottomView.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import UIKit
import FlexLayout

struct DetailBottomRM : Equatable {
    var button : ButtonRenderingData
    var backgorund : ViewRenderingData

    static func commit() -> DetailBottomRM {
        let background : ViewRenderingData = .init(backgroundColor: .white)
        let button : ButtonRenderingData = .init(
            buttonTitle: "수강 신청",
            titleFont: .systemFont(ofSize: 16.0, weight: .bold),
            titleColor: .white,
            view: .init(backgroundColor: .init(hexString: "#5A2ECC"), cornerRadius: 10.0)
        )
        return DetailBottomRM(button: button, backgorund: background)
    }

    static func cancel() -> DetailBottomRM {
        let background : ViewRenderingData = .init(backgroundColor: .white)
        let button : ButtonRenderingData = .init(
            buttonTitle: "수강 취소",
            titleFont: .systemFont(ofSize: 16.0, weight: .bold),
            titleColor: .white,
            view: .init(backgroundColor: .init(hexString: "#F44336"), cornerRadius: 10.0)
        )
        return DetailBottomRM(button: button, backgorund: background)
    }
}

class DetailBottomView : BaseWrappedView<DetailBottomRM> {
    private var button : UIButton = .init()
    var buttonSelected : (() -> Void) = { }

    func setupBottomSafeAreaHeight(_ height: CGFloat) {
        view.flex.paddingBottom(16.0 + height)
        view.flex.layout(mode: .adjustHeight)
    }

    override func initialized() {
        view.flex.padding(16.0, 16.0, 16.0, 16.0).direction(.row).define {
            $0.addItem(button).grow(1).height(48.0)
        }
        button.addAction(.init(handler: { [weak self] (_) in self?.buttonSelected() }), for: .touchUpInside)
    }

    override func render(rm: DetailBottomRM?) {
        guard let rm else { return }
        button.render(rm.button)
        view.render(rm.backgorund)
        view.flex.layout(mode: .adjustHeight)
    }
}
