//
//  BlueToothUtil.swift
//  mlDiagnostic
//
//  Created by Fall 2023 on 10/29/23.
//

import Foundation
import CoreBluetooth
import UIKit
import SwiftUI


// let service_UUID = CBUUID(string: "e9ea0001-e19b-482d-9293-c7907585fc48")
// target characteristic uuid
let characteristic_UUID = CBUUID(string: "e9ea0002-e19b-482d-9293-c7907585fc48")

struct BlueToothLog: CustomStringConvertible, Hashable {
    
    var description: String {
        return "[\(time.description)]\n[\(isNormal ? "LOG" : "ERROR")]\n\(message)"
    }
    
    let time: Date
    let message: String
    let isNormal: Bool
    
}

// bluetooth: https://medium.com/macoclock/core-bluetooth-ble-swift-d2e7b84ea98e, https://punchthrough.com/core-bluetooth-basics/, https://github.com/Andrew11US/AF-Swift-Tutorials


class BlueToothVM: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var centralManager: CBCentralManager?
    var inRange = Dictionary<String, CBPeripheral>()
    @Published var connected = Dictionary<String, CBPeripheral>()
    var current: CBPeripheral?
    var centralState: CBManagerState = .unknown
    var log = [BlueToothLog]()
    var value_data: Data?
    var values: [UInt8]?

    
    /// if centralManager is powered on, begin scanning for peripherals.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
            
        }
        centralState = central.state
        log.append(BlueToothLog(time:Date(), message: "Central device state: \(getDeviceStatus(centralState))", isNormal: true))
    }
    
    /// add any unique peripherals to the dictionary.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if inRange[peripheral.name ?? "unknown service"] == nil {
            inRange[peripheral.name ?? "unknown service"] = peripheral
            log.append(BlueToothLog(time:Date(), message: "Peripheral \(peripheral.name ?? "unknown service") found", isNormal: true))
        }
        
    }
    
    /// add connected peripheral to dictionary. set the delegate to BlueToothVM.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        // replace with other checking conditions
        if connected[peripheral.name ?? "unknown service"] == nil {
            connected[peripheral.name ?? "unknown service"] = peripheral
            peripheral.delegate = self
            log.append(BlueToothLog(time:Date(), message: "Peripheral \(peripheral.name ?? "unknown service") connected", isNormal: true))
        }
        
    }
    
    /// remove the peripheral from the connected dictionary.
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if let error = error {
            log.append(BlueToothLog(time: Date(), message: error.localizedDescription, isNormal: false))
        }
        else {
            log.append(BlueToothLog(time: Date(), message: "Peripheral \(peripheral.name!) disconnected", isNormal: true))
        }
        if connected[peripheral.name ?? "unknown service"] != nil {
            connected[peripheral.name ?? "unknown service"] = nil
        }
    }
    
    /// discover characteristics for all discovered services.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let error = error {
            log.append(BlueToothLog(time: Date(), message: error.localizedDescription, isNormal: false))
        }
        else {
            log.append(BlueToothLog(time: Date(), message: "Peripheral \(peripheral.name ?? "unknown service") service discovered", isNormal: true))
        }
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /// read value for discovered characteristics.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let error = error {
            log.append(BlueToothLog(time: Date(), message: error.localizedDescription, isNormal: false))
        }
        else {
            log.append(BlueToothLog(time: Date(), message: "Peripheral \(peripheral.name ?? "unknown service") service \(service.description) characteristic discovered", isNormal: true))
        }

        for charactistic in service.characteristics! {
            peripheral.readValue(for: charactistic)
        }
    }
    
    /// update value.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            log.append(BlueToothLog(time: Date(), message: error.localizedDescription, isNormal: false))
        }
        else {
            log.append(BlueToothLog(time: Date(), message: "Peripheral \(peripheral.name ?? "unknown service")  \(characteristic.description) value updated", isNormal: true))
        }
        if (characteristic.uuid == characteristic_UUID) {
            value_data = characteristic.value
            values = getUIntList(characteristic)
 
        }
    }
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func connect(_ p: CBPeripheral) {
        centralManager?.connect(p)
    }
    func disconnect(_ p: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(p)
    }
    
    /// forced value update.
    func updateValue() {

        if let current = current {
            for service in current.services! {
                for characteristic in service.characteristics! {
                    current.readValue(for: characteristic)
                    if (characteristic.uuid == characteristic_UUID) {
                        value_data = characteristic.value
                        values = getUIntList(characteristic)

                    }
                }
            }
        }
        
    }
}

func getDeviceStatus(_ status: CBManagerState) -> String {
    switch status.rawValue {
    case 0:
        return "unknown"
    case 1:
        return "resetting"
    case 2:
        return "unsupported"
    case 3:
        return "unauthorized"
    case 4:
        return "powered off"
    case 5:
        return "powered on"
    default:
        return "error"
    }
}

func getValueString(_ c: CBCharacteristic) ->String {
    if let data = c.value {
        if let str = String(data: data, encoding: .utf8) {
            return str
        }
    }
    return "cannot parse data"
}

func getValueSize(_ c: CBCharacteristic) -> Int {
    if let data = c.value {
        return data.count
    }
    return 0
}

// https://stackoverflow.com/questions/24516170/create-an-array-in-swift-from-an-nsdata-object

// experimental:
func getUIntList(_ c: CBCharacteristic) -> [UInt8]? {
    if let data = c.value {
        var arr = Array<UInt8>(repeating: 0, count: data.count/MemoryLayout<UInt8>.stride)
        _ = arr.withUnsafeMutableBytes { data.copyBytes(to: $0) }
        return arr
    }
    return nil
}

func getListAsStr(_ list: [UInt8]?) -> String {
    if let list = list {
        var str = ""
        for i in list {
            str += String(i) + " "
        }
        return str
    }
    else {
        return "EMPTY"
    }
}

@ViewBuilder
func getUIntVals(_ c: CBCharacteristic) -> some View {
    
    if (c.uuid == characteristic_UUID) {
        Text(getListAsStr(getUIntList((c))))
    }
}
