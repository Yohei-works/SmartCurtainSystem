//
//  BleController.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/06/06.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import UIKit
import CoreBluetooth

enum CharacteristicsType: String{
    case CONTROL = "FFF1"
    case VERIFY  = "FFF2"
    case NONE    = "0000"
}

class BleController :NSObject,CBCentralManagerDelegate, CBPeripheralDelegate{

    var centralManager: CBCentralManager?
    var myPeripheral: CBPeripheral?
    var processingUUID: CharacteristicsType = CharacteristicsType.NONE
    let deviceName: String = "Smart_Curtain"
    let serviceUUID: [CBUUID] = [CBUUID(string: "FFF0")]
//    let controlCharacteristicsUUID: [CBUUID] = [CBUUID(string: "FFF1")]
//    let verifyCharacteristicsUUID: [CBUUID] = [CBUUID(string: "FFF2")]
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init error")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .unknown:
            print(".unknown")
            break
        case .resetting:
            print(".resetting")
            break
        case .unsupported:
            print(".unsupported")
            break
        case .unauthorized:
            print(".unauthorized")
            break
        case .poweredOff:
            print(".poweredOff")
            break
        case .poweredOn:
            // デバイスをスキャン
            centralManager!.scanForPeripherals(withServices: nil, options: nil)
            break
        }
    }
    
    // デバイスを検出したら呼ばれる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(nil != peripheral.name){
            if(deviceName == peripheral.name!){
                myPeripheral = peripheral
                centralManager!.connect(myPeripheral!, options: nil)
            }
        }
    }
    
    // デバイスへの接続が成功すると呼ばれる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        myPeripheral!.delegate = self
        //指定されたサービスを探す
        myPeripheral!.discoverServices(serviceUUID)
    }
     
    // デバイスへの接続が失敗すると呼ばれる
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connect failed...")
    }
    
    // サービスの検索が成功したら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discover Services")
        //通知したい
    }
    
    func discoverCharacterristics(type: CharacteristicsType){
        let service: CBService = myPeripheral!.services![0]
        let uuid :[CBUUID] = [CBUUID(string: type.rawValue)]
        processingUUID = type
        myPeripheral!.discoverCharacteristics(uuid, for: service)
    }
    
    // Characteristics を発見したら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Find Characteristics")
     
//        let command = "IOS_TEST" + "\n"
//        let data = command.data(using: String.Encoding.utf8, allowLossyConversion:true) ?? Data(bytes: [0])
        //ペリフェラルの保持しているキャラクタリスティクスから特定のものを探す
        for i in service.characteristics!{
            if(i.uuid.uuidString == processingUUID.rawValue){
                //Notification を受け取るというハンドラ
//                peripheral.setNotifyValue(true, for: i)
                //書き込み
//                peripheral.writeValue(data , for: i, type: .withResponse)
            }
        }
    }
    // Notificationを受け取ったら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // valueの中にData型で値が入っている
        print(characteristic.value)
    }
    
}

