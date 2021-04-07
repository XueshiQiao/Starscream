//
//  NetworkMonitor.swift
//  SimpleTest
//
//  Created by Joey on 2020/10/29.
//  Copyright © 2020 vluxe. All rights reserved.
//

import Foundation
import Network

//limited mainly by NWNetwork.framework
@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
@objc class NetworkMonitor: NSObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "network_monitor")

    @objc func monitor(with completion: @escaping (([String]) -> Void)) {
        NSLog("start update")
        monitor.pathUpdateHandler = { [weak self] path in
            let availbaleInterfaceTypes = path.availableInterfaces.map { (interface) -> String in
                return "path status: \(path.status), expensive: \(path.isExpensive),  interface: name: \(interface.name), type: \(String(describing: interface.type)), index: \(interface.index)"
            }
            NSLog("availbaleInterfaceTypes: \(availbaleInterfaceTypes)")

            let current = self?.monitor.currentPath
            print("current path: \(current)")
            
            //只检查一次，检查完之后就退出
//            self?.monitor.cancel()
//            completion(availbaleInterfaceTypes)
        }
        
        monitor.start(queue: queue)
    }
}

@available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
extension NWInterface.InterfaceType : CustomStringConvertible {
    public var description: String {
        switch self {
        case .wifi:
            return "Wi-Fi"
        case .cellular:
            return "Cellular"
        case .loopback:
            return "Loopback"
        case .wiredEthernet:
            return "Wired"
        case .other:
            return "Other"
        default:
            return "Default"
        }
    }
}




