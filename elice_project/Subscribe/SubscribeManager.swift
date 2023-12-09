//
//  SubscribeManager.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation

class SubscribeManager {
    private let SUBSCRIBE_USERDEFAULTS_KEY = "SUBSCRIBE_USERDEFAULTS_KEY"
    private var subscribeIds : [Int] = []

    static let shared : SubscribeManager = SubscribeManager()

    private init() {
        loadFromUserDefaults()
    }

    private func loadFromUserDefaults() {
        let data: Data? = {
            if let json = UserDefaults.standard.string(forKey: SUBSCRIBE_USERDEFAULTS_KEY) {
                return json.data(using: .utf8)
            }
            return nil
        }()
        guard let jsonData = data else { return }
        subscribeIds = (try? JSONDecoder().decode([Int].self, from: jsonData)) ?? []
    }

    private func saveToUserDefauls() {
        guard let dataValue = try? JSONEncoder().encode(subscribeIds), let json = String(data: dataValue, encoding: .utf8) else { return }
        UserDefaults.standard.set(json, forKey: SUBSCRIBE_USERDEFAULTS_KEY)
    }

    func isSubscribe(id: Int) -> Bool {
        subscribeIds.contains(id)
    }

    func subscribe(id: Int) {
        guard isSubscribe(id: id).not() else { return }
        subscribeIds.append(id)
        saveToUserDefauls()
    }

    func unsubscribe(id: Int) {
        guard isSubscribe(id: id), let index = subscribeIds.firstIndex(of: id) else { return }
        subscribeIds.remove(at: index)
        saveToUserDefauls()
    }

    func lists() -> [Int] {
        subscribeIds.reversed()
    }
}
