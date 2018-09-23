//
//  SocketService.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/22/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    
    let manager: SocketManager
    let socket: SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        super.init()
    }
    
    // Establish socket server connection
    func establishConnection() {
        socket.connect()
    }
    
    // Closes socket server connection
    func closeConnection() {
        socket.disconnect()
    }
    
    // Emit - Add channel
    func addChannelWith(name: String, description: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", name, description)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel = Channel(id: channelId, __v: nil, channelTitle: channelName, channelDescription: channelDescription)
            MessageService.instance.addToChannelArray(newChannel)
            completion(true)
        }
    }
    
}


















