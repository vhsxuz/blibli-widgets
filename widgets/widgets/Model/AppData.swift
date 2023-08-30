//
//  File.swift
//  widgets
//
//  Created by Andreas Alexander on 09/03/23.
//

import UIKit

struct APIResponse: Codable {
    let code: Int
    let status: String
    let data: [DataItem]
}

struct DataItem: Codable {
    let group: String
    var widgets: [Widget]
}

struct Widget: Codable {
    var title: [String: String]
    let image: String
    let group: String
    let url: String
    var hide: Bool
}


