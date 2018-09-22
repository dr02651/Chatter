//
//  Utils.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/20/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let BASE_URL = "https://chatter--app.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel"

// Headers
let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]
let BEARER_HEADER = [
"Authorization" : "Bearer \(AuthService.instance.authToken)",
"Content-Type" : "application/json; charset=utf-8"
]

let LOGIN_SEGUE = "goToLogin"
let TO_CREATE_ACCT = "goToCreate"
let UNWIND = "unwindToChannel"
let SHOW_ICONS = "showIcons"
let BACK_TO_CREATE_ACCT = "backToCreateAcct"
let UNWIND_TO_EDIT = "unwindToEditModal"


// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


// Colors
let CHATTER_PLACEHOLDER_COLOR = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 0.5043075771)

// Notification Constants
let NOTIF_USER_DATA_CHANGED = Notification.Name("notifUserDataChanged")





