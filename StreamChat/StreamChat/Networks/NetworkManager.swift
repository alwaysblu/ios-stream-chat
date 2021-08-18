//
//  NetworkManager.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/12.
//

import UIKit

final class NetworkManager: NSObject {
    private var inputStream: InputStreamProtocol?
    private var outputStream: OutputStreamProtocol?
    private var streamTask: URLSessionStreamTaskProtocol?
    weak var delegate: NetworkManagerDelegate?
    
    init(streamTask: URLSessionStreamTaskProtocol) {
        self.streamTask = streamTask
    }
    
    override init() {
        super.init()
    }
    
    // MARK: Setting function
    
    func setStreamTask(_ streamTask: URLSessionStreamTaskProtocol) {
        self.streamTask = streamTask
    }
    
    func setUrlSessionStreamDelegate(inputStream: InputStreamProtocol, outputStream: OutputStreamProtocol) {
        self.outputStream = outputStream
        self.inputStream = inputStream
        
        self.outputStream?.delegate = self
        self.inputStream?.delegate = self
        
        self.inputStream?.schedule(in: .main, forMode: .default)
        self.outputStream?.schedule(in: .main, forMode: .default)
        
        inputStream.open()
        outputStream.open()
    }
    
    // MARK: Stream function
    
    func connectServer() {
        streamTask?.resume()
        streamTask?.captureStreams()
    }
    
    func send(message: String) {
        guard let data = message.data(using: .utf8) else { return }
        outputStream?.write(data: data)
    }
    
    func closeStreamTask() {
        streamTask?.closeRead()
        streamTask?.closeWrite()
    }
    
    func reactToStreamEvent(_ aStream: Stream,
                            handle eventCode: Stream.Event,
                            inputStream: InputStreamProtocol?,
                            delegate: NetworkManagerDelegate?) {
        if (aStream as? InputStream) != nil {
            switch eventCode {
            case .hasBytesAvailable:
                var data = Data()
                guard let inputStream = inputStream,
                      inputStream.read(data: &data) > 0,
                      let message = String(data: data, encoding: .utf8)
                else { return }
                delegate?.networkManagerWillDeliverReceivedMessage(message)
            default: break
            }
        }
    }
}

extension NetworkManager: URLSessionStreamDelegate {
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        setUrlSessionStreamDelegate(inputStream: inputStream, outputStream: outputStream)
    }
}

extension NetworkManager: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        reactToStreamEvent(aStream,
                           handle: eventCode,
                           inputStream: inputStream,
                           delegate: delegate)
    }
}

extension OutputStream {
    func write(data: Data) -> Int {
        let count = data.count
        return data.withUnsafeBytes {
            return write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: count)
        }
    }
}

extension InputStream {
    private var maxLength: Int { 4096 }
    
    func read(data: inout Data) -> Int {
        var totalReadCount: Int = 0
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
        while hasBytesAvailable {
            let numberOfBytesRead = read(buffer, maxLength: maxLength)
            if let error = streamError {
                print(error)
                break
            } else if numberOfBytesRead < 0 {
                break
            }
            data.append(buffer, count: numberOfBytesRead)
            totalReadCount += numberOfBytesRead
        }
        return totalReadCount
    }
}
