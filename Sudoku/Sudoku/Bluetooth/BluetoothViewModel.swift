//
//  BluetoothViewModel.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/10.
//  Copyright © 2022 Cdts. All rights reserved.
//

import SwiftUI
import Foundation
import CoreBluetooth
import Combine

final class BluetoothViewModel: ObservableObject {
//
//    @Published var state: CBManagerState = .unknown {
//        didSet {
//            update(with: state)
//        }
//    }
//    @AppStorage("identifier") private var identifier: String = ""
//    @Published var isReady = false
    var isServer = false
//    @Published var peripheral: CBPeripheral?
    private var cenralManager = CentralManager()
    private var peripheralManager = PeripheralManager()
    
//    private lazy var manager: BluetoothManager = .shared
//    private lazy var cancellables: Set<AnyCancellable> = .init()
    
//    private var readCharacteristic: CBCharacteristic?
//    private var writeCharacteristic: CBCharacteristic?
    
    //MARK: - Lifecycle
    
    deinit {
        cenralManager.stop()
        peripheralManager.stop()
    }
    
    func start(isServer: Bool, onReady: (() -> Void)? = nil, onReceived: ((Data) -> Void)?) {
        self.isServer = isServer
        if isServer {
            cenralManager.onReady = {
                print("[BT] server ready")
                onReady?()
            }
            cenralManager.onReceived = { data in
                print("[BT] server received")
                onReceived?(data)
            }
            cenralManager.retrievePeripheral()
        } else {
            peripheralManager.onReceived = { data in
                print("[BT] client received")
                onReceived?(data)
            }
            peripheralManager.start()
        }
//        manager.stateSubject.sink { [weak self] state in
//            print(state)
//            self?.state = state
//        }
//        .store(in: &cancellables)
//        manager.start()
    }
    
    func send(data: Data) {
        if isServer {
            cenralManager.sendData(data)
        } else {
            peripheralManager.sendData(data)
        }
    }

    //MARK: - Private
    
//    private func update(with state: CBManagerState) {
//        guard peripheral == nil else {
//            return
//        }
//        guard state == .poweredOn else {
//            return
//        }
//        manager.peripheralSubject
//            .filter { $0.identifier == UUID(uuidString: self.identifier) }
//            .sink { [weak self] in self?.peripheral = $0 }
//            .store(in: &cancellables)
//        manager.scan()
//    }
//
//    func setupPeripheral() {
//
//        // Build our service.
//        // Start with the CBMutableCharacteristic.
//        let transferCharacteristic = CBMutableCharacteristic(type: BluetoothManager.Constants.characteristicUUID,
//                                                         properties: [.notify, .writeWithoutResponse],
//                                                         value: nil,
//                                                         permissions: [.readable, .writeable])
//
//        // Create a service from the characteristic.
//        let transferService = CBMutableService(type: BluetoothManager.Constants.serviceUUID, primary: true)
//
//        // Add the characteristic to the service.
//        transferService.characteristics = [transferCharacteristic]
//
//        // And add it to the peripheral manager.
//        peripheralManager.add(transferService)
//
//        // Save the characteristic for later.
//        self.transferCharacteristic = transferCharacteristic
//
//    }
//
//    func connect(with peripheral: CBPeripheral) {
//        self.peripheral = peripheral
//        manager.servicesSubject
//            .map { $0.filter { Constants.serviceUUIDs.contains($0.uuid) } }
//            .sink { services in
//                services.forEach { service in
//                    peripheral.discoverCharacteristics(nil, for: service)
//                }
//            }
//            .store(in: &cancellables)
//
//        manager.characteristicsSubject
//            .filter { $0.0.uuid == Constants.readServiceUUID }
//            .compactMap { $0.1.first(where: \.uuid == Constants.readCharacteristicUUID) }
//            .sink { [weak self] characteristic in
//                self?.readCharacteristic = characteristic
////                self?.update(StripeData.state(from: characteristic.value))
//            }
//            .store(in: &cancellables)
//
//        manager.characteristicsSubject
//            .filter { $0.0.uuid == Constants.writeServiceUUID }
//            .compactMap { $0.1.first(where: \.uuid == Constants.writeCharacteristicUUID) }
//            .sink { [weak self] characteristic in
//                self?.writeCharacteristic = characteristic
//            }
//            .store(in: &cancellables)
//
//        manager.connect(peripheral)
//    }

}

//extension Set where Element: Cancellable {
//
//    func cancel() {
//        forEach { $0.cancel() }
//    }
//}
//
//func ==<Root, Value: Equatable>(lhs: KeyPath<Root, Value>, rhs: Value) -> (Root) -> Bool {
//    { $0[keyPath: lhs] == rhs }
//}
//
//func ==<Root, Value: Equatable>(lhs: KeyPath<Root, Value>, rhs: Value?) -> (Root) -> Bool {
//    { $0[keyPath: lhs] == rhs }
//}
