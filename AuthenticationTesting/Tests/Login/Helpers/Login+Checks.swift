//
//  Login+Data.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/11/24.
//

import Foundation
import Testing
import Networking
@testable import Authentication

extension LoginTests {
    func expectRequestIsCorrect(_ request: RemoteRequest, for login: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == LoginRequest.path, comment, sourceLocation: sourceLocation)
        #expect(request.method == LoginRequest.method, comment, sourceLocation: sourceLocation)
        #expect(request.dto() == LoginRequestDTO(login: login), comment, sourceLocation: sourceLocation)
    }
}
