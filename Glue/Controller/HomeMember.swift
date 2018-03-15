//
//  HomeMember.swift
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

class HomeMember: UIViewController, SideMenuItemContent, UICollectionViewDelegate, UICollectionViewDataSource, FilterProtocol {
    
    var akuns = [User]()
    var akun = User()
    let defaults = Defaults()
    var admin:Bool = false
    var notregistered:Bool = true
    var parameters = [String: String]()
    var index = Int()
    var create = Bool()
    var filtered = false
    
    @IBOutlet weak var addbutton: UIBarButtonItem!
    @IBOutlet weak var membercollection: UICollectionView!
    
    func sharedfilter(data: [String : String], used: Bool) {
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
    
    func getdata(){
        parameters[Keys.mode] = Keys.read
        parameters[Keys.user_nrp] = akun.user_nrp
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Memuat"
        hud.show(in: self.view)
        Alamofire.request(Keys.URL_CRUD_USER, method:.post, parameters:parameters).responseJSON { response in
            hud.dismiss()
            self.akuns = [User]()
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                for element in arrJson {
                    let data = User()
                    data.Populate(dictionary: element as! NSDictionary)
                    self.akuns.append(data)
                }
                self.membercollection.reloadData()
            case .failure( _):
                let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let indexa = self.membercollection.indexPathForItem(at: sender.location(in: self.membercollection))
        self.index = (indexa?.row)!
        create = false
        self.performSegue(withIdentifier: "homemember_to_editmember", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return akuns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MemberCell
        
        let wid = cell.image.frame.size.width/2
        cell.image.layer.cornerRadius = wid
        let foto = akuns[indexPath.row].user_thumbnail
        if !foto.isEmpty{
            cell.image.sd_setImage(with: URL(string: foto), placeholderImage: UIImage(named: "icon"))
        }
        cell.nama.text = akuns[indexPath.row].user_nama
        cell.kta.text = "Nomor Anggota : " + akuns[indexPath.row].user_no_kta
        cell.universitas.text = "Universitas : " + akuns[indexPath.row].universitas_nama
        
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        membercollection.dataSource = self
        
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
        membercollection.addSubview(refreshControl)
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homemember_to_memberfilter"  {
            if let vc = segue.destination as? MemberFilter {
                vc.delegate = self
                vc.admin = admin
            }
        }
        else if segue.identifier == "homemember_to_editmember"  {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? EditMember {
                    childVC.create = create
                    childVC.user_akses = akun.user_akses
                    if !create {
                        childVC.akun = akuns[index]
                    }
                }
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
        self.performSegue(withIdentifier: "homemember_to_editmember", sender: self)
    }
}
