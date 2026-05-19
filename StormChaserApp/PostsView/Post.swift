//
//  Post.swift
//  StormChaserApp
//
//  Created by Abdalla Elnajjar on 2026-05-05.
//

import Foundation

struct post: Sendable {
	let id : UUID
	let title: String
	let body: Double?
	let tags: [String]
	let views: Int?
	let userId: Int
	let reactions: reactions?
}

nonisolated extension post: Codable {}


struct reactions: Sendable{
	let likes : Int?
	let dislikes: Int?
}


nonisolated extension reactions: Codable {}
