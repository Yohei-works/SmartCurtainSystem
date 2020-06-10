//
//  BleStateView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI
import UIKit

struct BleStateView: View {
    
    @EnvironmentObject var systemState :SystemState
    
    var body: some View {
//        Color("tab")
        
        LinearGradient(gradient: Gradient(colors: [Color("bleview_top"), Color("bleview_bottom")]), startPoint: .top, endPoint: .bottom)
            .overlay(
                GeometryReader{ geomerty in
                    HStack{

                        if (self.systemState.pairingState == .SEARCHING){
//                            Image(uiImage: waveAnimation!)
                            startWaveAnimation(height: geomerty.size.height * 0.7)
                                .scaledToFit()
                                .frame( height: geomerty.size.height * 0.7)
                            
                        }
                        else if(self.systemState.pairingState == .CONNECTED){
                            Image("wave05")
                                .resizable()
                                .scaledToFit()
                                .frame(height: geomerty.size.height * 0.7)
                        }
                        else{
                            Image("wave01")
                                .resizable()
                                .scaledToFit()
                                .frame(height: geomerty.size.height * 0.7)
                        }
                        
                        VStack{
                            Spacer()
                                .frame(height: geomerty.size.height * 0.5)
                            Text(self.systemState.pairingState.rawValue)
                                .bold()
                                .frame(width: geomerty.size.width * 0.35, alignment: .leading)
                    
                        }
                        
                        VStack{
                            Spacer()
                            .frame(height: geomerty.size.height * 0.2)

                            Button(action: {
                                self.systemState.userReq = .SEARCH
                                
                            }) {
                                Image("searchBtn")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geomerty.size.width * 0.25)
                                
                            }
                        }
                    }
                }
            )
    }
}


struct BleStateView_Previews: PreviewProvider {
    static var previews: some View {
        BleStateView()
    }
}



struct startWaveAnimation: UIViewRepresentable {
    
//    @State var width: CGFloat
    @State var height: CGFloat
    
    func makeUIView(context: Self.Context) -> UIView {

        let waveImages : [UIImage]! = [UIImage(named: "wave02")!, UIImage(named: "wave03")!, UIImage(named: "wave04")!, UIImage(named: "wave05")!]
        let waveAnimation = UIImage.animatedImage(with: waveImages, duration: 2.3)
        let ratio = height / waveImages[0].size.width

        let animationView = UIView(frame: CGRect(x: 0, y: 0, width: waveImages[0].size.width * ratio, height: height))
        let waveImage = UIImageView(frame: CGRect(x:0,y:0, width: waveImages[0].size.width * ratio, height: height))

        waveImage.clipsToBounds = true
        waveImage.autoresizesSubviews = true
        waveImage.contentMode = UIView.ContentMode.scaleAspectFit
        waveImage.image = waveAnimation
//        waveImage.image = UIImage(named: "wave01")
//        waveImage.frame = CGRect(x:50,y:50, width: 50,height: 50)

        
        animationView.addSubview(waveImage)

//        print("\(animationView.frame)")
//        print("\(waveImage.frame)")

        return animationView
//        return waveImage
//        TestUIView()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<startWaveAnimation>) {
    }
}

class TestUIView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}



