//
//  HomeSubscribeSectionController.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import Alamofire

class HomeSubscribedInteractor : SectionInteractor {
    private var baseUrlString : String = "https://api-rest.elice.io/org/academy/course/list/"
    private var subscribeItemIds : [Int] = []
    private var response : [CourseList] = []

    private let PAGE_LOAD_COUNT : Int = 10

    var flatCourses : [Course] { response.flatMap { $0.courses } }
    var maxCount : Int { response.last?.course_count ?? Int.max }
    private var state : NetworkState? = nil

    init(delegate: SectionInteractorDelegate, baseUrlString: String) {
        super.init(interactorDelegate: delegate)
        self.baseUrlString = baseUrlString
    }

    func setIds(_ ids: [Int]) {
        self.subscribeItemIds = ids
        response.removeAll()
        fetch()
    }

    func fetch() {
        let offset : Int = flatCourses.count
        guard (state?.isBusy ?? false).not(), offset < maxCount else { return }
        let state : NetworkState = .createBusyState()
        self.state = state
        let urlString : String = "\(baseUrlString)?filter_conditions={\"course_ids\":[\(subscribeItemIds.map { "\($0)" }.joined(separator: ","))]}&offset=\(offset)&count=\(PAGE_LOAD_COUNT)"
        guard let encodedURLString : String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedURLString) else { return }
        AF.request(url).responseDecodable(of: CourseList.self) { [weak self] res in
            guard let self, (self.state?.isEqualSession(with: state) ?? false) else { return }
            switch res.result {
            case let .success(data):
                response.append(data)
                self.state = state.done()
                self.refresh()
            case let .failure(error):
                self.state = state.fail(with: error)
            }
        }
    }
}

class HomeSubscribedSection : SC {
    private var interactor : HomeSubscribedInteractor!
    override init(cv: UICollectionView) {
        super.init(cv: cv)
        interactor = HomeSubscribedInteractor(
            delegate: self,
            baseUrlString: "https://api-rest.elice.io/org/academy/course/list/"
        )
    }

    func setIds(_ ids: [Int]) {
        interactor.setIds(ids)
    }

    override func head() -> (any ItemMetaProtocol)? {
        return ItemMeta<CourseSectionHeaderView>(rm: .instance(text: "내 학습"))
    }

    override func body() -> [any ItemMetaProtocol] {
        return interactor.flatCourses.map { [weak self] (item) in
            return ItemMeta<CourseView>.init(rm: item.rm) {
                let viewController = DetailViewController.instanceViewController(with: item.id)
                self?.pushViewController(viewController)
            }
        }
    }

    override func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        guard interactor.flatCourses.isEmpty.not() else { return nil }
        let itemWidth: NSCollectionLayoutDimension = .absolute(200)
        let itemHeight: NSCollectionLayoutDimension = .absolute(220)
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension:  itemWidth,
                heightDimension: itemHeight
            )
        )
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(widthDimension: .absolute(200), heightDimension: .absolute(220)),
            repeatingSubitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 16.0, leading: 16.0, bottom: 16.0, trailing: 16.0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40.0)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        return section
    }

    override func willDisplayItem(at indexPath: IndexPath) {
        if indexPath.item == bodyMetas.count - 1 {
            interactor.fetch()
        }
    }
}
