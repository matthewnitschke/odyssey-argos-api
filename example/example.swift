import AppKit
import CoreBluetooth

let serviceUUID = CBUUID(string: "6a521c59-55b5-4384-85c0-6534e63fb09e")
let setPointUUID = CBUUID(string: "6a521c60-55b5-4384-85c0-6534e63fb09e")
let boilerCurrentUUID = CBUUID(string: "6a521c61-55b5-4384-85c0-6534e63fb09e")
let boilerTargetUUID = CBUUID(string: "6a521c66-55b5-4384-85c0-6534e63fb09e")
let groupheadCurrentUUID = CBUUID(string: "6a521c62-55b5-4384-85c0-6534e63fb09e")
let fluidLevelUUID = CBUUID(string: "6a521c63-55b5-4384-85c0-6534e63fb09e")

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    
    var isConnected = false
    var boilerCurrent: Double = 0
    var boilerTarget: Double = 0
    var setPoint: Double = 0
    var groupheadCurrent: Double = 0
    var fluidLevel: UInt32 = 0

    func applicationDidFinishLaunching(_ notification: Notification) {                        
      centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func updateOutput() {
      updateMultilineOutput(lines: [
        "  * Set Point: \(setPoint)",
        "  * Boiler Current: \(boilerCurrent)",
        "  * Boiler Target: \(boilerTarget)",
        "  * Grouphead Current: \(groupheadCurrent)",
        "  * Fluid Level: \(fluidLevel == 0 ? "OK" : "Needs Water")"
      ])
    }

    var isFirstOutput = true
    func updateMultilineOutput(lines: [String]) {
      if (isFirstOutput) {
        isFirstOutput = false;
        for line in lines {
          print(line)
        }
        return
      }

      let count = lines.count
      print("\u{001B}[\(count)A", terminator: "")
      for line in lines {
        print("\u{001B}[K" + line)
      }
      
      fflush(stdout)
    }
}

extension AppDelegate: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
          print("Searching for \"argos\"", terminator: "")
          central.scanForPeripherals(withServices: [serviceUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name?.lowercased().starts(with: "argos") == true {
            central.stopScan()
            connectedPeripheral = peripheral
            peripheral.delegate = self
            central.connect(peripheral, options: nil)

            print("\rConnected to \"argos\" ")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        peripheral.discoverServices([serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
}

extension AppDelegate: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics([setPointUUID, boilerCurrentUUID, boilerTargetUUID, groupheadCurrentUUID, fluidLevelUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, data.count >= 4 else { return }
        
        if data.count >= 8 {
          var temp = data.withUnsafeBytes { $0.load(as: Double.self) }
          temp = (temp * 100).rounded() / 100
          
          switch characteristic.uuid {
          case setPointUUID:
            setPoint = temp
          case boilerCurrentUUID:
            boilerCurrent = temp
          case boilerTargetUUID:
            boilerTarget = temp
          case groupheadCurrentUUID:
            groupheadCurrent = temp
          default:
            break
          }
        } else if data.count == 4 {
          let value = data.withUnsafeBytes { $0.load(as: UInt32.self) }
          
          switch characteristic.uuid {
          case fluidLevelUUID:
            fluidLevel = value
          default:
            break
          }
        }
        
        updateOutput()
    }
}

app.run()