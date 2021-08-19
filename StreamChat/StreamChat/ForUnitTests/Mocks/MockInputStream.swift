//
//  MockInputStream.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

final class MockInputStream: InputStreamProtocol {
    static var data: Data?
    
    weak var delegate: StreamDelegate?
    
    func open() {
        UnitTestVariables.appendFunctionNameIntoServerConnectionTestList(UnitTestConstants.inputStreamOpenCall)
    }
    
    func close() {
        
    }
    
    func read(data: inout Data) -> Int {
        data = MockInputStream.data!
        return data.count
    }
    
    func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        UnitTestVariables.appendFunctionNameIntoServerConnectionTestList(UnitTestConstants.inputStreamScheduleCall)
    }
    
}
