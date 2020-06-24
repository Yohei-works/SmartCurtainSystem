//
//  BleHandler.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/06/06.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import UIKit
import CoreBluetooth

enum BleEvent{
    case noneEvent
    case connectionFaildEvent
    case deviceDetectionEvent
    case notifiDeviceInfo1
    case notifiDeviceInfo2
}

protocol BleHandlingDelegate {
    func bleEventNotify(event: BleEvent)
}

class BleHandler :NSObject,CBCentralManagerDelegate, CBPeripheralDelegate{

    enum CharacteristicsType: String{
        case control = "FFF1"
        case deviceInfo1 = "FFF2"
        case deviceInfo2 = "FFF3"
        case none    = "0000"
    }

    var delegate: BleHandlingDelegate?
    var centralManager: CBCentralManager?
    var myPeripheral: CBPeripheral?
    var processingUUID: CharacteristicsType = CharacteristicsType.none
    var reqData: Data?
    var deviceInfoData1: Data?
    var deviceInfoData2: Data?
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
        case .unknown,
             .resetting,
             .unsupported,
             .unauthorized,
             .poweredOff:
            //イベント通知
            self.delegate?.bleEventNotify(event: .connectionFaildEvent)
            break
        case .poweredOn:
            // デバイスをスキャン
            startScanDevice()
            break
        }
    }
    
    //デバイスのスキャンを開始
    func startScanDevice(){
        centralManager!.scanForPeripherals(withServices: nil, options: nil)
    }

    //デバイスのスキャンを停止
    func stopScanDevice(){
        centralManager!.stopScan()
    }

    
    // デバイスを検出したら呼ばれる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {        
        if(nil != peripheral.name){
            if(deviceName == peripheral.name!){
                myPeripheral = peripheral
                centralManager!.connect(myPeripheral!, options: nil)
                //デバイススキャンを停止
                stopScanDevice()
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
        //イベント通知
        self.delegate?.bleEventNotify(event: .connectionFaildEvent)
    }
    
    // サービスの検索が成功したら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if(error == nil){
            //イベント通知
            self.delegate?.bleEventNotify(event: .deviceDetectionEvent)
        }
        else{
            //イベント通知
            self.delegate?.bleEventNotify(event: .connectionFaildEvent)
        }
    }
    
    //BLE_WRITEサービス
    func writeService(data: Data){
        let service: CBService = myPeripheral!.services![0]
        let uuid :[CBUUID] = [CBUUID(string: CharacteristicsType.control.rawValue)]
        processingUUID = .control
        reqData = data
        myPeripheral!.discoverCharacteristics(uuid, for: service)
    }
    
    //BLE_READサービス
    func readService(){
        let service: CBService = myPeripheral!.services![0]
        let uuid :[CBUUID] = [CBUUID(string: CharacteristicsType.deviceInfo1.rawValue)]
        processingUUID = .deviceInfo1
        myPeripheral!.discoverCharacteristics(uuid, for: service)
    }
        
    // Characteristics を発見したら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
     
//        let command = "IOS_TEST" + "\n"
//        let data = command.data(using: String.Encoding.utf8, allowLossyConversion:true) ?? Data(bytes: [0])
        //ペリフェラルの保持しているキャラクタリスティクスから特定のものを探す
        for i in service.characteristics!{
            if(  i.uuid.uuidString == CharacteristicsType.control.rawValue){
                if( processingUUID == .control ){
                    //Notification を受け取るというハンドラ
//                    peripheral.setNotifyValue(true, for: i)
                    //書き込み
                    peripheral.writeValue(reqData! , for: i, type: .withResponse)
                }
                else if(processingUUID == .deviceInfo1){
                    peripheral.readValue(for: i)
                }
                else{}
                
                processingUUID = .none
            }
        }
    }
    // Notificationを受け取ったら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if(characteristic.uuid.uuidString == CharacteristicsType.deviceInfo1.rawValue){
            deviceInfoData1 = characteristic.value
            self.delegate?.bleEventNotify(event: .notifiDeviceInfo1)
        }
        else if(characteristic.uuid.uuidString == CharacteristicsType.deviceInfo2.rawValue){
            deviceInfoData2 = characteristic.value
            self.delegate?.bleEventNotify(event: .notifiDeviceInfo2)
        }
        else{}
        //送信したデータと一致してたらイベント通知
//        if(reqData == characteristic.value){
//            self.delegate?.bleEventNotify(event: .SUCCESSFUL_WRITE)
//        }
    }
    
    // データ読み出しが完了すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        if(characteristic.uuid.uuidString == CharacteristicsType.deviceInfo1.rawValue){
            deviceInfoData1 = characteristic.value
            self.delegate?.bleEventNotify(event: .notifiDeviceInfo1)
        }
    }
    
}
