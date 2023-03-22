//
//  WTBLECentralManager.swift
//  
//
//  Created by Prem Pratap Singh on 22/03/23.
//

import Foundation
import CoreBluetooth

class WTBLECentralManager: Object {
    
    // MARK: Public properties
    var callback: WTBLECallback
    
    // MARK: Private properties
    
    private var manager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    private var readCharacteristic: CBCharacteristic?
    private var wtBTType: WTBTType
    
    // MARK: Initializer
    
    init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        self.callback = WTBLECallback()
    }
    
    // MARK: Public methods
    
    func getType() -> WTBTType {
        return self.wtBTType
    }

    func startScan() {
        let options: [String: Any] = [
            CBCentralManagerScanOptionAllowDuplicatesKey: true,
            CBCentralManagerOptionShowPowerAlertKey: true
        ]
        manager.scanForPeripherals(withServices: nil, options: options)
    }

    func cancelScan() {
        manager.stopScan()
    }

    func tryConnectPeripheral(_ peripheral: CBPeripheral) {
        cancelConnection()
        self.peripheral = peripheral
        peripheral.delegate = self
        manager.connect(peripheral, options: nil)
    }

    func cancelConnection() {
        if let peripheral = peripheral {
            manager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func tryReceiveDataAfterConnected() {
        peripheral.discoverServices(nil)
    }

    func readRssi() {
        peripheral.readRSSI()
    }

    func writeData(_ data: Data) {
        guard let writeCharacteristic = writeCharacteristic else {
            return
        }
        peripheral.writeValue(data, for: writeCharacteristic, type: .withoutResponse)
    }
}

// MARK: CBCentralManagerDelegate delegate methods

extension WTBLECentralManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print(">>>CBCentralManagerStateUnknown")
        case .resetting:
            print(">>>CBCentralManagerStateResetting")
        case .unsupported:
            print(">>>CBCentralManagerStateUnsupported")
        case .unauthorized:
            print(">>>CBCentralManagerStateUnauthorized")
        case .poweredOff:
            print(">>>CBCentralManagerStatePoweredOff")
        case .poweredOn:
            print(">>>CBCentralManagerStatePoweredOn")
        @unknown default:
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name, name is String, !name.isEmpty else { return }
        if name.contains("HC") || name.contains("WT") {
            callback.blockOnDiscoverPeripherals?(manager, peripheral, advertisementData, RSSI)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        callback.blockOnConnectedPeripheral?(manager, peripheral)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        callback.blockOnFailToConnect?(manager, peripheral, error)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        callback.blockOnDisconnect?(manager, peripheral, error)
    }

    func setReadCharacteristic(_ readCharacteristic: CBCharacteristic) {
        self.readCharacteristic = readCharacteristic
        self.peripheral.setNotifyValue(true, for: readCharacteristic)
    }

    func setWriteCharacteristic(_ writeCharacteristic: CBCharacteristic) {
        self.writeCharacteristic = writeCharacteristic
    }
}

// MARK: CBPeripheralDelegate delegate methods

extension WTBLECentralManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("discover service error, error is \(error)")
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                let uuidString = characteristic.uuid.uuidString
                if uuidString.lowercased().contains("ffe9") {
                    self.writeCharacteristic = characteristic
                    self.wtBTType = .BT_BLE
                } else if uuidString.lowercased().contains("ffe4") {
                    self.readCharacteristic = characteristic
                } else if uuidString.lowercased().contains("8841") {
                    self.writeCharacteristic = characteristic
                    self.wtBTType = .BT_HC
                } else if uuidString.lowercased().contains("1e4d") {
                    self.readCharacteristic = characteristic
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if self.callback.blockOnReadValueForCharacteristic != nil {
            self.callback.blockOnReadValueForCharacteristic?(peripheral, characteristic, error)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if self.callback.blockOnDiscoverDescriptorsForCharacteristic != nil {
            self.callback.blockOnDiscoverDescriptorsForCharacteristic?(peripheral, characteristic, error)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if self.callback.blockOnReadRssi != nil {
            self.callback.blockOnReadRssi?(peripheral, RSSI, error)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if self.callback.blockOnDidWriteValueForCharacteristic != nil {
            self.callback.blockOnDidWriteValueForCharacteristic?(characteristic, error)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if self.callback.blockOnDidWriteValueForDescriptor != nil {
            self.callback.blockOnDidWriteValueForDescriptor?(descriptor, error)
        }
    }
}

enum WTBTType: Int {
    case BT_BLE = 0
    case BT_HC
}
