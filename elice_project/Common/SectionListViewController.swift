//
//  SectionListViewController.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

class SectionListViewController : UIViewController {
    lazy var cv: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewLayout.init())
    private var reuseIdentifiers: [String] = []
    var sections: [SectionController] = []
    var baesSectionInset: NSDirectionalEdgeInsets = .zero

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = .init(
        sectionProvider: { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard
                let self,
                let sc = self.sections.safe(sectionIndex),
                var layoutSection = sc.layout(sectionInset: self.baesSectionInset, environment: environment)
            else { return nil }
            
            return layoutSection
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func reload() {
        for section in sections where section.pendding {
            section.setup()
        }
        cv.reloadData()
    }
}

extension SectionListViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { sections.count }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections.safe(section)?.numberOfItems() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections.safe(indexPath.section)?.cellForItemAt(indexPath: indexPath, reuseIdentifiers: &reuseIdentifiers) ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        sections.safe(indexPath.section)?.reusableViewFor(kind: kind, indexPath: indexPath, reuseIdentifiers: &reuseIdentifiers) ?? UICollectionReusableView()
    }
}
