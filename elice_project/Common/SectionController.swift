//
//  SectionController.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit

typealias ItemMetaProtocol = ItemMetaForCellType & ItemMetaForRendering

protocol SectionController {
    var pendding: Bool { get set } /// 데이터를 다시 가져올 필요가 있는지 여부
    func setDelegate(_ delegate: SectionControllerDelegate)
    func setup()
    func numberOfItems() -> Int
    func cellForItemAt(indexPath: IndexPath, reuseIdentifiers: inout [String]) -> UICollectionViewCell
    func reusableViewFor(kind: String, indexPath: IndexPath, reuseIdentifiers: inout [String]) -> UICollectionReusableView
    func selected(indexPath: IndexPath)
    func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection?
    func willDisplayItem(at indexPath: IndexPath)
}

protocol SectionControllerDelegate : AnyObject {
    func reload()
    func pusViewController(_ viewController: UIViewController)
}

class SC: SectionController {
    private weak var cv: UICollectionView?
    private weak var delegate : SectionControllerDelegate?

    var pendding: Bool = true

    init(cv: UICollectionView) {
        self.cv = cv
    }

    func setDelegate(_ delegate: SectionControllerDelegate) {
        self.delegate = delegate
    }

    func setup() {
        headMeta = head()
        bodyMetas = body()
        pendding = false
    }

    var headMeta: (any ItemMetaProtocol)?
    lazy var bodyMetas: [any ItemMetaProtocol] = []

    func head() -> (any ItemMetaProtocol)? { return nil }
    func body() -> [any ItemMetaProtocol] { [] }

    final func numberOfItems() -> Int { bodyMetas.count }
    final func reuseIdentifier(index: Int) -> String? { bodyMetas.safe(index)?.reuseIdentifier }
    private func cellClass(index: Int) -> AnyClass? { bodyMetas.safe(index)?.cellClass() }
    private func reusableClass() -> AnyClass? { headMeta?.reusableClass() }
    private func rendering(cell: UICollectionViewCell, at: Int) -> UICollectionViewCell {
        /// item meta의 정보로 cell 내부의 WrappedView를 rendering 시킨 후 cell을 다시 return 한다
        bodyMetas.safe(at)?.rendering(cell: cell)
        return cell
    }

    private func renderingHeader(reusableView: UICollectionReusableView) -> UICollectionReusableView {
        headMeta?.rendering(reusableView: reusableView)
        return reusableView
    }

    final func reusableViewFor(kind: String, indexPath: IndexPath, reuseIdentifiers: inout [String]) -> UICollectionReusableView {
        guard let cv, let headMeta, let headerClass = headMeta.reusableClass() else { return UICollectionReusableView() }
        if kind == UICollectionView.elementKindSectionHeader {
            let headerIdentifier : String = "HEAD_\(headMeta.reuseIdentifier)"
            cv.register(headerClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: headerIdentifier)
            reuseIdentifiers.append(headerIdentifier)
            return renderingHeader(reusableView: cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath))
        } else {
            return UICollectionReusableView()
        }
    }

    final func cellForItemAt(indexPath: IndexPath, reuseIdentifiers: inout [String]) -> UICollectionViewCell {
        let index: Int = indexPath.item
        guard let cv, let identifier = reuseIdentifier(index: index) else { return UICollectionViewCell() }
        if reuseIdentifiers.contains(where: { $0 == identifier }) == false {
            guard let cellClass = cellClass(index: index) else { return UICollectionViewCell() }
            cv.register(cellClass, forCellWithReuseIdentifier: identifier)
            reuseIdentifiers.append(identifier)
        }
        return rendering(cell: cv.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath), at: index)
    }

    func selected(indexPath: IndexPath) {
        bodyMetas.safe(indexPath.item)?.selected()
    }

    func layout(sectionInset: NSDirectionalEdgeInsets, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? { nil }
    func willDisplayItem(at indexPath: IndexPath) { }
}

extension SC : SectionInteractorDelegate {
    func refresh() {
        self.pendding = true
        self.delegate?.reload()
    }
}

protocol SectionInteractorDelegate : AnyObject {
    func refresh()
}

class SectionInteractor {

    private weak var delegate : SectionInteractorDelegate?

    init(interactorDelegate: SectionInteractorDelegate? = nil) {
        self.delegate = interactorDelegate
    }

    func refresh() {
        delegate?.refresh()
    }
}
