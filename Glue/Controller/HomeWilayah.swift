//
//  HomeWilayah.swift
//  Glue
//
//  Created by Macbook Pro on 11/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog
import JGProgressHUD
import InteractiveSideMenu
import DefaultsKit

class HomeWilayah: UIViewController, UITableViewDelegate, UITableViewDataSource, SideMenuItemContent {
    
    var wilayahs = [Wilayah]()
    var index = Int()
    var create = Bool()
    
    @IBOutlet weak var wilayahtable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wilayahs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wilayahtable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WilayahUnivCell
        cell.label.text = wilayahs[indexPath.row].wilayah_nama
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let indexa = self.wilayahtable.indexPathForRow(at: sender.location(in: self.wilayahtable))
        self.index = (indexa?.row)!
        self.create = false
        self.performSegue(withIdentifier: "homewilayah_to_editwilayah", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wilayahtable.dataSource = self
        wilayahtable.addSubview(refreshControl)
        getdata()

    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getdata()
        refreshControl.endRefreshing()
    }
    
    func getdata(){
        let parameters = [Keys.mode: Keys.read]
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Memuat"
        hud.show(in: self.view)
        Alamofire.request(Keys.URL_CRUD_WILAYAH, method:.post, parameters:parameters).responseJSON { response in
            hud.dismiss()
            self.wilayahs = [Wilayah]()
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                for element in arrJson {
                    let data = Wilayah()
                    data.Populate(dictionary: element as! NSDictionary)
                    self.wilayahs.append(data)
                }
                self.wilayahtable.reloadData()
            case .failure( _):
                let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.flatYellow
        
        return refreshControl
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homewilayah_to_editwilayah"  {
            if let vc = segue.destination as? EditWilayah {
                vc.create = create
                if !create {
                    vc.wilayah = wilayahs[index]
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
        performSegue(withIdentifier: "homewilayah_to_editwilayah", sender: self)
    }
}
