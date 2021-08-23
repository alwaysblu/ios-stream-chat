//
//  Builder.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/23.
//

import Foundation

struct Builder {
    func create() -> UserNameInputViewController {
        let netWorkManager = NetworkManager()
        let session = URLSession(configuration: .default,
                                 delegate: netWorkManager,
                                 delegateQueue: .main)
        let streamTask = session.streamTask(withHostName: NetworkAddress.ipAddress,
                                                port: NetworkAddress.port)
        netWorkManager.setStreamTask(streamTask)
        let chatViewModel = ChatViewModel(networkManager: netWorkManager)
        let chatViewController = ChatViewController(chatViewModel: chatViewModel)
        return UserNameInputViewController(chatViewController: chatViewController)
    }
}
