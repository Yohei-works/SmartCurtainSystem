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

let deViceId : Data = Data(_: [ 0x01 ])
let funcStop :      Data = deViceId + Data(_: [ 0x00, 0x00, 0x00 ])
let funcAutoOpen :  Data = deViceId + Data(_: [ 0x01, 0x00, 0x00 ])
let funcAutoClose : Data = deViceId + Data(_: [ 0x02, 0x00, 0x00 ])



class BleController: BleHandlingDelegate {
    
    struct WriteData{
        
        var userReq : UserReq
        var timeHour : UInt8 = 0
        var timeMinutes : UInt8 = 0
        
        init(req:UserReq, h:UInt8, m:UInt8){
            let alarmReq = (req == .alarmOpen || req == .alarmClose)
            userReq = req
            timeHour = alarmReq ? h : 0
            timeMinutes = alarmReq ? m: 0
        }
        
        init(req:UserReq){
            userReq = req
        }
        
        func getData()->Data?{
            var data = Data(_: [ 0x01 ])
            
            switch userReq{
            case .stop:
                data += Data(_: [ 0x00 ])
            case .autoOpen:
                data += Data(_: [ 0x01 ])
            case .autoClose:
                data += Data(_: [ 0x02 ])
            case .alarmOpen:
                data += Data(_: [ 0x03 ])
            case .alarmClose:
                data += Data(_: [ 0x04 ])
            default:
                return nil
            }
            
            data += Data(_:[timeHour,timeMinutes])
            
            return data
        }
    }
    
//    @EnvironmentObject var systemState :SystemState
    var systemState : SystemState?
    var bleHandler = BleHandler()
    
    init(){
        bleHandler.delegate = self
        pairingTimerStart()
        
//        let d = Data(_: [0x56])
//        print(FuncAutoOpen.subdata(in: Range(0...0)))
//        print(String(data: FuncAutoOpen, encoding: .utf8))
//        print(TestData.subdata(in: Range(2...2)) == d)
//        print(TestData.subdata(in: Range(0...0)) == d)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    
    //システム状態が通知される
    func setSystemState(systemState: SystemState){
        
        self.systemState = systemState
        if( jdgUserReq(userReq: self.systemState!.userReq) ){
            self.systemState!.userReq = .none
        }
    }
    
    //ユーザリクエスト判定
    private func jdgUserReq( userReq: UserReq ) -> Bool {
        
        var eventDetection: Bool = false
        
        switch userReq {
        
        case .search:
            
            if ( systemState!.pairingState != .searching ){
                self.systemState?.pairingState = .searching
                pairingTimerStart()
                
                //デバイスのスキャンを指示
                bleHandler.startScanDevice()
            }
            
            eventDetection = true
            break
        
        case .autoOpen, .autoClose, .stop:
            if let writeData = WriteData(req: userReq).getData(){
                if ( systemState!.pairingState == .connected ){
                    //制御指示を送信
                    bleHandler.writeService(data: writeData)
                }
            }

            eventDetection = true
            break
            
        default:
            break
            
        }
        
        return eventDetection
    }
        
    //ペアリングタイマスタート
    private func pairingTimerStart(){
        Timer.scheduledTimer(timeInterval: 7,
                             target: self,
                             selector: #selector(pairingTimeout),
                             userInfo: nil,
                             repeats: false)
    }
    
    
    
    func bleEventNotify(event: BleEvent) {
        switch event {
            
        case .connectionFaildEvent:
            // デバイス検索がタイムアウトするまではひたすらリトライ
            if ( systemState!.pairingState == .searching ) {
                self.bleHandler.startScanDevice()
            }
            
        case .deviceDetectionEvent:
            if ( systemState!.pairingState != .connected ){
                self.systemState?.pairingState = .connected
                Timer.scheduledTimer(timeInterval: 60,
                target: self,
                selector: #selector(statusUpdate),
                userInfo: nil,
                repeats: true)

            }
            
        case .notifiDeviceInfo1:
            if let getData = bleHandler.deviceInfoData1{
                let (state, pos) = getSystemInfo1(inputData: getData)
                self.systemState?.deviceState = state
                self.systemState?.curtainPos = pos
            }

        case .notifiDeviceInfo2:
            if let getData = bleHandler.deviceInfoData2{
                let (openH, openM, closeH, closeM) = getSystemInfo2(inputData: getData)
            
                self.systemState?.alarmOpen.alarmSw = true
                self.systemState?.alarmOpen.hour = openH
                self.systemState?.alarmOpen.minutes = openM
                self.systemState?.alarmClose.alarmSw = true
                self.systemState?.alarmClose.hour = closeH
                self.systemState?.alarmClose.minutes = closeM
            }

        default:
            break
        }
    }
    

    private func getSystemInfo1(inputData: Data)->(DeviceState, Int){
        
        var deviceInfo1:DeviceState = .stop
        var pos = 50
        
        let data1 = UInt8(inputData.subdata(in: Range(0...0)).description)
        if let data2 = Int(inputData.subdata(in: Range(1...1)).description){
            pos = data2
        }
        else{
            pos = 50
        }
        
        
        switch data1{
        case 0x01:
            deviceInfo1 = .autoOpen
        case 0x03:
            deviceInfo1 = .autoClose
        case 0x05:
            deviceInfo1 = .manualOpen
        case 0x07:
            deviceInfo1 = .manualClose
        default:
            deviceInfo1 = .stop
        }
        return (deviceInfo1, pos)
    }
    
    
    private func getSystemInfo2(inputData: Data)->(UInt8,UInt8,UInt8,UInt8){
        
        var openH:UInt8 = 0xFF,openM:UInt8 = 0xFF,closeH:UInt8 = 0xFF,closeM:UInt8 = 0xFF
        
        if let data = UInt8(inputData.subdata(in: Range(0...0)).description){
            openH = data
        }
        
        if let data = UInt8(inputData.subdata(in: Range(1...1)).description){
            openM = data
        }
        
        if let data = UInt8(inputData.subdata(in: Range(2...2)).description){
            closeH = data
        }
        
        if let data = UInt8(inputData.subdata(in: Range(3...3)).description){
            closeM = data
        }
                
        return (openH,openM,closeH,closeM)
    }
    
    
    @objc func pairingTimeout(){
        if( systemState!.pairingState == .searching ){
            systemState!.pairingState = .unconnected
        }
    }

    @objc func statusUpdate(){
        bleHandler.readService()
    }

}
