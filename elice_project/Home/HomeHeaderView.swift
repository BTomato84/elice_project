//
//  HomeHeaderView.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import UIKit
import FlexLayout

struct HomeHeaderRM : Equatable {
    var logo : ImageRenderingData
    var search : ButtonRenderingData
    var backgorund : ViewRenderingData

    static func `default`() -> HomeHeaderRM {
        let background : ViewRenderingData = .init(backgroundColor: .white, borderWidth: 0.0, borderColor: .clear, cornerRadius: 0.0, contentMode: .topLeft, isHidden: false)
        let logo : ImageRenderingData = .init(imageName: "Logo")
        let search : ButtonRenderingData = .init(buttonImageName: "Search", buttonTitle: nil)
        return HomeHeaderRM(logo: logo, search: search, backgorund: background)
    }
}

class HomeHeaderView : BaseWrappedView<HomeHeaderRM> {
    private var logo : UIImageView = .init()
    private var search : UIButton = .init()

    func setupTopSafeAreaHeight(_ height: CGFloat) {
        view.flex.paddingTop(16.0 + height)
        view.flex.layout(mode: .adjustHeight)
    }

    override func initialized() {
        view.flex.padding(16.0, 16.0, 16.0, 16.0).direction(.row).justifyContent(.spaceBetween).define {
            $0.addItem(logo).height(32.0)
            $0.addItem(search).width(32.0).height(32.0)
        }
    }

    override func render(rm: HomeHeaderRM?) {
        guard let rm else { return }
        logo.render(rm.logo)
        logo.flex.markDirty()
        search.render(rm.search)
        view.render(rm.backgorund)
        view.flex.layout(mode: .adjustHeight)
    }
}
