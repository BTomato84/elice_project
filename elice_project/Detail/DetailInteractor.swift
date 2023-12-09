//
//  DetailInteractor.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation
import Alamofire

protocol DetailInteractorDelegate : AnyObject {
    func renderBy(data: CourseDetail)
    func renderBottom(isSubscribe: Bool)
}

class DetailInteractor {
    private(set) var id : Int
    private var response : CourseDetailResult?
    private var state : NetworkState?
    private weak var delegate : DetailInteractorDelegate?
    private var isSubscribe : Bool

    init(id: Int) {
        self.id = id
        self.isSubscribe = SubscribeManager.shared.isSubscribe(id: id)
    }

    func setDelegate(_ delegate: DetailInteractorDelegate) {
        self.delegate = delegate
        sendDataToDelegate()
        sendBottomRender()
    }

    func fetch() {
        guard (state?.isBusy ?? false).not() else { return }
        let state : NetworkState = .createBusyState()
        self.state = state
        let urlString : String = "https://api-rest.elice.io/org/academy/course/get/?course_id=\(id)"
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedURLString) else { return }
        AF.request(url).responseDecodable(of: CourseDetailResult.self) { [weak self] (res) in
            guard let self, (self.state?.isEqualSession(with: state) ?? false) else { return }
            switch res.result {
            case let .success(data):
                self.response = data
                self.state = state.done()
                self.sendDataToDelegate()
            case let .failure(error):
                self.state = state.fail(with: error)
            }
        }
    }

    private func sendDataToDelegate() {
        guard let courseDetail = response?.course else { return }
        delegate?.renderBy(data: courseDetail)
    }

    private func sendBottomRender() {
        delegate?.renderBottom(isSubscribe: isSubscribe)
    }

    func toggleSubscribe() {
        if isSubscribe {
            SubscribeManager.shared.unsubscribe(id: id)
        } else {
            SubscribeManager.shared.subscribe(id: id)
        }
        isSubscribe = isSubscribe.not()
        sendBottomRender()
    }
}
