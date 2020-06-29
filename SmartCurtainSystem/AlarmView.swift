//
//  AlarmView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI

struct AlarmView: View {
    @EnvironmentObject var systemState :SystemState
    @State var isPresented: Bool = false
    @State private var selectionDate = Date()

    var body: some View {
        GeometryReader{ geometry in
 
            Path { path in
               path.addLines([
                  CGPoint(x: 0, y: 0),
                  CGPoint(x: geometry.size.width, y: 0),
                  CGPoint(x: 0, y: geometry.size.height),
                  CGPoint(x: 0, y: 0)
               ])
            }.fill(Color("night"))

            Path { path in
               path.addLines([
                  CGPoint(x: geometry.size.width, y: 0),
                  CGPoint(x: 0, y: geometry.size.height),
                  CGPoint(x: geometry.size.width, y: geometry.size.height),
                  CGPoint(x: geometry.size.width, y: 0)
               ])
            }.fill(Color("morning"))
            
            VStack{
                HStack{
                    Image("moon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width/4, height: geometry.size.height/5, alignment: .topLeading)
                    
                    Spacer()
                }
                
                HStack{
                    Button("\(self.systemState.alarmClose.getTimeLabel())") {
                        self.isPresented.toggle()
                    }
                    .sheet(isPresented: self.$isPresented) {
                        DatePicker("時刻", selection: self.$selectionDate, displayedComponents: .hourAndMinute)
                    }
                    .frame(width: geometry.size.width/2, height: geometry.size.height/6, alignment: .topLeading)
                    .offset(x:geometry.size.width/10,y:0)
                    .background(Color.yellow)
                    Spacer()
                }
                
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button("\(self.systemState.alarmClose.getTimeLabel())") {
                        self.isPresented.toggle()
                    }
                    .sheet(isPresented: self.$isPresented) {
                        DatePicker("時刻", selection: self.$selectionDate, displayedComponents: .hourAndMinute)
                    }
                    .frame(width: geometry.size.width/2, height: geometry.size.height/6, alignment: .bottomTrailing)
                    .offset(x:-geometry.size.width/10,y:0)
                    .background(Color.yellow)
                }
                
                HStack{
                    Spacer()
                    Image("sun")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width/4, height: geometry.size.height/5, alignment: .bottomTrailing)
                }
            }
//            Color("background")
//                .overlay(
//                    VStack {
//                        Button("present") {
//                            self.isPresented.toggle()
//                        }
//                    }
//                    .sheet(isPresented: self.$isPresented) {
//                        DatePicker("時刻", selection: self.$selectionDate, displayedComponents: .hourAndMinute)
//
//                    }
//            )
        }
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
