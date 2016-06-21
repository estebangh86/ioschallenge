//
//  ViewController.swift
//  KnomaticChallenge
//
//  Created by Esteban Garcia Henao on 6/20/16.
//  Copyright © 2016 Esteban Garcia Henao. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController, UICollectionViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentIconView: UIImageView!
    @IBOutlet weak var currentPlaceLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var precipProbabiltyLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    let API_KEY = "0f90af924c56801b6b6cef1eff31bba2"
    let SERVICE_URL = "https://api.forecast.io/forecast"
    
    var timeZone: String!
    var daily = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            setupLocationManager()
        }
        
        setupGUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Initial setup methods
    
    func setupLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupGUI() {
        
        currentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    // MARK: LocationManager methods
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            
            getLocation()
        }
    }
    
    func getLocation() {
        
        SVProgressHUD.showWithStatus("Loading...")
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations.first!
        
        locationManager.stopUpdatingLocation()
        SVProgressHUD.dismissWithDelay(1)
        
        callAPI(userLocation.coordinate)
    }
    
    func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                
                let placemark = placemarks![0]
                
                if let addressDictionary = placemark.addressDictionary {
                    
                    if let city = addressDictionary["City"], state = addressDictionary["State"], name = addressDictionary["Name"] {
                        
                        self.navigationBar.topItem?.title = "\(city), \(state)"
                        self.currentPlaceLabel.text = name as? String
                    }
                }
            }
        })
    }
    
    // MARK: API call, response parsing and UI updating
    
    func callAPI(coordinate: CLLocationCoordinate2D) {
        
        reverseGeocode(coordinate.latitude, longitude: coordinate.longitude)
        
        let latitude = "\(coordinate.latitude)"
        let longitude = "\(coordinate.longitude)"
        
        let url = "\(SERVICE_URL)/\(API_KEY)/\(latitude),\(longitude)"
        
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    self.parse(json)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func parse(response: JSON) {
        
        let currently = response["currently"]
        
        timeZone = response["timezone"].stringValue
        
        let date = convertUnix(currently["time"].double!, dateFormat: "EEEE, MMM d")
        
        updateCurrentGUI(currently, date: date)
        
        daily = response["daily"]["data"].array!
        collectionView.reloadData()
    }
    
    func updateCurrentGUI(currently: JSON, date: String) {
        
        currentTempLabel.text = formatTemperature(currently["temperature"].intValue)
        currentIconView.image = UIImage(named: currently["icon"].stringValue)
        
        currentDateLabel.text = date
        
        windSpeedLabel.text = "\(currently["windSpeed"].intValue) MPH"
        windDirectionLabel.text = translateWind(currently["windBearing"].intValue)
        precipProbabiltyLabel.text = formatPrecipitation(currently["precipProbability"].floatValue)
    }
    
    // MARK: Formatting, conversion and translation methods
    
    func formatTemperature(temperature: Int) -> String {
        
        return "\(temperature)°"
    }
    
    func formatPrecipitation(probability: Float) -> String {
        
        return "\(Int(probability * 100))%"
    }
    
    func convertUnix(time: Double, dateFormat: String) -> String {
        
        let time = NSDate(timeIntervalSince1970: time)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: timeZone)
        dateFormatter.locale = NSLocale(localeIdentifier: "en-US")
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.stringFromDate(time)
    }
    
    func translateWind(direction: Int) -> String {
        
        if (direction > 315 || direction <= 45) {
            
            return "NORTH"
        }
        else if (direction > 45 || direction <= 135) {
            
            return "EAST"
        }
        else if (direction > 135 || direction <= 225) {
            
            return "SOUTH"
        }
        else {
            
            return "WEST"
        }
    }
    
    // MARK: CollectionView delegate methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return daily.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let day = daily[indexPath.row]
        
        let viewCell = collectionView.dequeueReusableCellWithReuseIdentifier("DayCell", forIndexPath: indexPath)
        
        let dayLabel = viewCell.viewWithTag(1) as! UILabel
        dayLabel.text = convertUnix(day["time"].double!, dateFormat: "EEE")
        
        let dayIcon = viewCell.viewWithTag(2) as! UIImageView
        dayIcon.image = UIImage(named: day["icon"].stringValue)
        
        let tempLabel = viewCell.viewWithTag(3) as! UILabel
        tempLabel.text = formatTemperature(day["temperatureMax"].intValue)
        
        return viewCell
    }
    
    // MARK: UI interaction

    @IBAction func refreshTouched(sender: AnyObject) {
        
        getLocation()
    }

}

