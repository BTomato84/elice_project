//
//  CourseModel.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation

struct Course : Codable {
    var id : Int
    var logo_file_url : String?
    var image_file_url : String?
    var title : String
    var short_description : String
    var taglist : [String]
}

struct CourseList : Decodable {
    var course_count : Int
    var courses : [Course]
}
