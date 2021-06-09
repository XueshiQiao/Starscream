//
//  StreamTaskTransporter.swift
//  Starscream
//
//  Created by joey on 2021/4/3.
//  Copyright © 2021 Vluxe. All rights reserved.
//

import Foundation

@available(iOSApplicationExtension 11.0, *)
class StreamTaskTransport: NSObject, Transport, URLSessionStreamDelegate {
    private var urlSession: URLSession?
    private var streamTask: URLSessionStreamTask?
    private var delegate: TransportEventClient?
    private var url: URL?
    private var certificatePinning: CertificatePinning?
    private var isTLS = false
    private var multipathServiceType: URLSessionConfiguration.MultipathServiceType = .none
    private let queue = DispatchQueue(label: "com.vluxe.starscream.stream-task-transport", attributes: [])

    
    public var usingTLS: Bool {
        return self.isTLS
    }
    
    @available(iOSApplicationExtension 11.0, *)
    public init(multipathServiceType: URLSessionConfiguration.MultipathServiceType = .none) {
        self.multipathServiceType = multipathServiceType
        super.init()
    }
    
    @available(iOSApplicationExtension 11.0, *)
    func connect(url: URL, timeout: Double, certificatePinning: CertificatePinning?) {
        guard let parts = url.getParts() else {
            delegate?.connectionChanged(state: .failed(TCPTransportError.invalidRequest))
            return
        }
        self.isTLS = parts.isTLS

        let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.multipathServiceType = .interactive //.handover//multipathServiceType
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: nil)
        streamTask = urlSession?.streamTask(withHostName: parts.host, port: parts.port)
        streamTask?.resume()
        self.delegate?.connectionChanged(state: .connected)
        
        readLoop();
    }
    
    private func readLoop() {
        queue.async {
            self.streamTask?.readData(ofMinLength: 1, maxLength: 100, timeout: 0, completionHandler: { [weak self](data, eof, error) in
                if let data = data {
                    print("=====transport receive data(\(data.count) bytes): \(String(data: data, encoding: .utf8) ?? "")")
                    self?.delegate?.connectionChanged(state: .receive(data))
                    self?.readLoop()
                }
                
                if eof {
                    self?.delegate?.connectionChanged(state: .cancelled)
                }
                
                if let error = error {
                    self?.delegate?.connectionChanged(state: .failed(error))
                }
            })
        }
    }
    
    func disconnect() {
        self.streamTask?.cancel()
        self.streamTask?.closeRead()
        self.streamTask?.closeWrite()
    }
    
    func write(data: Data, completion: @escaping ((Error?) -> ())) {
        self.streamTask?.write(data, timeout: 10, completionHandler: { (error) in
            print("======transport write completed, error: \(String(describing: error))")
            completion(error)

            if let error = error {
                self.delegate?.connectionChanged(state: .failed(error))
            }
        })
    }
    

    func register(delegate: TransportEventClient) {
        self.delegate = delegate
    }
    
    
    //MARK: - URLSessionStreamDelegate
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("=========transport delegate didBecomeInvalidWithError")
    }

    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("=========transport delegate  didReceive challenge")

    }
    //MARK: - URLSessionStreamDelegate
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        print("=========transport delegate readClosedFor streamTask")

    }
    
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        print("=========transport delegate writeClosedFor streamTask")

    }
    
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        print("=========transport delegate betterRouteDiscoveredFor streamTask")

    }
    
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        print("=========transport delegate streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream")

    }

}
