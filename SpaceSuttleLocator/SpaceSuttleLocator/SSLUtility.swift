//
//  SSLUtility.swift
//  SpaceSuttleLocator
//
//  Created by neelam verma on 06/06/16.
//  Copyright © 2016 Exilant. All rights reserved.
//

import UIKit

class SSLUtility: NSObject {

    //MARK: Shared Instance
    class var sharedInstance: SSLUtility {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SSLUtility? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SSLUtility()
        }
        return Static.instance!
    }

    private override init() {
        
    }
    
    //MARK: Error Alerts
    func showAlert(titileStr :String,messageStr:String,preferredStyle:UIAlertControllerStyle,target:UIViewController,onActionhandler:((UIAlertAction) ->Void)?)
    {
        
        let alertController = UIAlertController(title: titileStr, message: messageStr, preferredStyle:
            preferredStyle)
        
        alertController.addAction(UIAlertAction(title: Constant.Others.Ok, style: UIAlertActionStyle.Cancel, handler: onActionhandler))
        
        if target.presentedViewController == nil {
            target.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
