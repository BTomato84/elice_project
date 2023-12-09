//
//  HomeViewController.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import UIKit

class HomeViewController: SectionListViewController {

    private let header : HomeHeaderView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(header.view)
        header.view.pin.left().top().right()
        header.render(rm: .default())

        view.addSubview(cv)
        cv.pin.left().below(of: header.view).right().bottom()
        cv.contentInset.bottom = view.safeAreaInsets.bottom
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.view.pin.left().top().right()
        header.setupTopSafeAreaHeight(view.safeAreaInsets.top)
        cv.pin.left().below(of: header.view).right().bottom()
        cv.contentInset.bottom = view.safeAreaInsets.bottom
    }
}
