//
//  BLEManager.swift
//  SmartLights
//
//  Created by Jared O'Connell on 4/24/22.
//

import Foundation
import CoreBluetooth
import OrderedCollections

struct Peripheral: Identifiable {
    let id: UUID
    let name: String
    let rssi: Int
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    
    var myCentral: CBCentralManager!

    @Published var isSwitchedOn = false
    @Published var peripherals: OrderedDictionary<UUID, Peripheral> = [:]
    
    let SERVICE_UUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let TO_ESP32_UUID = CBUUID(string: "6eed7e34-9f2a-4f0f-b1d6-70cd04e8e581")
    let TO_PHONE_UUID = CBUUID(string: "1cf8d309-11a3-46fb-9378-9afff7dce3b4")
    
    override init() {
        super.init()

        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
        startScanning()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
       
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
       
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheralName, rssi: RSSI.intValue)
        print(newPeripheral)
        peripherals[newPeripheral.id] = newPeripheral
    }
    
    func startScanning() {
         print("startScanning")
         myCentral.scanForPeripherals(withServices: [SERVICE_UUID], options: nil)
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
}
