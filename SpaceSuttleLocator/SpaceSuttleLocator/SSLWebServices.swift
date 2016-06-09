//
//  SSLWebServices.swift
//  SpaceSuttleLocator
//
//  Created by neelam verma on 06/06/16.
//  Copyright © 2016 Exilant. All rights reserved.
//

import UIKit
import GoogleMaps


class SSLWebServices: NSObject {
    

    //MARK: Common API for GET Results
    static func getResults(fetchURL: String, completionHandler: (NSData?, NSError?) -> ()) {
        
        let sslURL = NSURL(string: fetchURL)
        var request : NSMutableURLRequest?
        var task : NSURLSessionTask?
        
        if let spaceShuttleURL = sslURL
        {
            request = NSMutableURLRequest(URL:spaceShuttleURL)
        }
        
        if let fetchRequest = request
        {
            fetchRequest.HTTPMethod = Constant.HttpMethod.GET
            task = NSURLSession.sharedSession().dataTaskWithRequest(fetchRequest) { data, response, error in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    guard data != nil else {
                        completionHandler(nil, error)
                        return
                    }
                    completionHandler(data, nil)
                    
                }
            }
            
            if let resultTask = task
            {
                resultTask.resume()
            }
        }
        
    }
    
    
    //MARK: Get Cordinates Of Shuttle
    static func getCordinatesOfShuttle(completionhandler:((CLLocationCoordinate2D?,NSError?) -> Void)) {
        
        getResults(Constant.Path.SpaceShuttlePath) { (data, error) in
            
            guard data != nil else {
                completionhandler(nil,error)
                return
            }
            
            do
            {
                if let cordinateData = data
                {
                    if let responseData : NSDictionary = try NSJSONSerialization.JSONObjectWithData(cordinateData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    {
                        if let positinDict = responseData.valueForKey(Constant.MapConstants.Position) as? NSDictionary
                        {
                            if let lattitude = positinDict.valueForKey(Constant.MapConstants.SpaceShuttlelatitude) as? CLLocationDegrees, logitude = positinDict.valueForKey(Constant.MapConstants.SpaceShuttlelongitude) as? CLLocationDegrees
                            {
                                let cordinate =  CLLocationCoordinate2D.init(latitude: lattitude, longitude: logitude)
                                completionhandler(cordinate,nil)
                            }
                        }
                    }
                }
                
            }
            catch let responseDataError as NSError {
                
                completionhandler(nil,responseDataError)
            }
            
            
        }
    }
    
    //MARK: Get Current City Name For Space Shuttle
    static func getCurrentCityNameForSpaceShuttle(cordinates : CLLocationCoordinate2D , completionhandler:((String?,NSError?) -> Void)) {
        
        let geoCoder = GMSGeocoder()
        // GMSReverseGeocodeResponse
        
        geoCoder.reverseGeocodeCoordinate(cordinates) { (response, error) in
            
            guard response != nil else {
                completionhandler(nil,error)
                return
            }

            if let dataResponse = response
            {
                if let address = dataResponse.firstResult()
                {
                    if let administrativeArea = address.administrativeArea, country = address.country
                    {
                        let area =  administrativeArea + ", " + country
                        completionhandler(area,nil)
                    }
                    else if let country = address.country
                    {
                        completionhandler(country,nil)
                    }
                }
            }
            
        }
        
    }
    
    
    
}
