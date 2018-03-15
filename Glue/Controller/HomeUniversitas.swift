//
//  HomeUniversitas.swift
//  Glue
//
//  Created by Macbook Pro on 11/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog
import JGProgressHUD

class HomeUniversitas: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wilayah_idwilayah = String()
    var universitases = [Universitas]()
    var index = Int()
    var create = Bool()
    @IBOutlet weak var universitastable: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.flatYellow
        
        return refreshControl
    }()
    
    func getdata(){
        let parameters = [Keys.mode: Keys.read, Keys.wilayah_idwilayah: wilayah_idwilayah]
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Memuat"
        hud.show(in: self.view)
        Alamofire.request(Keys.URL_CRUD_UNIVERSITAS, method:.post, parameters:parameters).responseJSON { response in
            hud.dismiss()
            self.universitases = [Universitas]()
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                for element in arrJson {
                    let data = Universitas()
                    data.Populate(dictionary: element as! NSDictionary)
                    self.universitases.append(data)
                }
                self.universitastable.reloadData()
            case .failure( _):
                let popup = PopupDialog(title: Keys.error, message: "Server bermasalah", gestureDismissal: true)
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        
        universitastable.dataSource = self
        universitastable.addSubview(refreshControl)
        getdata()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universitases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = universitastable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WilayahUnivCell
        
        cell.label.text = universitases[indexPath.row].universitas_nama
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let indexa = self.universitastable.indexPathForRow(at: sender.location(in: self.universitastable))
        self.index = (indexa?.row)!
        self.create = false
        self.performSegue(withIdentifier: "homeuniversitas_to_edituniversitas", sender: self)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getdata()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeuniversitas_to_edituniversitas"  {
            if let vc = segue.destination as? EditUniversitas {
                vc.create = create
                if create {
                    vc.wilayah_idwilayah = wilayah_idwilayah
                }else {
                    vc.universitas = universitases[index]
                }
            }
        }
    }
    
    @IBAction func addclick(_ sender: Any) {
        create = true
        performSegue(withIdentifier: "homeuniversitas_to_edituniversitas", sender: self)
    }
}
