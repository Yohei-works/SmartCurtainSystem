//
//  ContentView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    init(){
        UITabBar.appearance().barTintColor = UIColor(named: "tab")
    }
    
    @State private var selection = 0
    
    
    var x = UIScreen.main.bounds.height

    var body: some View {
                
        
//        VStack{
            GeometryReader {
                geometry in VStack(spacing: 1) {
                    Color.black
                        .frame( width: geometry.size.width, height: geometry.safeAreaInsets.top, alignment: .top )
                    
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

                        SearchView()
                            .tabItem {
                                VStack {
                                    Image(systemName: "antenna.radiowaves.left.and.right")
                                    Text("Search")
                                }
                            }
                            .tag(2)
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
