//
//  FlexWrapper.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

protocol WrappedView {
    associatedtype RM
    var view: UIView { get } /// WrappedView의 가장 기본이 되는 View
    var rm: RM? { get set } /// WrappedView의 RenderingModel
    init(with contentView: UIView?) /// 생성자
    func render(rm: RM?) /// Rendering 함수
    func cacluatingSize(size: CGSize, requiredVertical: Bool) -> CGSize /// 사이즈 연산 함수
}

// WrappedView를 사용하기 위한 기본 BaseClass
class BaseWrappedView<RM>: WrappedView where RM : Equatable  {
    private var contentView: UIView! // WrappedView의 BaseView
    var rm: RM?

    public required init(with contentView: UIView? = nil) {
        if let contentView {
            self.contentView = contentView
        } else {
            loadView()
        }
        initialized()
    }
    func loadView() { contentView = UIView() }

    var view: UIView { contentView }
    private var rootFlex : Flex { view.flex }

    func initialized() { }

    func render(rm: RM?) { }

    /// Cell 사이즈 연산용 함수.
    final func cacluatingSize(size: CGSize, requiredVertical: Bool) -> CGSize {
        view.pin.width(size.width)
        if requiredVertical {
            view.pin.height(size.height)
        }
        rootFlex.layout(mode: .adjustHeight)
        return CGSize(width: size.width, height: view.bounds.height)
    }
}
