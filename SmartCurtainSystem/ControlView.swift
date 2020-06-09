//
//  ControlView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI

struct ControlView: View {
    var body: some View {
        Color("background")
//        Image("wood_wall")
//            .resizable()
            .overlay(
                GeometryReader{ geometry in
                    
                    VStack(spacing:0){
                        
                        Spacer().frame(height: geometry.size.height * 0.11)
                        
                        ZStack{
                            Image("blue_sky")
                                .resizable()
                                .scaledToFit()

                            Image("curtain05")
                                .resizable()
                                .scaledToFit()

                        }
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.4)
                        
                        Spacer().frame(height: geometry.size.height * 0.12)

                        
                        HStack{
                            Button(action: {
                                print("button pressed")
                                
                            }) {
                                Image("OPEN_inactive")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()

                            }
                            
                            Spacer().frame(width: geometry.size.width * 0.085)
                            
                            Button(action: {
                                print("button pressed")
                                
                            }) {
                                Image("CLOSE_inactive")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }.frame(height: geometry.size.height * 0.1)

                        Spacer().frame(height: geometry.size.height * 0.075)

                        Button(action: {
                            print("button pressed")
                            
                        }) {
                            Image("STOP_inactive")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                        }
                            .frame(height: geometry.size.height * 0.1)
                       
                        Spacer().frame(height: geometry.size.height * 0.145)

                    }
                }
            )
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
    }
}
