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

enum SendSequence{
    case IDLE
    case WRITE_REQ
    case WRITE_END
    case READ_REQ
}

enum ReqType{
    case NONE_REQ
    case STOP_REQ
    case OPEN_REQ
    case CLOSE_REQ
    case ALARM_OPNE_REQ
    case ALARM_CLOSE_REQ
    case GET_ALARM_INFO_REQ
}

let deViceId : Data = Data(_: [ 0x00, 0x01 ])
let funcStop :      Data = deViceId + Data(_: [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ])
let funcAutoOpen :  Data = deViceId + Data(_: [ 0x00, 0x01, 0x00, 0x00, 0x00, 0x00 ])
let funcAutoClose : Data = deViceId + Data(_: [ 0x00, 0x02, 0x00, 0x00, 0x00, 0x00 ])

let verfyStop : Data  = Data(_: [0x00])
let verfyOpen : Data  = Data(_: [0x01])
let verfyClose : Data = Data(_: [0x02])

let verifyDataPosAct : Int = 0
let verifyDataLenAct : Int = 1
let verifyDataPosAlarmOpen : Int = 1
let verifyDataLenAlarmOpen : Int = 2
let verifyDataPosAlarmClose : Int = 3
let verifyDataLenAlarmClose : Int = 2

class BleController: BleHandlingDelegate {
    
//    @EnvironmentObject var systemState :SystemState
    var systemState : SystemState?
    var bleHandler = BleHandler()
    var bleSequenceState: SendSequence = .IDLE
    var reqType : ReqType = .NONE_REQ
    
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
                bleSequenceWrite(controlReq: userReq)
                
            }

            eventDetection = true
            break
            
        default:
            break
            
        }
        
        return eventDetection
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
            
        case .SUCCESSFUL_WRITE:
            bleSequenceState = .WRITE_END
            bleSequenceRead()
            break
            
        case .SUCCESSFUL_READ:
            bleSequenceVrify()
            break
            
        default:
            break
        }
    }
    
    func bleSequenceWrite(controlReq: UserReq){
        
        var writeData: Data
        var req : ReqType = .NONE_REQ
        
        switch controlReq {
        case .STOP:
            writeData = funcStop
            req = .STOP_REQ
            break
            
        case .OPEN:
            writeData = funcAutoOpen
            req = .ALARM_OPNE_REQ
            break
            
        case .CLOSE:
            writeData = funcAutoClose
            req = .CLOSE_REQ
            break
            
        default:
            writeData = funcStop
            break
        }
        
        if( bleSequenceState == .IDLE ){
            bleHandler.writeService(data: writeData)
            bleSequenceState = .WRITE_REQ
            reqType = req
        }
    }


    func bleSequenceRead(){
        if( bleSequenceState == .IDLE
         && bleSequenceState == .WRITE_END ){
            bleHandler.readService()
            bleSequenceState = .READ_REQ
        }
    }
    
    
    func bleSequenceVrify(){
        if( bleSequenceState == .READ_REQ ){
            
            let getData = bleHandler.getData
            var verifyData : Data = Data()
            var dataRange1 : Int = 0
            var dataRange2 : Int = 0
            
            switch reqType {
            case .STOP_REQ:
                verifyData = verfyStop
                dataRange1 = verifyDataPosAct
                dataRange2 = verifyDataPosAct + verifyDataLenAct - 1
                break
            case .OPEN_REQ:
                verifyData = verfyOpen
                dataRange1 = verifyDataPosAct
                dataRange2 = verifyDataPosAct + verifyDataLenAct - 1
                break
            case .CLOSE_REQ:
                verifyData = verfyClose
                dataRange1 = verifyDataPosAct
                dataRange2 = verifyDataPosAct + verifyDataLenAct - 1
                break
            default:
                break
            }
            
            if getData?.subdata(in: Range(dataRange1...dataRange2)) == verifyData {
                
            }
            
            bleSequenceState = .IDLE
        }
    }

    
    @objc func pairingTimeout(){
        if( systemState!.pairingState == .SEARCHING ){
            systemState!.pairingState = .UNCONNECTED
        }
    }
}
