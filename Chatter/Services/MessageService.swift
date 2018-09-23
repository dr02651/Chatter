//
//  MessageService.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/22/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    // Variables
    private(set) var channels = [Channel]()
    private(set) var messages = [Message]()
    private(set) var selectedChannel: Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                if let json = JSON(data: data).array {
                    for item in json {
                        let id = item["_id"].stringValue
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        
                        let channel = Channel(id: id, channelTitle: name, channelDescription: channelDescription)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func addToChannelArray(_ channel: Channel) {
        channels.append(channel)
    }
    
    func addToMessagesArray(_ message: Message) {
        messages.append(message)
    }
    
    func setSelectedChannel(to channel: Channel) {
        selectedChannel = channel
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
}


// MARK: Getting messages
extension MessageService {
    
    func findAllMessages(forChannelId id: String, completion: @escaping CompletionHandler ) {
        
        Alamofire.request("\(URL_GET_MESSAGES)\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else {return}
                if let json = JSON(data: data).array {
                    for item in json {
                        let id = item["_id"].stringValue
                        let message = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let newMessage = Message(message: message, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(newMessage)
                    }
                    completion(true)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}
















