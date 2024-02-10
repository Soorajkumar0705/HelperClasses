//
//  BLEManagerPeripheralDelegate.swift
//  HelperClasses
//
//  Created by Apple on 10/02/24.
//

import CoreBluetooth

extension BLEManager : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central ", central)
        self.bleState = central.state
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let peripheralName = peripheral.name  else {return}
        print(peripheralName)
        
        if peripheralName == "Your device name"{ // peripheralMacId got from the ScanQRCodeVC
            self.cbCentralManager.connect(peripheral,options: nil)
            self.peripheral = peripheral
            cbCentralManager.stopScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected : \(peripheral.name ?? "No Name")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        self.didConnetedToPeripheral?(peripheral.name ?? "No Name found.")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected : \(peripheral.name ?? "No Name")")
        self.didDisconnectedToPeripheral?("Some Message If have to pass")
        cbCentralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // Generic reusable function
    func readValueForCharacteristic(characteristic : CBCharacteristic){
        if let peripheral {
            if characteristic.properties.contains(.read){
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func notifyValueForCharacteristic(characteristic : CBCharacteristic){
        if let peripheral {
            if characteristic.properties.contains(.notify){
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

}

extension BLEManager: CBPeripheralDelegate{
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in (peripheral.services ?? []){
            
            print("Service : - ",service)
            peripheral.discoverCharacteristics(nil, for: service)
            
            switch service.uuid.uuidString {
    
            default:
                print("Unknow service found in BLE Manager , ",#function)
                
            }   // switch Block
        }   // for loop
    }   // didDiscoverServices
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in (service.characteristics ?? []){
            switch service.uuid.uuidString {
                
                
            default:
                print("Unknow service found in BLE Manager , ",#function)
            }   // switch block
        }   // for loop
    }   // didDiscoverCharacteristicsFor
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Characteristic : -", characteristic.uuid.uuidString)
        
        if let value = characteristic.value {
            
            let stringValue = value
            
            // check the service then go to the characteristic
            switch characteristic.service?.uuid.uuidString {
                
                
                
            default:
                print("Unknow Characteristics \(characteristic) found in BLE Manager for service:\(characteristic.service?.uuid.uuidString ?? "Char") in ",#function)
                
            } // switch block
            
        }   // if let block
        
    }   // didUpdateValueFor
    
}   // CBPeripheralDelegate
