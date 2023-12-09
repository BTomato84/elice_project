//
//  CourseDetailHeader.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import UIKit
import FlexLayout

struct CourseDetailHeaderRM : Equatable {
    var logo : ImageRenderingData
    var title : LabelRenderingData
    var description : LabelRenderingData

    static func small(logoURL: String?, title: String) -> CourseDetailHeaderRM {
        let logo : ImageRenderingData = {
            guard let logoURL else { return .init(imageName: "BookLogo", view: .init(backgroundColor: .init(hexString: "#F3F3F3"), cornerRadius: 8.0, contentMode: .scaleAspectFit)) }
            return .init(imageURL: logoURL, view: .init(backgroundColor: .init(hexString: "#F3F3F3"), cornerRadius: 8.0, contentMode: .scaleAspectFit))
        }()
        let title : LabelRenderingData = .init(font: .systemFont(ofSize: 17.0, weight: .bold), text: title, color: .black)
        let description : LabelRenderingData = .init(font: .systemFont(ofSize: 0.0), text: "", color: .clear, view: .init(isHidden: true))
        return CourseDetailHeaderRM(logo: logo, title: title, description: description)
    }

    static func large(logoURL: String?, title: String, description: String) -> CourseDetailHeaderRM {
        let logo : ImageRenderingData = {
            guard let logoURL else { return .init(imageName: "BookLogo", view: .init(backgroundColor: .init(hexString: "#F3F3F3"), cornerRadius: 8.0, contentMode: .scaleAspectFit)) }
            return .init(imageURL: logoURL, view: .init(backgroundColor: .init(hexString: "#F3F3F3"), cornerRadius: 8.0, contentMode: .scaleAspectFit))
        }()
        let title : LabelRenderingData = .init(font: .systemFont(ofSize: 28.0, weight: .bold), text: title, color: .black)
        let description : LabelRenderingData = .init(font: .systemFont(ofSize: 12.0), text: description, color: .black, numberOfLines: 0)
        return CourseDetailHeaderRM(logo: logo, title: title, description: description)
    }
}

class CourseDetailSmallHeaderView : BaseWrappedView<CourseDetailHeaderRM> {
    private let logo : UIImageView = .init()
    private let title : UILabel = .init()

    override func initialized() {
        view.flex.direction(.row).padding(8.0, 16.0, 8.0, 16.0).alignContent(.center).alignItems(.center).define {
            $0.addItem(logo).width(36.0).height(36.0).marginRight(8.0)
            $0.addItem(title).grow(1)
        }
    }

    override func render(rm: CourseDetailHeaderRM?) {
        guard let rm else { return }
        logo.render(rm.logo)
        title.render(rm.title)
        title.flex.markDirty()
    }
}

class CourseDetailLargeHeaderView : BaseWrappedView<CourseDetailHeaderRM> {
    private let logo : UIImageView = .init()
    private let title : UILabel = .init()
    private let description : UILabel = .init()

    override func initialized() {
        view.flex.direction(.column).padding(8.0, 16.0, 8.0, 16.0).define {
            $0.addItem(logo).width(36.0).height(36.0).marginRight(8.0)
            $0.addItem(title).grow(1).marginBottom(8.0)
            $0.addItem(description).grow(1)
        }
    }

    override func render(rm: CourseDetailHeaderRM?) {
        guard let rm else { return }
        logo.render(rm.logo)
        title.render(rm.title)
        title.flex.markDirty()
        description.render(rm.description)
        description.flex.markDirty()
    }
}

class CourseDetailImageView : BaseWrappedView<ImageRenderingData> {
    private let image : UIImageView = .init()

    override func initialized() {
        view.flex.aspectRatio(2.0/1.0).define {
            $0.addItem(image).width(100%).aspectRatio(2.0/1.0)
        }
    }

    override func render(rm: ImageRenderingData?) {
        guard let rm else { return }
        image.render(rm)
    }
}
