//
//  Reachability.swift
//
//  Created by Vitor Hugo on 12/11/20.
//

import Foundation
import Network

final class Reachability {
    
    static let shared = Reachability()
    private let queue = DispatchQueue(label: "ReachabilityGL", qos: .background)
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() -> ConnectionType {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            
            self?.getConnectionType(path)
        }
        
        return connectionType
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else {
            connectionType = .unknown
        }
    }
}
