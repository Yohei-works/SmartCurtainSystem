//
//  AlarmView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI

struct AlarmView: View {
    
    @State var isPresented: Bool = false
    @State private var selectionDate = Date()

    var body: some View {
        Color("background")
            .overlay(
                VStack {
                    Button("present") {
                        self.isPresented.toggle()
                    }
                }
                .sheet(isPresented: $isPresented) {
                    DatePicker("時刻", selection: self.$selectionDate, displayedComponents: .hourAndMinute)

                }
        )
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
