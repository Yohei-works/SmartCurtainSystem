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

                            startCurtainAnimation(width: geometry.size.width * 0.9, height:  geometry.size.height * 0.4, curtainImages: openImages)
//                            Image("curtain05")
//                                .resizable()
//                                .scaledToFit()

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

let openImages : [UIImage]! = [UIImage(named: "role_curtain09")!, UIImage(named: "role_curtain08")!, UIImage(named: "role_curtain07")!, UIImage(named: "role_curtain06")!, UIImage(named: "role_curtain05")!, UIImage(named: "role_curtain04")!, UIImage(named: "role_curtain03")!, UIImage(named: "role_curtain02")!, UIImage(named: "role_curtain01")!]

let closeImages : [UIImage]! = [UIImage(named: "role_curtain01")!, UIImage(named: "role_curtain02")!, UIImage(named: "role_curtain03")!, UIImage(named: "role_curtain04")!, UIImage(named: "role_curtain05")!, UIImage(named: "role_curtain06")!, UIImage(named: "role_curtain07")!, UIImage(named: "role_curtain08")!, UIImage(named: "role_curtain09")!]



struct startCurtainAnimation: UIViewRepresentable {
    
    @State var width : CGFloat
    @State var height : CGFloat
    @State var curtainImages : [UIImage]
    
    func makeUIView(context: Self.Context) -> UIView {
        
        let curtainAnimation = UIImage.animatedImage(with: curtainImages, duration: 4)
        let ratio = height / curtainImages[0].size.height
        let x = ( width - curtainImages[0].size.width * ratio ) / 2

        let animationView = UIView(frame: CGRect(x: x, y: 0, width: curtainImages[0].size.width * ratio, height: height))
        let curtainImage = UIImageView(frame: CGRect(x: x,y:0, width: curtainImages[0].size.width * ratio, height: height))

        curtainImage.clipsToBounds = true
        curtainImage.autoresizesSubviews = true
        curtainImage.contentMode = UIView.ContentMode.scaleAspectFit
        curtainImage.image = curtainAnimation
        
//        animationView.backgroundColor = UIColor.red
        
        animationView.addSubview(curtainImage)

        return animationView

    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<startCurtainAnimation>) {
    }
}
