//
//  BleController.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/06/07.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import UIKit
//import SwiftUI

//enum SendReq{
//    case OPEN_REQ
//    case CLOSE_REQ
//    case STOP_REQ
//    case ALARM_OPEN_REQ
//    case ALARM_CLOSE_REQ
//}

class BleController: BleHandlingDelegate {
    
//    @EnvironmentObject var systemState :SystemState
    var systemState: SystemState?
    var bleHandler = BleHandler()
    
//    init(environmentObj: SystemState) {
        
//        systemState = environmentObj
    init(){
        bleHandler.delegate = self
        pairingTimerStart()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    func setSystemState(systemState: SystemState){
        
        self.systemState = systemState
        if( jdgUserReq(userReq: self.systemState!.userReq) ){
            self.systemState!.userReq = .NONE
        }
    }
    
    private func pairingTimerStart(){
        Timer.scheduledTimer(timeInterval: 7,
                             target: self,
                             selector: #selector(pairingTimeout),
                             userInfo: nil,
                             repeats: false)
    }
    
    
    private func jdgUserReq( userReq: UserReq ) -> Bool {
        
        var eventDetection: Bool = false
        
        switch userReq {
        
        case .SEARCH:
            
            if ( systemState!.pairingState != .SEARCHING ){
                self.systemState?.pairingState = .SEARCHING
                pairingTimerStart()
                
                //デバイスのスキャンを指示
                bleHandler.startScanDevice()
            }
            
            eventDetection = true
            break
        
        case .OPEN, .CLOSE, .STOP:
            
            if ( systemState!.pairingState == .CONNECTED ){
                bleSendControlSequence(controlReq: userReq)
            }

            eventDetection = true
            break
                    
        default:
            break
            
        }
        
        return eventDetection
    }
    
    func bleSendControlSequence(controlReq: UserReq){
        
    }
    
    func bleEventNotify(event: BleEvent) {
        switch event {
            
        case .CONNECTION_FAILD:
            // デバイス検索がタイムアウトするまではひたすらリトライ
            if ( systemState!.pairingState == .SEARCHING ) {
                self.bleHandler.startScanDevice()
            }
            break
            
        case .DEVICE_DETECTION:
            if ( systemState!.pairingState != .CONNECTED ){
                self.systemState?.pairingState = .CONNECTED
            }
            break
            
        default:
            break
        }
    }

    @objc func pairingTimeout(){
        if( systemState!.pairingState == .SEARCHING ){
            systemState!.pairingState = .UNCONNECTED
        }
    }
}
