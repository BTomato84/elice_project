//
//  CourseDetail.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation

struct CourseDetail : Decodable {
    let id : Int
    let image_file_url : String?
    let logo_file_url : String?
    let title : String
    let short_description : String
    let description : String?
}

struct CourseDetailResult : Decodable {
    let course : CourseDetail
}

struct Lecture : Decodable {
    let id : Int
    let title : String
    let description : String
}

struct LectureResult : Decodable {
    let lectures : [Lecture]
    let lecture_count : Int
}
