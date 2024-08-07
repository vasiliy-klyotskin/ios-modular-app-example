//
//  Login+DSL.swift
//  JustChat
//
//  Created by Василий Клецкин on 8/7/24.
//

extension LoginTests.Sut {
    func initiateLoginSubmit() {
        self.submitVm.submit()
    }
    
    func changeLoginInput(_ value: String) {
        self.inputVm.input = value
    }
    
    func tapToast() {
        self.toastVm.processTap()
    }
}
