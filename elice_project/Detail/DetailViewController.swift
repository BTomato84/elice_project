//
//  DetailViewController.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

class DetailViewController : SectionListViewController {
    static func instanceViewController(with id: Int) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.interactor = DetailInteractor(id: id)
        return viewController
    }

    private let header : DetailHeaderView = .init()
    private var interactor : DetailInteractor!
    private lazy var topSection : DetailTopSection = DetailTopSection(cv: cv)
    private lazy var descriptionSection : CourseDetailDescriptionSection = CourseDetailDescriptionSection(cv: cv)
    private lazy var lectureSection : DetailLectureSection = DetailLectureSection(cv: cv, id: interactor.id)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.setDelegate(self)

        sections = [
            topSection,
            descriptionSection,
            lectureSection
        ]

        view.addSubview(header.view)
        header.view.pin.left().top().right()
        header.render(rm: .default())
        header.backSelected = { [weak self] in self?.navigationController?.popViewController(animated: true) }

        view.addSubview(cv)
        cv.pin.left().below(of: header.view).right().bottom()
        cv.contentInset.bottom = view.safeAreaInsets.bottom

        interactor.fetch()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.view.pin.left().top().right()
        header.setupTopSafeAreaHeight(view.safeAreaInsets.top)
        cv.pin.left().below(of: header.view).right().bottom()
        cv.contentInset.bottom = view.safeAreaInsets.bottom
    }
}

extension DetailViewController : DetailInteractorDelegate {
    func renderBy(data: CourseDetail) {
        topSection.setDetail(data)
        descriptionSection.setDetail(data)
    }
}
