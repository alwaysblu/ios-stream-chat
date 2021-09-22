//
//  StreamDataFormat.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import Foundation

enum StreamData {
    static let leaveMessage = "LEAVE::::END"
    static let sharedDateFormatter = DateFormatter()
    // MARK: Convert Function
    
    static func convertMessageToJoinFormat(userName: String) -> String {
        return "USR_NAME::\(userName)::END"
    }
    
    static func convertMessageToSendFormat(_ message: String) -> String {
        return "MSG::\(message)::END"
    }
    
    static func convertDateToString(date: Date) -> String {
        sharedDateFormatter.locale = Locale(identifier: "ko_kr")
        sharedDateFormatter.dateFormat = "M월 d일 a h시 m분"
        sharedDateFormatter.amSymbol = "오전"
        sharedDateFormatter.pmSymbol = "오후"
        sharedDateFormatter.timeZone = TimeZone.current

        return sharedDateFormatter.string(from: date)
    }
    
    // MARK: Find Function
    
    static func findOutSenderNameOfMessage(message: String) -> String {
        let splitedMessage = splitMessage(message)
        if splitedMessage.count == 2 {
            return splitedMessage[0]
        }
        return "chatManager"
    }
    
    static func findOutMessageContent(message: String) -> String {
        let splitedMessage = splitMessage(message)
        if splitedMessage.count == 2 {
            return splitedMessage[1]
        }
        return message
    }
    
    static func findOutIdentifierOfMessage(message: String, ownUserName: String) -> SenderIdentifier {
        let splitedMessage = splitMessage(message)
        if splitedMessage.count == 2, ownUserName != splitedMessage[0] {
            return SenderIdentifier.otherUser
        } else if splitedMessage.count == 2, ownUserName == splitedMessage[0] {
            return SenderIdentifier.userSelf
        }
        return SenderIdentifier.chatManager
    }
}

extension StreamData {
    private static func splitMessage(_ message: String) -> [String] {
        return message.split(separator: ":").map { String($0) }
    }
}
