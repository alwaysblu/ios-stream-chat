//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by 최정민 on 2021/08/16.
//

import XCTest

@testable import StreamChat
class StreamChatTests: XCTestCase, NetworkManagerDelegate {
    
    var networkManager: NetworkManager!
    var expectation: XCTestExpectation!
    var inputStream: InputStreamProtocol!
    var outputStream: OutputStreamProtocol!
    var streamTask: URLSessionStreamTaskProtocol!
    weak var networkMangerDelegate: NetworkManagerDelegate!
    var receivedMessage: String?
    
    override func setUp() {
        inputStream = MockInputStream()
        outputStream = MockOutputStream()
        streamTask = MockURLSessionStreamTask()
        networkManager = NetworkManager(streamTask: streamTask)
        
        MockURLSessionStreamTask.setUrlSessionStreamDelegate = networkManager.setUrlSessionStreamDelegate(inputStream:outputStream:)
        MockURLSessionStreamTask.inputStream = inputStream
        MockURLSessionStreamTask.outputStream = outputStream
        
        networkMangerDelegate = self
    }
    
    func networkManagerWillDeliverReceivedMessage(_ message: String) {
        receivedMessage = message
    }
    
    func test_connectServer_성공() throws {
        let expectedData = [UnitTestConstants.resumeCall,
                            UnitTestConstants.captureStreamsCall,
                            UnitTestConstants.inputStreamScheduleCall,
                            UnitTestConstants.outputStreamScheduleCall,
                            UnitTestConstants.inputStreamOpenCall,
                            UnitTestConstants.outputStreamOpenCall]
        networkManager.connectServer()
        guard inputStream.delegate != nil, outputStream.delegate != nil else {
            XCTFail("delegate == nil")
            return
        }
        XCTAssertEqual(expectedData, UnitTestVariables.getServerConnectionTestList())
        UnitTestVariables.resetServerConnectionTestList()
    }
    
    func test_inputStream_데이터_읽기_성공() throws {
        let mockInputStream = InputStream(data: Data())
        let expectedMessage = "test!!!"
        MockInputStream.data = Data(expectedMessage.utf8)
        networkManager.reactToStreamEvent(mockInputStream, handle: .hasBytesAvailable, inputStream: inputStream, delegate: networkMangerDelegate)
        XCTAssertEqual(expectedMessage, receivedMessage)
    }
    
    func test_outputStream_데이터_쓰기_성공() throws {
        let expectedMessage = "test!!!"
        networkManager.send(message: expectedMessage)
        
    }
}
