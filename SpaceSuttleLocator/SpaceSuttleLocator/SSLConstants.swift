//
//  SSLConstants.swift
//  SpaceSuttleLocator
//
//  Created by neelam verma on 06/06/16.
//  Copyright © 2016 Exilant. All rights reserved.
//

import UIKit

struct Constant {
    
    struct Path {
        static let SpaceShuttlePath = "http://api.open-notify.org/iss-now.json"
    }
    
    struct MapConstants {
        static let ApiKey = "AIzaSyBP7GDcZnWvOBCGzczIJ2IuWxoSeXGpqCw"
        static let Position = "iss_position"
        static let SpaceShuttlelatitude = "latitude"
        static let SpaceShuttlelongitude = "longitude"
    }

    
    struct HttpMethod {
        static let GET = "GET"
    }
    
    struct ImageName {
        static let SpaceShuttle = "spaceShuttle"
   
    }
    
    struct Others {
        static let Error = "Error"
        static let Unknown = "Unknown"
        static let Ok = "OK"
    }
    
    
    
}