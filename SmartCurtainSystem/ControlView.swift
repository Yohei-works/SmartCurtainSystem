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

                            if( self.systemState.deviceState == .autoOpen
                                || self.systemState.deviceState == .manualOpen){
                                startCurtainAnimation(width: geometry.size.width * 0.9, height:  geometry.size.height * 0.4, curtainImages: openImages)
                            }
                            else if( self.systemState.deviceState == .autoClose
                                || self.systemState.deviceState == .manualClose){
                                startCurtainAnimation(width: geometry.size.width * 0.9, height:  geometry.size.height * 0.4, curtainImages: closeImages)
                            }
                            else{
                                Image( self.getCurtaionImageName(curtainPos: self.systemState.curtainPos) )
                                    .resizable()
                                    .scaledToFit()
                            }

                        }
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.4)
                        
                        Spacer().frame(height: geometry.size.height * 0.12)

                        
                        HStack{
                            if(self.systemState.isUserInteractionEnabled){
                                Button(action: {
                                    self.systemState.userReq = .autoOpen
                                    
                                }) {
                                    Image("OPEN_inactive")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            else{
                                Image("OPEN_active")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                            }
                            
                            Spacer().frame(width: geometry.size.width * 0.085)
                            
                            if(self.systemState.isUserInteractionEnabled){
                                Button(action: {
                                    self.systemState.userReq = .autoClose
                                    
                                }) {
                                    Image("CLOSE_inactive")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            else{
                                Image("CLOSE_active")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                            }

                        }.frame(height: geometry.size.height * 0.1)

                        Spacer().frame(height: geometry.size.height * 0.075)
                        
                        HStack{
                            if(self.systemState.isUserInteractionEnabled){
                                
                                Button(action: {
                                    self.systemState.userReq = .stop
                                    
                                }) {
                                    Image("STOP_inactive")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            else{
                                Image("STOP_active")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }.frame(height: geometry.size.height * 0.1)
                       
                        Spacer().frame(height: geometry.size.height * 0.145)

                    }
                }
            )
    }
    private func getCurtaionImageName(curtainPos: Int)->String{
        let imageCnt = openImages.count
        let input = curtainPos > 100 ? 50 : curtainPos
        let temp: Int = input / (100 / imageCnt)
        let index = temp >= imageCnt ? imageCnt-1 : temp
        
        return curtainImgName[index]
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
    }
}

let curtainImgName = [
    "role_curtain09",
    "role_curtain08",
    "role_curtain07",
    "role_curtain06",
    "role_curtain05",
    "role_curtain04",
    "role_curtain03",
    "role_curtain02",
    "role_curtain01"
]

let openImages : [UIImage]! = [UIImage(named: curtainImgName[0])!, UIImage(named: curtainImgName[1])!, UIImage(named: curtainImgName[2])!, UIImage(named: curtainImgName[3])!, UIImage(named: curtainImgName[4])!, UIImage(named: curtainImgName[5])!, UIImage(named: curtainImgName[6])!, UIImage(named: curtainImgName[7])!, UIImage(named: curtainImgName[8])!]

//let closeImages = openImages.reversed()

let closeImages : [UIImage]! = [UIImage(named: curtainImgName[8])!, UIImage(named: curtainImgName[7])!, UIImage(named: curtainImgName[6])!, UIImage(named: curtainImgName[5])!, UIImage(named: curtainImgName[4])!, UIImage(named: curtainImgName[3])!, UIImage(named: curtainImgName[2])!, UIImage(named: curtainImgName[1])!, UIImage(named: curtainImgName[0])!]



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
