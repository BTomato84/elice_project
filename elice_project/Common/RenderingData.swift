//
//  RenderingData.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import FlexLayout
import Kingfisher

struct ViewRenderingData : Equatable {
    var backgroundColor : UIColor
    var borderWidth : CGFloat
    var borderColor : UIColor
    var cornerRadius : CGFloat
    var contentMode : UIView.ContentMode
    var isHidden : Bool

    static var `default` : ViewRenderingData {
        ViewRenderingData(backgroundColor:.clear, borderWidth: 0.0, borderColor: .clear, cornerRadius: 0.0, contentMode: .topLeft, isHidden: false)
    }

    var flexDisplay : Flex.Display {
        return isHidden ? .none : .flex
    }
}

extension UIView {
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    func render(_ data: ViewRenderingData) {
        backgroundColor = data.backgroundColor
        setBorder(width: data.borderWidth, color: data.borderColor)
        setCornerRadius(data.cornerRadius)
        isHidden = data.isHidden
        contentMode = data.contentMode
    }
}

struct LabelRenderingData : Equatable {
    var font : UIFont
    var text : String
    var color : UIColor
    var textAlign : NSTextAlignment
    var view : ViewRenderingData

    init(font: UIFont, text: String, color: UIColor, textAlign: NSTextAlignment = .left, view: ViewRenderingData = .default) {
        self.font = font
        self.text = text
        self.color = color
        self.textAlign = textAlign
        self.view = view
    }
}

extension UILabel {
    func render(_ data: LabelRenderingData) {
        self.font = data.font
        self.text = data.text
        self.textColor = data.color
        self.textAlignment = data.textAlign
        self.render(data.view)
    }
}

struct ImageRenderingData : Equatable {
    var imageName : String?
    var imageURL : String?
    var view : ViewRenderingData

    init(imageName: String? = nil, imageURL: String? = nil, view: ViewRenderingData = .default) {
        self.imageName = imageName
        self.view = view
    }
}

extension UIImageView {
    func render(_ data: ImageRenderingData) {
        self.image = nil
        if let imageName = data.imageName {
            self.image = UIImage(named: imageName)
        }
        if let imageURL = data.imageURL, let url = URL(string: imageURL) {
            self.kf.setImage(with: url)
        }
        self.render(data.view)
    }
}

struct ButtonRenderingData : Equatable {
    var buttonImageName : String?
    var buttonTitle : String?
    var view : ViewRenderingData

    init(buttonImageName: String, buttonTitle: String?, view: ViewRenderingData = .default) {
        self.buttonImageName = buttonImageName
        self.buttonTitle = buttonTitle
        self.view = view
    }
}

extension UIButton {
    func render(_ data: ButtonRenderingData) {
        let image : UIImage? = {
            guard let imageName = data.buttonImageName else { return nil }
            return UIImage(named: imageName)
        }()
        self.setImage(image, for: .normal)
        self.setTitle(data.buttonTitle, for: .normal)
        self.render(data.view)
    }
}
