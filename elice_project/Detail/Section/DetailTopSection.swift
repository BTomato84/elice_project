//
//  DetailTopSection.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

class DetailTopSection : SC {
    private var courseDetail : CourseDetail? {
        didSet {
            refresh()
        }
    }

    func setDetail(_ detail: CourseDetail) {
        self.courseDetail = detail
    }

    override func body() -> [any ItemMetaProtocol] {
        guard let courseDetail else { return [] }
        return courseDetail.topMetas
    }

    override func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
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
        return section
    }
}

extension CourseDetail {
    var topMetas : [any ItemMetaProtocol] {
        if let image_file_url {
            return [
                ItemMeta<CourseDetailSmallHeaderView>.init(rm: .small(logoURL: logo_file_url, title: title)),
                ItemMeta<CourseDetailImageView>.init(rm: .init(imageURL: image_file_url, view: .init(contentMode: .scaleAspectFill)))
            ]
        } else {
            return [
                ItemMeta<CourseDetailLargeHeaderView>.init(rm: .large(logoURL: logo_file_url, title: title, description: short_description))
            ]
        }
    }
}
