//
//  WorkspaceListCellModel.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/21.
//

import Foundation

struct WorkspaceListCellModel: Codable {
    let code: String
    let workspaces: Workspaces?
}

struct Workspaces: Codable {
    let content: Content
    let pageable: Pageable
    let last: Bool
    let totalPages: Int
    let size: Int
    let number: Int
    let sort: Sort
    let first: Bool
    let numberOfElements: Int
    let empty: Bool
}

struct Content: Codable {
    let id: Int
    let name: String
    var description: String? = ""
    let settings: Int
    let status: Int
    let createdt: String
    let modifydt: String
}

struct Pageable: Codable {
    let sort: Sort
    let offset: Int
    let pageSize: Int
    let pageNumber: Int
    let unpaged: Bool
    let paged: Bool
}

struct Sort: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}
