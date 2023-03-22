//
//  WTBLESDK.swift
//  
//
//  Created by Prem Pratap Singh on 22/03/23.
//

import Foundation

class WTBLESDK {
    
    var bleManager: WTBLECentralManager?
    var bleCallback: WTBLECallback?
    
    private static var _bleSDK: WTBLESDK?

    static func sharedInstance() -> WTBLESDK {
        if _bleSDK == nil {
            _bleSDK = WTBLESDK()
            _bleSDK?.bleManager = WTBLECentralManager()
            _bleSDK?.bleCallback = _bleSDK?.bleManager.callback
        }
        return _bleSDK!
    }
    
    func startScan() {
        bleManager.startScan()
    }

    func cancelScan() {
        bleManager.cancelScan()
    }

    func tryConnectPeripheral(_ peripheral: CBPeripheral) {
        bleManager.tryConnectPeripheral(peripheral)
    }

    func cancelConnection() {
        bleManager.cancelConnection()
    }

    func tryReceiveDataAfterConnected() {
        bleManager.tryReceiveDataAfterConnected()
    }

    func readRssi() {
        bleManager.readRssi()
    }

    func getDeviceType() -> Byte {
        return bleManager.getType()
    }

    func writeData(_ data: Data) {
        bleManager.writeData(data)
    }
}
