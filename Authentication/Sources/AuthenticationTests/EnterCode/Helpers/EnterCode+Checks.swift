//
//  EnterCode+TestData.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

import Testing
import Foundation
import Networking
@testable import Authentication

extension EnterCodeTests {
    func expectResendRequestIsCorrect(_ request: RemoteRequest, for token: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == EnterCodeResendRequest.path, comment, sourceLocation: sourceLocation)
        #expect(request.method == EnterCodeResendRequest.method, comment, sourceLocation: sourceLocation)
        #expect(request.dto() == EnterCodeResendRequestDTO(confirmationToken: token), comment, sourceLocation: sourceLocation)
    }
    
    func expectSubmitRequestIsCorrect(_ request: RemoteRequest, code: String, token: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == EnterCodeSubmitRequest.path, comment, sourceLocation: sourceLocation)
        #expect(request.method == EnterCodeSubmitRequest.method, comment, sourceLocation: sourceLocation)
        #expect(request.dto() == EnterCodeSubmitRequestDTO(code: code, confirmationToken: token), comment, sourceLocation: sourceLocation)
    }
}
