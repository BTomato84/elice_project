//
//  HomeViewController.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import UIKit
import Alamofire

class HomeViewController: SectionListViewController {

    private let header : HomeHeaderView = .init()
    private lazy var subscribedSection : HomeSubscribedSection = .init(cv: cv)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(header.view)
        header.view.pin.left().top().right()
        header.render(rm: .default())

        view.addSubview(cv)
        cv.pin.left().below(of: header.view).right().bottom()
        cv.contentInset.bottom = view.safeAreaInsets.bottom

        sections = [
            HomeNetworkSection(cv: cv, title: "무료 과목", filterIsRecommended: false, filterIsFree: true),
            HomeNetworkSection(cv: cv, title: "추천 과목", filterIsRecommended: true, filterIsFree: false),
            subscribedSection
        ]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.view.pin.left().top().right()
        header.setupTopSafeAreaHeight(view.safeAreaInsets.top)
        cv.pin.left().below(of: header.view).right().bottom()
        cv.contentInset.bottom = view.safeAreaInsets.bottom
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribedSection.setIds(SubscribeManager.shared.lists())
    }
}
