//
//  Array+Extension.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation

extension Array {
    func safe(_ index: Int) -> Element? {
        guard index >= 0 && index < self.count else { return nil }
        return self[index]
    }
}
