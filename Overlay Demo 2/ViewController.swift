//
//  ViewController.swift
//  Overlay Demo 2
//
//  Created by MacStudent on 2020-01-10.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    let places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        
        addAnnotation()
//        addPolyLine()
        addPolygon()
    }

    func addAnnotation(){
        mapView.delegate = self
        mapView.addAnnotations(places)
        
        let overlay = places.map{
            MKCircle(center: $0.coordinate, radius: 300)
        }
        mapView.addOverlays(overlay)
    }
    
    func addPolyLine(){
        let locations = places.map {$0.coordinate}
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
    }


    func addPolygon(){
        let locations = places.map {$0.coordinate}
        let polygon = MKPolygon(coordinates: locations, count: locations.count)
        mapView.addOverlay(polygon)
    }
}


extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
            
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place_2x.png")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle{
        
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.yellow
            renderer.lineWidth = 3
        return renderer
        }
        else if overlay is MKPolyline{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 3
            return renderer
            
        }
        else if overlay is MKPolygon{
             let renderer = MKPolygonRenderer(overlay: overlay)
             renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
                 renderer.strokeColor = UIColor.black
                 renderer.lineWidth = 3
            return renderer
            
        }
        return MKPolylineRenderer()
}
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Place, let title = annotation.title else {return}
    
    let alertController = UIAlertController(title: "Welcome to \(title)", message: "Have a good time in \(title)", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
    alertController.addAction(cancelAction)
        present(alertController, animated: true,completion: nil)
    }
}

