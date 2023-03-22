//
//  WTBLECallback.swift
//  
//
//  Created by Prem Pratap Singh on 22/03/23.
//

import Foundation
import CoreBluetooth

typealias WTCentralManagerDidUpdateStateBlock = (CBCentralManager) -> Void
typealias WTDiscoverPeripheralsBlock = (CBCentralManager, CBPeripheral, [String : Any], NSNumber) -> Void
typealias WTConnectedPeripheralBlock = (CBCentralManager, CBPeripheral) -> Void
typealias WTFailToConnectBlock = (CBCentralManager, CBPeripheral, Error?) -> Void
typealias WTDisconnectBlock = (CBCentralManager, CBPeripheral, Error?) -> Void
typealias WTDiscoverServicesBlock = (CBPeripheral, Error?) -> Void
typealias WTDiscoverCharacteristicsBlock = (CBPeripheral, CBService, Error?) -> Void
typealias WTReadValueForCharacteristicBlock = (CBPeripheral, CBCharacteristic, Error?) -> Void
typealias WTDiscoverDescriptorsForCharacteristicBlock = (CBPeripheral, CBCharacteristic, Error?) -> Void
typealias WTReadValueForDescriptorsBlock = (CBPeripheral, CBDescriptor, Error?) -> Void
typealias WTDidWriteValueForCharacteristicBlock = (CBCharacteristic, Error?) -> Void
typealias WTDidWriteValueForDescriptorBlock = (CBDescriptor, Error?) -> Void
typealias WTReadRssiBlock = (CBPeripheral, NSNumber, Error?) -> Void

class WTBLECallback {
    var blockOnCentralManagerDidUpdateState: WTCentralManagerDidUpdateStateBlock?
    var blockOnDiscoverPeripherals: WTDiscoverPeripheralsBlock?
    var blockOnConnectedPeripheral: WTConnectedPeripheralBlock?
    var blockOnFailToConnect: WTFailToConnectBlock?
    var blockOnDisconnect: WTDisconnectBlock?
    var blockOnDiscoverServices: WTDiscoverServicesBlock?
    var blockOnDiscoverCharacteristics: WTDiscoverCharacteristicsBlock?
    var blockOnReadValueForCharacteristic: WTReadValueForCharacteristicBlock?
    var blockOnDiscoverDescriptorsForCharacteristic: WTDiscoverDescriptorsForCharacteristicBlock?
    var blockOnReadValueForDescriptors: WTReadValueForDescriptorsBlock?
    var blockOnReadRssi: WTReadRssiBlock?
    var blockOnDidWriteValueForCharacteristic: WTDidWriteValueForCharacteristicBlock?
    var blockOnDidWriteValueForDescriptor: WTDidWriteValueForDescriptorBlock?
}
