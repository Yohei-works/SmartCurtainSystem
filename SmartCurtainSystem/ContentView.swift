//
//  ContentView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State private var selection = 0
    @EnvironmentObject var systemState :SystemState
    
    var bleObj = BleHandler()

    init(){
        UITabBar.appearance().barTintColor = UIColor(named: "tab")
    }
            
    var body: some View {
                
//        let bleObj = BleHandler(environmentObj: systemState)
        bleObj.setSystemState(systemState: systemState)

        //        VStack{
        return GeometryReader {
                geometry in VStack(spacing: 1) {
                    Color.black
                        .frame( width: geometry.size.width, height: geometry.safeAreaInsets.top, alignment: .top )
                BleStateView()
                        .frame(height: geometry.size.height * 0.125)
                    
                    TabView(selection: self.$selection){
                                    
                        ControlView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "gear")
                                    Text("Control")
                                }
                            }
                            .tag(0)

                        AlarmView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "alarm.fill")
                                    Text("Alarm")
                                }
                            }
                            .tag(1)

//                        SearchView()
//                            .tabItem {
//                                VStack {
//                                    Image(systemName: "antenna.radiowaves.left.and.right")
//                                    Text("Search")
//                                }
//                            }
//                            .tag(2)
                    }

                    
                             } } .edgesIgnoringSafeArea(.top)

//            Text("aaa")
//                .edgesIgnoringSafeArea(.top)
            
                
            
//        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


