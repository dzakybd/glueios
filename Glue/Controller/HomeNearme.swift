//
//  HomeNearme.swift
//  Glue
//
//  Created by Macbook Pro on 30/01/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import MapKit
import DefaultsKit
import Alamofire
import PopupDialog
import JGProgressHUD

class HomeNearme: UIViewController, SideMenuItemContent {
    @IBOutlet weak var mapview: MKMapView!
    let defaults = Defaults()
    var akuns = [User]()
    var akun = User()
    var index = Int()
    var arrayannot = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview.delegate = self
        
        akun = defaults.get(for: Key<User>(Keys.saved_user))!
        getdata()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openMenu(_ sender: Any) {
        showSideMenu()
    }
    
    @IBAction func refreshclick(_ sender: Any) {
        getdata()
    }
    
    func getdata(){
        Keys.getlocation { (userlat, userlng) in
            if self.arrayannot.count>0 {
                self.mapview.removeAnnotations(self.arrayannot)
            }
        
            var arrayannot = [MKAnnotation]()
            
            var lokasi = Lokasi(title: "Anda",
                                locationName: self.akun.universitas_nama,
                                discipline: self.akun.user_akses,
                                coordinate: CLLocationCoordinate2D(latitude: Double(userlat)!, longitude: Double(userlng)!), index: -1, thumbnail: self.akun.user_thumbnail)
            self.mapview.addAnnotation(lokasi)
            arrayannot.append(lokasi)
            
            let parameters = [
                Keys.user_nrp: self.akun.user_nrp,
                Keys.user_lat: userlat,
                Keys.user_lng: userlng
            ]
            
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Memuat"
            hud.show(in: self.view)
            Alamofire.request(Keys.URL_GET_NEARME, method:.post, parameters:parameters).responseJSON { response in
                hud.dismiss()
                self.akuns = [User]()
                switch response.result {
                case .success:
                    let arrJson = response.result.value as! NSArray
                    for (index, element) in arrJson.enumerated() {
                        let data = User()
                        data.Populate(dictionary: element as! NSDictionary)
                        self.akuns.append(data)
                        lokasi = Lokasi(title: data.user_nama,
                                              locationName: data.universitas_nama,
                                              discipline: data.user_akses,
                                              coordinate: CLLocationCoordinate2D(latitude: Double(data.user_lat)!, longitude: Double(data.user_lng)!), index: index, thumbnail: data.user_thumbnail)
                        
                        
                        
                        self.mapview.addAnnotation(lokasi)
                        arrayannot.append(lokasi)
                    }
                    self.mapview.showAnnotations(arrayannot, animated: true)
                case .failure( _):
                    print(Keys.error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homenearme_to_editmember"  {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? EditMember {
                    childVC.create = false
                    childVC.user_akses = akun.user_akses
                    childVC.akun = akuns[index]
                }
            }
        }
    }
    
}

extension HomeNearme: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let lokasi = view.annotation as! Lokasi
        if lokasi.index != -1 {
            self.index = lokasi.index
            self.performSegue(withIdentifier: "homenearme_to_editmember", sender: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Lokasi else { return nil }
        // 3
        let identifier = "marker"
        var view: MKPinAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            if annotation.index == -1 {
                view.pinTintColor = .flatBlue
            }
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.clipsToBounds = true
            let wid = mapsButton.frame.size.width/2
            mapsButton.layer.cornerRadius = wid
            let foto = annotation.thumbnail
            if !foto.isEmpty{
                mapsButton.sd_setImage(with: URL(string: foto), for: UIControlState())
            }
            view.rightCalloutAccessoryView = mapsButton
        }
        return view
    }
}

class Lokasi: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let index: Int
    let thumbnail: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, index: Int, thumbnail: String) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.thumbnail = thumbnail
        self.index = index
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

