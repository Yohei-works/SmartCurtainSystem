//
//  ControlView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI

struct ControlView: View {
    
    @EnvironmentObject var systemState :SystemState
    
    var body: some View {
        Color("background")

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
                                self.systemState.userReq = .OPEN
                                
                            }) {
                                Image("OPEN_inactive")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()

                            }
                            
                            Spacer().frame(width: geometry.size.width * 0.085)
                            
                            Button(action: {
                                self.systemState.userReq = .CLOSE
                                
                            }) {
                                Image("CLOSE_inactive")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }.frame(height: geometry.size.height * 0.1)

                        Spacer().frame(height: geometry.size.height * 0.075)

                        Button(action: {
                            self.systemState.userReq = .STOP
                            
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
