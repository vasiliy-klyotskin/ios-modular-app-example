//
//  DemoUtilsEditRequestView.swift
//  JustChat
//
//  Created by Василий Клецкин on 9/21/24.
//

import SwiftUI

struct DemoUtilsEditRequestView: View {
    @ObservedObject var vm: DemoUtilsEditRequestViewModel
    
    var body: some View {
        Form {
            responsesSection()
            delaySection()
        }
    }
    
    private func responsesSection() -> some View {
        Section(header: Text(vm.responseItemsTitle)) {
            Picker(vm.responseItemsSelectionText, selection: $vm.selectedItem) {
                ForEach(vm.responseItems) { item in
                    Text(item.name).tag(item)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
    
    private func delaySection() -> some View {
        Section(header: Text(vm.changeDelayTitle)) {
            Stepper(value: $vm.delayValue, in: vm.delayRangle, step: vm.delayStep) {
                Text(vm.changeDelaySelectionText)
            }
        }
    }
}
