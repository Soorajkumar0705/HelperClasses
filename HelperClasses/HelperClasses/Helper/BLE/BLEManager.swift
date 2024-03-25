//
//  BLEManager.swift
//  HelperClasses
//
//  Created by Apple on 10/02/24.
//

import CoreBluetooth


class BLEManager: NSObject {

    static let shared = BLEManager()

    var cbCentralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    var servicesDict : [String : CBService] = [:]
    var characteristicsDict : [String : CBCharacteristic] = [:]
    var bleState: CBManagerState!{
        didSet{
            if bleState == .poweredOn && getConnectionCallBack{
                self.startScanning()
                self.getConnectionCallBack = false
            }
        }
    }
    var getConnectionCallBack: Bool = false
    
    var peripheralMacId: String = ""
    
    // connection Closures:
    var didConnetedToPeripheral: PassStringClosure? = nil
    var didDisconnectedToPeripheral : PassStringClosure? = nil

    private override init() {
        super.init()

        cbCentralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
        cbCentralManager.delegate = self
        self.bleState = cbCentralManager.state
    }
    
    deinit {
        self.stopScanning()
        self.peripheral = nil
        self.cbCentralManager = nil
    }
    
    func connectPeripheralWithMacId(macId: String, didConnect: PassStringClosure? = nil, didNotConnected: PassStringClosure? = nil){
        
        switch self.bleState{
            
        case .poweredOn:
            getConnectionCallBack = true
            makeConection(macId: macId, didConnect: didConnect)
            
        case .poweredOff:
            didNotConnected?("Please switch on the bluetooth")
            
        case .resetting:
            didNotConnected?("Resetting...")
            
        case .unauthorized:
            break
            
        case .unknown:
            self.getConnectionCallBack = true
            makeConection(macId: macId, didConnect: didConnect)
            
        case .unsupported:
            break
            
        case .none:
            break
            
        case .some(_):
            break

        }

    }
     
    private func makeConection(macId: String, didConnect: (PassStringClosure)? = nil){
        self.peripheralMacId = macId
        self.didConnetedToPeripheral = didConnect
        startScanning()
    }

    private func startScanning() {
        print("startScanning")
        if let peripheral = peripheral {
            cbCentralManager.cancelPeripheralConnection(peripheral)
            self.peripheral = nil
        }
        cbCentralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    private func stopScanning() {
        print("stopScanning")
        cbCentralManager.stopScan()
        disconnectPeripheral()
    }
    
    func disconnectPeripheral(){
        if let peripheral{
            cbCentralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func isPeripheralConnected() -> Bool{
        if let peripheral{
            return peripheral.state == .connected
        }
        return false
    }
    
    func isPeripheralConnectedWith(macId: String) -> Bool{
        if let peripheral{
            if peripheral.state == .connected{
                return peripheralMacId == macId
            }
        }
        return false
    }

}   //BLEManager
