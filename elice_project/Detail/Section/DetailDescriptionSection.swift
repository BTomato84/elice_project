//
//  DetailDescriptionSection.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import MarkdownKit

class CourseDetailDescriptionSection : SC {
    private var courseDetail : CourseDetail? {
        didSet {
            refresh()
        }
    }

    func setDetail(_ detail: CourseDetail) {
        self.courseDetail = detail
    }

    override func head() -> (any ItemMetaProtocol)? {
        guard (courseDetail?.description?.isEmpty ?? true).not() else { return nil }
        return ItemMeta<DetailContentSectionHeaderView>.init(rm: .instance(text: "과목 소개"))
    }

    override func body() -> [any ItemMetaProtocol] {
        guard let rm = courseDetail?.detailDescriptionRM else { return [] }
        return [ItemMeta<DetailDescriptionView>.init(rm: rm)]
    }

    override func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        guard (courseDetail?.description?.isEmpty ?? true).not() else { return nil }
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
}

extension CourseDetail {
    var detailDescriptionRM : LabelRenderingData? {
        guard let description, description.isEmpty.not() else { return nil }
        let markdownParser = MarkdownParser()
        let attributedString : NSAttributedString = markdownParser.parse(description)
        return LabelRenderingData(font: .systemFont(ofSize: UIFont.systemFontSize), text: "", attributedString: attributedString, color: .black, numberOfLines: 0)
    }
}
