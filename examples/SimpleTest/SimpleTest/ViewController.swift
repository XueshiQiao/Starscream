//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright © 2014 Vluxe. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let err = server.start(address: "localhost", port: 8080)
//        if err != nil {
//            print("server didn't start!")
//        }
//        server.onEvent = { event in
//            switch event {
//            case .text(let conn, let string):
//                let payload = string.data(using: .utf8)!
//                conn.write(data: payload, opcode: .textFrame)
//            default:
//                break
//            }
//        }
        //https://echo.websocket.org
//        var request = URLRequest(url: URL(string: "http://123.56.13.45:8080")!) //https://localhost:8080
//        var request = URLRequest(url: URL(string: "https://123.56.13.45:8080")!) 
        
        var request = URLRequest(url: URL(string: "wss://echo.websocket.org")!)

        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
        DispatchQueue.global().asyncAfter(deadline: .now()+5) {
//            let a = NWSystemPathMonitor.shared()?.fallbackWatcher
//            let b = NWSystemPathMonitor.shared()?.mptcpWatcher
//            let c = NWSystemPathMonitor.shared()?.isWiFiPrimary
            print("hello")
        }
    }
    
    // MARK: - WebSocketDelegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](timer) in
                self?.socket.write(string: "t:\(Date().timeIntervalSince1970)")
            })
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(_ sender: UIBarButtonItem) {
        socket.write(string: "hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
            self.timer = nil
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
}

