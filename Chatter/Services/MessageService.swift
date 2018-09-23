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
    
    private(set) var channels = [Channel]()
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                if let json = JSON(data: data).array {
                    for item in json {
                        let id = item["_id"].stringValue
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        
                        let channel = Channel(id: id, __v: nil, channelTitle: name, channelDescription: channelDescription)
                        self.channels.append(channel)
                    }
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
    
}
