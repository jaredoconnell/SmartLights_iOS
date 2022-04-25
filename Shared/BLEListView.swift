//
//  BLEListView.swift
//  SmartLights
//
//  Created by Jared O'Connell on 4/24/22.
//

import SwiftUI

struct BLEListView: View {
    @ObservedObject var bleManager = BLEManager()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Bluetooth Controllers")
            List(bleManager.peripherals.values) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(String(peripheral.rssi))
                }
            }
            if !bleManager.isSwitchedOn {
                Text("Bluetooth is switched off")
                    .foregroundColor(.red)
            }
            HStack (spacing: 10) {
                Button(action: {
                    self.bleManager.startScanning()
                }) {
                    Text("Start Scanning")
                }
                Button(action: {
                    self.bleManager.stopScanning()
                }) {
                    Text("Stop Scanning")
                }
            }
        }
    }
}

struct BLEListView_Previews: PreviewProvider {
    static var previews: some View {
        BLEListView()
    }
}
