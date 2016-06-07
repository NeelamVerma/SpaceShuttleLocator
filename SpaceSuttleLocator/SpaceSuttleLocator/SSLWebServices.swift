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
    
    //MARK: Shared Instance
    class var sharedInstance: SSLWebServices {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SSLWebServices? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SSLWebServices()
        }
        return Static.instance!
    }
    
    private override init() {
        
    }
    

    //MARK: Common API for GET Results
    func getResults(fetchURL: String, completionHandler: (NSData?, NSError?) -> ()) -> NSURLSessionTask {
        
        let sslURL = NSURL(string: fetchURL)!;
        let request = NSMutableURLRequest(URL:sslURL);
        request.HTTPMethod = Constant.HttpMethod.GET;
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                guard data != nil else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(data, nil)
                
            }
        }
        
        task.resume()
        return task
    }
    
    
    //MARK: Get Cordinates Of Shuttle
    func getCordinatesOfShuttle(completionhandler:((CLLocationCoordinate2D?,NSError?) -> Void)) {
        
        getResults(Constant.Path.SpaceShuttlePath) { (data, error) in
            
            guard data != nil else {
                completionhandler(nil,error)
                return
            }
            
            do
            {
                if let responseData : NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                {
                    let positinDict = responseData.valueForKey(Constant.MapConstants.Position) as! NSDictionary
                    let cordinate =  CLLocationCoordinate2D.init(latitude: positinDict.valueForKey(Constant.MapConstants.SpaceShuttlelatitude) as! CLLocationDegrees, longitude: positinDict.valueForKey(Constant.MapConstants.SpaceShuttlelongitude) as! CLLocationDegrees)
                    completionhandler(cordinate,nil)
                }
            }
            catch let responseDataError as NSError {
                
                completionhandler(nil,responseDataError)
            }
            
            
        }
    }
    
    //MARK: Get Current City Name For Space Shuttle
    func getCurrentCityNameForSpaceShuttle(cordinates : CLLocationCoordinate2D , completionhandler:((String?,NSError?) -> Void)) {
        
        let geoCoder = GMSGeocoder()
        // GMSReverseGeocodeResponse
        
        geoCoder.reverseGeocodeCoordinate(cordinates) { (response, error) in
            
            guard response != nil else {
                completionhandler(nil,error)
                return
            }

            if let address = response!.firstResult()
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
