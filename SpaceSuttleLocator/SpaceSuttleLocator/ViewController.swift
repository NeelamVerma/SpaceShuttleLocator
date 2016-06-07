//
//  ViewController.swift
//  SpaceSuttleLocator
//
//  Created by neelam verma on 04/06/16.
//  Copyright © 2016 Exilant. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController,GMSMapViewDelegate {
    
    @IBOutlet weak var spaceLocatorMap: GMSMapView!
    
    // Animating the mapview to the current spaceshuttle position for first time.
    var isStarted : Bool = false
    
    // Shuttle Icon Marker
    let marker = GMSMarker()
    
    // Closures for Repeatedly location update for Shuttle
    typealias  RepeatCompletionHandler = (isRepeat:Bool) -> Void
    typealias RepeatBlock = (completionHandler:RepeatCompletionHandler) -> Void

    
    //MARK: View Related Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        spaceLocatorMap.delegate = self
        self.marker.map = self.spaceLocatorMap
        self.marker.icon = UIImage(named: Constant.ImageName.SpaceShuttle)
        
        // Repeatedly location update for Shuttle
        self.dispatchRepeat(1) { (completionHandler) in
            completionHandler(isRepeat: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Repeatedly location update for Shuttle
    func dispatchRepeat(seconds: Int64, repeatClosure withClosure:RepeatBlock) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
            withClosure(completionHandler: { (isRepeat) in
                if isRepeat == true
                {
                    self.locateSpaceShuttle()
                    return self.dispatchRepeat(seconds, repeatClosure: withClosure)
                }
            })
        }
        
    }
    
    
    //MARK: Locating the Space Shuttle
    func locateSpaceShuttle()  {
        SSLWebServices.sharedInstance.getCordinatesOfShuttle { (cordinate,error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                guard (cordinate != nil)   else
                {
                    if let locationerror = error
                    {
                        if locationerror.localizedFailureReason != nil
                        {
                            SSLUtility.sharedInstance.showAlert(Constant.Others.Error, messageStr: locationerror.localizedFailureReason!, preferredStyle: UIAlertControllerStyle.Alert, target: self, onActionhandler: nil)
                        }
                    }
                    return
                }
                
                
                self.marker.position = cordinate!
                if self.isStarted == false
                {
                    self.spaceLocatorMap.animateToLocation(self.marker.position)
                }
                self.isStarted = true
                
            }
        }
    }
    
    
    //MARK: Google Map Delegate - Tap on Marker Icon
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool
    {
        SSLWebServices.sharedInstance.getCurrentCityNameForSpaceShuttle(marker.position) { (cityName, error) in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                guard (cityName != nil)   else
                {
                    if let locationerror = error
                    {
                        if locationerror.localizedFailureReason != nil
                        {
                            SSLUtility.sharedInstance.showAlert(Constant.Others.Error, messageStr: locationerror.localizedFailureReason!, preferredStyle: UIAlertControllerStyle.Alert, target: self, onActionhandler: nil)
                        }
                    }
                    else
                    {
                        marker.title = Constant.Others.Unknown
                        self.spaceLocatorMap.selectedMarker = marker
                    }
                    return
                }
                
                marker.title = cityName! as String
                self.spaceLocatorMap.selectedMarker = marker
                
            }
        }
        
        return true
    }
    
    //MARK: Action for relocating the map to marker positon
    @IBAction func reLocateMapviewToShuttlePosition(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.spaceLocatorMap.animateToLocation(self.marker.position)
            
        }
        
    }
}

