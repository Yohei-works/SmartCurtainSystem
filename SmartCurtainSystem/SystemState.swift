//
//  SystemState.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/06/07.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import Foundation

enum PairingState: String{
    case connected   = "デバイス接続済み"
    case unconnected = "デバイス未検出"
    case searching   = "デバイス検索中"
}

enum UserReq {
    case none
    case search
    case autoOpen
    case autoClose
    case stop
    case alarmOpen
    case alarmClose
}

enum CurtaionState {
    case stopping
    case openingOperation
    case closingOperation
}

enum DeviceState {
    case stop
    case autoOpen
    case autoClose
    case manualOpen
    case manualClose
}

struct AlarmData {
    var hour : UInt8 = 0{
        didSet {
            if hour > 23{
                hour = 0
                alarmSw = false
            }
        }
    }
    var minutes : UInt8 = 0{
        didSet {
            if minutes > 59{
                minutes = 0
                alarmSw = false
            }
        }
    }
    var alarmSw : Bool = false
    
    func getTimeLabel()->String{
        
        var label = ""
        
        if self.hour < 10{
            label = "0"+String(self.hour)+":"
        }
        else{
            label = String(self.hour)+":"
        }
        
        if self.minutes < 10{
            label += "0"+String(self.minutes)
        }
        else{
            label += String(self.minutes)
        }
        
        return label
    }
    
//    init(hour:UInt8, minutes:UInt8){
//        self.hour = hour
//        self.minutes = minutes
//    }
}

class SystemState: ObservableObject{
    @Published var pairingState : PairingState = .searching
    @Published var userReq : UserReq = .none
    @Published var curtainState : CurtaionState = .stopping
    @Published var deviceState : DeviceState = .stop{
        didSet{
            isUserInteractionEnabled = (deviceState != .manualOpen && deviceState != .manualClose)
        }
    }
    @Published var alarmOpen = AlarmData()
    @Published var alarmClose = AlarmData()
    @Published var isUserInteractionEnabled : Bool = true
    @Published var curtainPos : Int = 50
}
