//
//  Login+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

@testable import JustChat

extension LoginFeatureTests.Sut {
    func initiateLoginSubmit() {
        self.submitVm.submit()
    }
    
    func changeLoginInput(_ value: String) {
        self.inputVm.input = value
    }
}
