//
//  HomeNews.swift
//  Glue
//
//  Created by Macbook Pro on 30/01/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import SDWebImage
import Alamofire
import DefaultsKit
import PopupDialog
import JGProgressHUD
import SwiftIconFont

class HomeNews: UIViewController, SideMenuItemContent, UICollectionViewDelegate, UICollectionViewDataSource, FilterProtocol {
   
    @IBOutlet weak var newscollection: UICollectionView!
    var beritas = [Event]()
    var akun = User()
    let defaults = Defaults()
    var admin:Bool = false
    var notregistered:Bool = true
    var parameters = [String: String]()
    var index = Int()
    var create = Bool()
    var filtered = false
    
    @IBOutlet weak var addbutton: UIBarButtonItem!
   
    func sharedfilter(data: [String: String], used: Bool) {
        parameters = [String: String]()
        parameters = data
        filtered = used
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !filtered {
            parameters = [String: String]()
        }
        getdata()
        filtered = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beritas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewsCell
        
        cell.image.sd_setImage(with: URL(string: beritas[indexPath.row].event_thumbnail), placeholderImage: UIImage(named: "icon"))
        
        cell.judul.text = beritas[indexPath.row].event_judul
        cell.lokasi.font = UIFont.icon(from: .FontAwesome, ofSize: cell.lokasi.font.pointSize)
        cell.tanggal.font = UIFont.icon(from: .FontAwesome, ofSize: cell.tanggal.font.pointSize)
        cell.lokasi.text = String.fontAwesomeIcon("mapo")! + " " + beritas[indexPath.row].event_lokasi
        cell.tanggal.text = String.fontAwesomeIcon("calendaro")! + " " + beritas[indexPath.row].event_tanggal
        
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))

        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let indexa = self.newscollection.indexPathForItem(at: sender.location(in: self.newscollection))
        self.index = (indexa?.row)!
        self.create = false
        self.performSegue(withIdentifier: "homenews_to_editnews", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newscollection.dataSource = self
        
        if defaults.has(Key<User>(Keys.saved_user)) {
            akun = defaults.get(for: Key<User>(Keys.saved_user))!
            if akun.user_akses == "0" || akun.user_akses == "1" {
                admin = true
            }
            if !akun.user_email.isEmpty {
                notregistered = false
            }
        }
        
        if !admin {
            addbutton.title = ""
            addbutton.isEnabled = false
            addbutton.tintColor = UIColor.clear
        }
        newscollection.addSubview(refreshControl)
        
        getdata()
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.flatYellow
        
        return refreshControl
    }()
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getdata()
        refreshControl.endRefreshing()
    }
    
    func getdata(){
        
        parameters[Keys.mode] = Keys.read
        parameters[Keys.user_nrp] = akun.user_nrp
        
        if !admin {
            parameters[Keys.event_published] = "1"
        }
        if notregistered{
            parameters[Keys.event_internal] = "0"
        }
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Memuat"
        hud.show(in: self.view)
        Alamofire.request(Keys.URL_CRUD_EVENT, method:.post, parameters:parameters).responseJSON { response in
            hud.dismiss()
            self.beritas = [Event]()
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                for element in arrJson {
                    let data = Event()
                    data.Populate(dictionary: element as! NSDictionary)
                    self.beritas.append(data)
                }
                self.newscollection.reloadData()
            case .failure( _):
                let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        showSideMenu()
    }
    
    @IBAction func addclick(_ sender: Any) {
        create = true
        performSegue(withIdentifier: "homenews_to_editnews", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homenews_to_newsfilter"  {
            if let vc = segue.destination as? NewsFilter {
                    vc.delegate = self
                    vc.admin = admin
            }
        }
        else if segue.identifier == "homenews_to_editnews"  {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? EditNews {
                    childVC.create = create
                    if !create {
                        childVC.berita = beritas[index]
                    }
                }
            }
        }
    }
}
