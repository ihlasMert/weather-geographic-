//
//  ViewController.swift
//  CLMARSS
//
//  Created by ihlas on 17.01.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    @IBOutlet var cityNameLabel: UILabel!
    
    @IBOutlet var weatherDescriptionLabel: UILabel!
    
    @IBOutlet var tempratureLabel: UILabel!
    
    @IBOutlet var weatherIconImageView: UIImageView!
    
    
    
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
    }
    
    func startLocationManager(){
        locationManager.requestWhenInUseAuthorization() //
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    func updateView(){
        cityNameLabel.text = weatherData.name
        weatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
        tempratureLabel.text = weatherData.main.tem.description + "O"
        weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)

            
    }
    func updateWeatherInfo(latitude: Double, longtitude: Double){
        let session = URLSession.shared
        let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&units=metric&lang=ru&APPID=e3702d4768471b630d784638e6e8b477")!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else{
                print("DataTask error: \(error!.localizedDescription)")
                return
            
        }
        do{
            self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
            DispatchQueue.main.async {
                self.updateView()
            }
        }catch{
            print(error.localizedDescription)
            
        }
    }
task.resume()
}


}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocaiton = locations.last{
            updateWeatherInfo(latitude: lastLocaiton.coordinate.latitude, longtitude: lastLocaiton.coordinate.longitude)
        }
    }


}
