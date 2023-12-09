//
//  HomeNetworkSectionController.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import Alamofire

class HomeNetworkInteractor : SectionInteractor {
    private var baseUrlString : String = "https://api-rest.elice.io/org/academy/course/list/"
    private var filterIsRecommended : Bool = false
    private var filterIsFree : Bool = false
    private var response : [CourseList] = []

    private let PAGE_LOAD_COUNT : Int = 10

    var flatCourses : [Course] { response.flatMap { $0.courses } }
    var maxCount : Int { response.last?.course_count ?? Int.max }
    private var state : NetworkState? = nil

    init(delegate: SectionInteractorDelegate, baseUrlString: String, filterIsRecommended: Bool, filterIsFree: Bool) {
        super.init(interactorDelegate: delegate)
        self.baseUrlString = baseUrlString
        self.filterIsRecommended = filterIsRecommended
        self.filterIsFree = filterIsFree
    }

    func fetch() {
        let offset : Int = flatCourses.count
        guard (state?.isBusy ?? false).not(), offset < maxCount else { return }
        let state : NetworkState = .createBusyState()
        self.state = state
        let urlString : String = "\(baseUrlString)?filter_is_recommended=\(filterIsRecommended.trueFalseString)&filter_is_free=\(filterIsFree.trueFalseString)&offset=\(offset)&count=\(PAGE_LOAD_COUNT)"
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

class HomeNetworkSection : SC {
    private var interactor : HomeNetworkInteractor!
    private let title : String
    init(cv: UICollectionView, title: String, filterIsRecommended: Bool, filterIsFree: Bool) {
        self.title = title
        super.init(cv: cv)
        interactor = HomeNetworkInteractor(
            delegate: self,
            baseUrlString: "https://api-rest.elice.io/org/academy/course/list/",
            filterIsRecommended: filterIsRecommended,
            filterIsFree: filterIsFree
        )
        interactor.fetch()
    }

    override func head() -> (any ItemMetaProtocol)? {
        return ItemMeta<CourseSectionHeaderView>(rm: .instance(text: title))
    }

    override func body() -> [any ItemMetaProtocol] {
        return interactor.flatCourses.map {
            return ItemMeta<CourseView>.init(rm: $0.rm)
        }
    }

    override func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
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

extension Course {
    var rm : CourseView.RM {
        let imageURL : String?
        let contentMode : UIView.ContentMode
        let backgroundColor : UIColor
        if let image_file_url {
            imageURL = image_file_url
            contentMode = .scaleAspectFill
            backgroundColor = .clear
        } else {
            imageURL = logo_file_url
            contentMode = .scaleAspectFit
            backgroundColor = .init(hexString: "#3A3A4C")
        }
        let image : ImageRenderingData = {
            if let imageURL {
                return .init(imageURL: imageURL, view: .init(backgroundColor: backgroundColor,cornerRadius: 10.0, contentMode: contentMode))
            } else {
                return .init(imageName: "BookLogo", view: .init(backgroundColor: backgroundColor, cornerRadius: 10.0, contentMode: contentMode))
            }
        }()
        let title : LabelRenderingData = .init(font: .systemFont(ofSize: 14.0, weight: .bold), text: title, color: .black)
        let description : LabelRenderingData = .init(font: .systemFont(ofSize: 10.0), text: short_description, color: .black)
        let tags : [CourseTagRM] = taglist.map { CourseTagRM.instance(text: $0) }
        let background : ViewRenderingData = .init(backgroundColor: .white)
        return CourseViewRM(image: image, title: title, description: description, tags: tags, background: background)
    }
}
