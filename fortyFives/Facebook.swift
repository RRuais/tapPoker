//
//  Facebook.swift
//  fortyFives
//
//  Created by Rich Ruais on 10/6/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON


class Facebook {
    func getFBInfo(completion: @escaping (_ success: Bool) -> Void) {
        let parameters = ["fields": "id, name, first_name, last_name, age_range, link, gender, locale, timezone, picture, updated_time, verified"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: parameters)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(String(describing: error))")
            }
            else {
                var accessToken = FBSDKAccessToken.current().tokenString
                let data = JSON(result!)
                let profileImageUrl = data["picture"]["data"]["url"].stringValue
                let name = data["name"].stringValue
                print("FACEBOOK \(name)     \(profileImageUrl)")
                let defaults:UserDefaults = UserDefaults.standard
                defaults.set(name, forKey: "facebookName")
                defaults.set(profileImageUrl, forKey: "facebookImage")
            }
            completion(true)
        })
    }
}
