//
//  RegisterFeature+TestData.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/21/24.
//

import Foundation
import Testing
@testable import JustChat

extension RegisterTests {
    func expectRequestIsCorrect(_ request: RemoteRequest, for email: String, username: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == "register", comment, sourceLocation: sourceLocation)
        #expect(request.method == "POST", comment, sourceLocation: sourceLocation)
        #expect(request.dto() == RegisterRequestDTO(email: email, username: username), comment, sourceLocation: sourceLocation)
    }
}
