//
//  Article.swift
//  QiitaAPI
//
//  Created by 信田　虎太郎 on 2021/04/15.
//

import Foundation

struct Article: Codable {
    var title: String
    var body: String
    var url: String
    var created_at: String
    var updated_at: String
    var user: User
    struct User: Codable {
        var name: String
    }
}
