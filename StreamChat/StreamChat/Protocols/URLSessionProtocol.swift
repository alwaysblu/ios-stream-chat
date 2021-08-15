//
//  URLSessionProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/16.
//

import Foundation

protocol URLSessionProtocol {
    func streamTask(withHostName hostname: String, port: Int) -> URLSessionStreamTask
}
