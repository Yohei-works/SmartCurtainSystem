//
//  SearchView.swift
//  SmartCurtainSystem
//
//  Created by yohei on 2020/05/24.
//  Copyright © 2020 yamanyon. All rights reserved.
//

import SwiftUI
import UIKit
import CoreBluetooth

struct SearchView: UIViewRepresentable{
    func makeUIView(context: Context) -> UIViewType {
        SerchBleView(frame: .zero)
    }
    
    func updateUIView(_ view: SerchBleView, context: Context) {
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


class SerchBleView :UIView,CBCentralManagerDelegate, CBPeripheralDelegate{

    var centralManager: CBCentralManager?
    var myPeripheral: CBPeripheral?
    let deviceName: String = "Smart_Cirtain"
    let serviceUUID: [CBUUID] = [CBUUID(string: "FFF0")]
    let characteristicsUUID: [CBUUID] = [CBUUID(string: "FFF1")]
//    let descriptorUUID: [CBUUID] = [CBUUID(string: "1234")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "background")
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
        let service: CBService = myPeripheral!.services![0]
        myPeripheral!.discoverCharacteristics(characteristicsUUID, for: service)
    }
    
    // Characteristics を発見したら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Find Characteristics")
     
        let command = "IOS_TEST" + "\n"
        let data = command.data(using: String.Encoding.utf8, allowLossyConversion:true) ?? Data(bytes: [0])
        //ペリフェラルの保持しているキャラクタリスティクスから特定のものを探す
        for i in service.characteristics!{
            print("\(i.uuid.uuidString)")
            print("\(characteristicsUUID[0].description)")
            if(i.uuid.uuidString == characteristicsUUID[0].description){
                //Notification を受け取るというハンドラ
                peripheral.setNotifyValue(true, for: i)
                //書き込み
                peripheral.writeValue(data , for: i, type: .withResponse)
            }
        }
    }
    // Notificationを受け取ったら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // valueの中にData型で値が入っている
        print(characteristic.value)
    }
    
}
