//
//  SystemState.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/06/07.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import Foundation

enum PairingState: String{
    case CONNECTED   = "デバイス接続済み"
    case UNCONNECTED = "デバイス未検出"
    case SEARCHING   = "デバイス検索中"
}

enum UserReq {
    case NONE
    case SEARCH
    case OPEN
    case CLOSE
    case STOP
}

class SystemState: ObservableObject{
    @Published var pairingState :PairingState = .SEARCHING
    @Published var userReq :UserReq = .NONE
}
