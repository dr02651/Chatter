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

let LOGIN_SEGUE = "goToLogin"
let TO_CREATE_ACCT = "goToCreate"
let UNWIND = "unwindToChannel"


// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
