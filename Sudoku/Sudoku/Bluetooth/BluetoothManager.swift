//
//  BluetoothManager.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/10.
//  Copyright © 2022 Cdts. All rights reserved.
//

import Foundation
import CoreBluetooth
import Combine
import os

final class BluetoothManager: NSObject {
    static let serviceUUID = CBUUID(string: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")
    static let characteristicUUID = CBUUID(string: "08590F7E-DB05-467E-8757-72F6FAEB13D4")
//
//    enum Constants {
//        static let readServiceUUID: CBUUID = .init(string: "FFD0")
//        static let writeServiceUUID: CBUUID = .init(string: "FFD5")
//        static let serviceUUIDs: [CBUUID] = [readServiceUUID, writeServiceUUID]
//        static let readCharacteristicUUID: CBUUID = .init(string: "FFD4")
//        static let writeCharacteristicUUID: CBUUID = .init(string: "FFD9")
//    }
//
//    static let shared: BluetoothManager = .init()
//
//    var stateSubject: PassthroughSubject<CBManagerState, Never> = .init()
//    var peripheralSubject: PassthroughSubject<CBPeripheral, Never> = .init()
//    var servicesSubject: PassthroughSubject<[CBService], Never> = .init()
//    var characteristicsSubject: PassthroughSubject<(CBService, [CBCharacteristic]), Never> = .init()
//
//    var discoveredPeripheral: CBPeripheral?
//    var transferCharacteristic: CBCharacteristic?
//
//    private var centralManager: CBCentralManager!
//    private var peripheralManager: CBPeripheralManager!
//
//    //MARK: - Lifecycle
//
//    func start() {
//        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
//        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
//
//    }
//
//    private func retrievePeripheral() {
//        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [Constants.serviceUUID]))
//
//        os_log("Found connected Peripherals with transfer service: %@", connectedPeripherals)
//
//        if let connectedPeripheral = connectedPeripherals.last {
//            os_log("Connecting to peripheral %@", connectedPeripheral)
//            self.discoveredPeripheral = connectedPeripheral
//            centralManager.connect(connectedPeripheral, options: nil)
//        } else {
//            // We were not connected to our counterpart, so start scanning
//            centralManager.scanForPeripherals(withServices: [Constants.serviceUUID],
//                                               options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//        }
//    }
//
//
//    func scan() {
//        centralManager.scanForPeripherals(withServices: [Constants.serviceUUID])
//    }
//
//    func connect(_ peripheral: CBPeripheral) {
//        centralManager.stopScan()
//        peripheral.delegate = self
//        centralManager.connect(peripheral)
//        print("Bluetooth device connected")
//    }
}


//extension BluetoothManager: CBCentralManagerDelegate {
//    // implementations of the CBCentralManagerDelegate methods
//
//    /*
//     *  centralManagerDidUpdateState is a required protocol method.
//     *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
//     *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
//     *  the Central is ready to be used.
//     */
//    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
//
//        switch central.state {
//        case .poweredOn:
//            // ... so start working with the peripheral
//            os_log("CBManager is powered on")
//            retrievePeripheral()
//        case .poweredOff:
//            os_log("CBManager is not powered on")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        case .resetting:
//            os_log("CBManager is resetting")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        case .unauthorized:
//            // In a real app, you'd deal with all the states accordingly
//            switch central.authorization {
//            case .denied:
//                os_log("You are not authorized to use Bluetooth")
//            case .restricted:
//                os_log("Bluetooth is restricted")
//            default:
//                os_log("Unexpected authorization")
//            }
//            return
//        case .unknown:
//            os_log("CBManager state is unknown")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        case .unsupported:
//            os_log("Bluetooth is not supported on this device")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        @unknown default:
//            os_log("A previously unknown central manager state occurred")
//            // In a real app, you'd deal with yet unknown cases that might occur in the future
//            return
//        }
//    }
//
//    /*
//     *  This callback comes whenever a peripheral that is advertising the transfer serviceUUID is discovered.
//     *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
//     *  we start the connection process
//     */
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
//
//        // Reject if the signal strength is too low to attempt data transfer.
//        // Change the minimum RSSI value depending on your app’s use case.
//        guard RSSI.intValue >= -50
//            else {
//                os_log("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
//                return
//        }
//
//        os_log("Discovered %s at %d", String(describing: peripheral.name), RSSI.intValue)
//
//        // Device is in range - have we already seen it?
//        if discoveredPeripheral != peripheral {
//
//            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it.
//            discoveredPeripheral = peripheral
//
//            // And finally, connect to the peripheral.
//            os_log("Connecting to perhiperal %@", peripheral)
//            centralManager.connect(peripheral, options: nil)
//        }
//    }
//
//    /*
//     *  If the connection fails for whatever reason, we need to deal with it.
//     */
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        os_log("Failed to connect to %@. %s", peripheral, String(describing: error))
//        cleanup()
//    }
//
//    /*
//     *  We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
//     */
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        os_log("Peripheral Connected")
//
//        // Stop scanning
//        centralManager.stopScan()
//        os_log("Scanning stopped")
//
//        // set iteration info
//        connectionIterationsComplete += 1
//        writeIterationsComplete = 0
//
//        // Clear the data that we may already have
//        data.removeAll(keepingCapacity: false)
//
//        // Make sure we get the discovery callbacks
//        peripheral.delegate = self
//
//        // Search only for services that match our UUID
//        peripheral.discoverServices([TransferService.serviceUUID])
//    }
//
//    /*
//     *  Once the disconnection happens, we need to clean up our local copy of the peripheral
//     */
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        os_log("Perhiperal Disconnected")
//        discoveredPeripheral = nil
//
//        // We're disconnected, so start scanning again
//        if connectionIterationsComplete < defaultIterations {
//            retrievePeripheral()
//        } else {
//            os_log("Connection iterations completed")
//        }
//    }
//
//}
//
//extension BluetoothManager: CBCentralManagerDelegate {
//
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        stateSubject.send(central.state)
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        guard RSSI.intValue >= -50 else {
//            print("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
//            return
//        }
//        peripheralSubject.send(peripheral)
//    }
//
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        peripheral.discoverServices(nil)
//    }
//}
//
//extension BluetoothManager: CBPeripheralDelegate {
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else {
//            return
//        }
//        servicesSubject.send(services)
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else {
//            return
//        }
//        characteristicsSubject.send((service, characteristics))
//    }
//}
//
//
//extension BluetoothManager: CBPeripheralManagerDelegate {
//    // implementations of the CBPeripheralManagerDelegate methods
//
//    /*
//     *  Required protocol method.  A full app should take care of all the possible states,
//     *  but we're just waiting for to know when the CBPeripheralManager is ready
//     *
//     *  Starting from iOS 13.0, if the state is CBManagerStateUnauthorized, you
//     *  are also required to check for the authorization state of the peripheral to ensure that
//     *  your app is allowed to use bluetooth
//     */
//    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//
//        advertisingSwitch.isEnabled = peripheral.state == .poweredOn
//
//        switch peripheral.state {
//        case .poweredOn:
//            // ... so start working with the peripheral
//            os_log("CBManager is powered on")
//            setupPeripheral()
//        case .poweredOff:
//            os_log("CBManager is not powered on")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        case .resetting:
//            os_log("CBManager is resetting")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        case .unauthorized:
//            // In a real app, you'd deal with all the states accordingly
//            if #available(iOS 13.0, *) {
//                switch peripheral.authorization {
//                case .denied:
//                    os_log("You are not authorized to use Bluetooth")
//                case .restricted:
//                    os_log("Bluetooth is restricted")
//                default:
//                    os_log("Unexpected authorization")
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//            return
//        case .unknown:
//            os_log("CBManager state is unknown")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        case .unsupported:
//            os_log("Bluetooth is not supported on this device")
//            // In a real app, you'd deal with all the states accordingly
//            return
//        @unknown default:
//            os_log("A previously unknown peripheral manager state occurred")
//            // In a real app, you'd deal with yet unknown cases that might occur in the future
//            return
//        }
//    }
//
//    /*
//     *  Catch when someone subscribes to our characteristic, then start sending them data
//     */
//    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
//        os_log("Central subscribed to characteristic")
//
//        // Get the data
//        dataToSend = textView.text.data(using: .utf8)!
//
//        // Reset the index
//        sendDataIndex = 0
//
//        // save central
//        connectedCentral = central
//
//        // Start sending
//        sendData()
//    }
//
//    /*
//     *  Recognize when the central unsubscribes
//     */
//    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
//        os_log("Central unsubscribed from characteristic")
//        connectedCentral = nil
//    }
//
//    /*
//     *  This callback comes in when the PeripheralManager is ready to send the next chunk of data.
//     *  This is to ensure that packets will arrive in the order they are sent
//     */
//    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
//        // Start sending again
//        sendData()
//    }
//
//    /*
//     * This callback comes in when the PeripheralManager received write to characteristics
//     */
//    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
//        for aRequest in requests {
//            guard let requestValue = aRequest.value,
//                let stringFromData = String(data: requestValue, encoding: .utf8) else {
//                    continue
//            }
//
//            os_log("Received write request of %d bytes: %s", requestValue.count, stringFromData)
//            self.textView.text = stringFromData
//        }
//    }
//}
