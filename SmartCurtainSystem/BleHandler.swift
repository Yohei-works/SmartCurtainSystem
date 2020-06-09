//
//  BleHandler.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/06/07.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import UIKit
//import SwiftUI

class BleHandler {
    
//    @EnvironmentObject var systemState :SystemState
    var systemState: SystemState?
    var bleController = BleController()
    
//    init(environmentObj: SystemState) {
        
//        systemState = environmentObj
    init(){
        Timer.scheduledTimer(timeInterval: 7,
                             target: self,
                             selector: #selector(pairingTimeout),
                             userInfo: nil,
                             repeats: false)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    func setSystemState(systemState: SystemState){
        self.systemState = systemState
    }
    
    @objc func pairingTimeout(){
        if( systemState!.pairingState == .SEARCHING ){
            systemState!.pairingState = .UNCONNECTED

            let alert = UIAlertController(title:"alert",
                                  message: "yes or no",
                                  preferredStyle: .alert)
        
        }
    }

}
