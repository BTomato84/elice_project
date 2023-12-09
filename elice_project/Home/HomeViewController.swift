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
        view.backgroundColor = .red

        view.addSubview(header.view)
        header.view.pin.left().top().right()
        header.render(rm: .default())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.view.pin.left().top().right()
        header.setupTopSafeAreaHeight(view.safeAreaInsets.top)
    }
}
