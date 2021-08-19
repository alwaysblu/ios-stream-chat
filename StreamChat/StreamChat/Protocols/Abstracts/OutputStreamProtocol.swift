//
//  OutputStreamProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

protocol OutputStreamProtocol {
    var delegate: StreamDelegate? { get set }
    
    func open()
    
    func close()
    
    @discardableResult
    func write(data: Data) -> Int
    
    func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int
    
    func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode)
    
}

extension OutputStream: OutputStreamProtocol {
}
