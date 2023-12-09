//
//  DetailLectureSection.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import Alamofire

class DetailLectureInteractor : SectionInteractor {
    private var baseUrlString : String = "https://api-rest.elice.io/org/academy/lecture/list/"
    private var response : [LectureResult] = []
    private var id : Int

    private let PAGE_LOAD_COUNT : Int = 40

    var flatLectures : [Lecture] { response.flatMap { $0.lectures } }
    var maxCount : Int { response.last?.lecture_count ?? Int.max }
    var isEmpty : Bool { flatLectures.isEmpty }
    private var state : NetworkState? = nil

    init(delegate: SectionInteractorDelegate, id: Int) {
        self.id = id
        super.init(interactorDelegate: delegate)
    }

    func fetch() {
        let offset : Int = flatLectures.count
        guard (state?.isBusy ?? false).not(), offset < maxCount else { return }
        let state : NetworkState = .createBusyState()
        self.state = state
        let urlString : String = "\(baseUrlString)?course_id=\(id)&offset=\(offset)&count=\(PAGE_LOAD_COUNT)"
        guard let encodedURLString : String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedURLString) else { return }
        AF.request(url).responseDecodable(of: LectureResult.self) { [weak self] res in
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

class DetailLectureSection : SC {
    private var interactor : DetailLectureInteractor!
    init(cv: UICollectionView, id: Int) {
        super.init(cv: cv)
        interactor = DetailLectureInteractor(delegate: self, id: id)
        interactor.fetch()
    }

    override func head() -> (any ItemMetaProtocol)? {
        guard interactor.isEmpty.not() else { return nil }
        return ItemMeta<DetailContentSectionHeaderView>.init(rm: .instance(text: "과목 소개"))
    }

    override func body() -> [any ItemMetaProtocol] {
        let flatLectures = interactor.flatLectures
        return flatLectures.enumerated().map { (offset, item) in
            return ItemMeta<DetailLectureView>.init(rm: item.rm(isFirst: offset == 0, isLast: offset == (flatLectures.count - 1)))
        }
    }

    override func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        guard interactor.isEmpty.not() else { return nil }
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension:  .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
        )
        let group: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100.0)),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8.0, leading: 16.0, bottom: 0.0, trailing: 16.0)
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

extension Lecture {
    func rm(isFirst: Bool, isLast: Bool) -> DetailLectureRM {
        return .instance(title: title, description: description, isFirst: isFirst, isLast: isLast)
    }
}
