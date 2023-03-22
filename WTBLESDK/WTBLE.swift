//
//  WTBLE.swift
//  
//
//  Created by Prem Pratap Singh on 22/03/23.
//

import Foundation
import CoreBluetooth

public class WTBLE {
    
    public var bleManager: WTBLECentralManager?
    public var bleCallback: WTBLECallback?
    
    private static var _bleSDK: WTBLE?

    public static func sharedInstance() -> WTBLE {
        if _bleSDK == nil {
            _bleSDK = WTBLE()
            _bleSDK?.bleManager = WTBLECentralManager()
            _bleSDK?.bleCallback = _bleSDK?.bleManager?.callback
        }
        return _bleSDK!
    }
    
    func startScan() {
        self.bleManager?.startScan()
    }

    func cancelScan() {
        self.bleManager?.cancelScan()
    }

    func tryConnectPeripheral(_ peripheral: CBPeripheral) {
        self.bleManager?.tryConnectPeripheral(peripheral)
    }

    func cancelConnection() {
        self.bleManager?.cancelConnection()
    }

    func tryReceiveDataAfterConnected() {
        self.bleManager?.tryReceiveDataAfterConnected()
    }

    func readRssi() {
        self.bleManager?.readRssi()
    }

    func getDeviceType() -> WTBTType {
        guard let manager = self.bleManager else {
            return .BT_BLE
        }
        return manager.getType()
    }

    func writeData(_ data: Data) {
        self.bleManager?.writeData(data)
    }
}
