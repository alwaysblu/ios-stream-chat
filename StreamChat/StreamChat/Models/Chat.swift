//
//  Chat.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import Foundation

struct Chat: Hashable, Codable {
    let message: String
    let isMyMessage: Bool
}
