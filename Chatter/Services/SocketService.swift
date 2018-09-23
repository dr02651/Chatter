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
    
    
    
}

//MARK: Adding channels ##############################################################################
extension SocketService {
    
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
            
            let newChannel = Channel(id: channelId, channelTitle: channelName, channelDescription: channelDescription)
            MessageService.instance.addToChannelArray(newChannel)
            completion(true)
        }
    }
}

//MARK: Adding messages ##############################################################################
extension SocketService {
    
    func addMessagesWith(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
}

//MARK: Getting messages ##############################################################################
extension SocketService {
    
    func getMessages(completion: @escaping CompletionHandler) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let messageId = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            if channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: messageId, timeStamp: timeStamp)
                MessageService.instance.addToMessagesArray(newMessage)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}


//MARK: Getting typing users ##############################################################################
extension SocketService {
    
    func gettypingUsers(_ completionHandler: @escaping (_ typingUsers: [String:String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String:String] else {return}
            completionHandler(typingUsers)
        }
    }
}
















