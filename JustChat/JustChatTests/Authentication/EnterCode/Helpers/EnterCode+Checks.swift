//
//  EnterCode+TestData.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/27/24.
//

@testable import JustChat
import Testing
import Foundation

extension EnterCodeTests {
    func expectResendRequestIsCorrect(_ request: RemoteRequest, for token: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == "resend-otp", comment, sourceLocation: sourceLocation)
        #expect(request.method == "POST", comment, sourceLocation: sourceLocation)
        #expect(request.dto() == EnterCodeResendRequestDTO(confirmationToken: token), comment, sourceLocation: sourceLocation)
    }
    
    func expectSubmitRequestIsCorrect(_ request: RemoteRequest, code: String, token: String, _ comment: Comment?, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(request.path == "submit-otp", comment, sourceLocation: sourceLocation)
        #expect(request.method == "POST", comment, sourceLocation: sourceLocation)
        #expect(request.dto() == EnterCodeSubmitRequestDTO(code: code, confirmationToken: token), comment, sourceLocation: sourceLocation)
    }
}
