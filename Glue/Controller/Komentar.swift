//
//  Komentar.swift
//  Glue
//
//  Created by Macbook Pro on 14/03/18.
//  Copyright © 2018 Dzaky ZF. All rights reserved.
//

import UIKit
import Alamofire
import DefaultsKit
import PopupDialog
import JGProgressHUD
import SwiftIconFont

class Komentar: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var event_idevent = String()
    var komentars = [EventComment]()
    let defaults = Defaults()
    var akun = User()
    var notregistered:Bool = true
    
    @IBOutlet weak var commenttext: UITextField!
    @IBOutlet weak var commentcollection: UICollectionView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentcollection.dataSource = self
        if defaults.has(Key<User>(Keys.saved_user)) {
            akun = defaults.get(for: Key<User>(Keys.saved_user))!
            if !akun.user_email.isEmpty {
                notregistered = false
            }
        }
        
        commentcollection.addSubview(refreshControl)
        
        getdata()
    }
    
    @IBAction func sendclick(_ sender: Any) {
        if !notregistered{
            let parameters = [
                Keys.mode: Keys.create,
                Keys.event_idevent: event_idevent,
                Keys.user_nrp: akun.user_nrp,
                Keys.comment_text: commenttext.text!
            ]
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Mengirim"
            hud.show(in: self.view)
            Alamofire.request(Keys.URL_CRD_COMMENT, method:.post, parameters:parameters).responseString { response in
                print(response.result.value)
                hud.dismiss()
                switch response.result {
                case .success:
                    if response.result.value == "berhasil" {
                            self.getdata()
                    }
                case .failure( _):
                    print(Keys.error)
                }
            }
        }
    }
    
    
    func getdata(){
        let parameters = [
            Keys.mode: Keys.read,
            Keys.event_idevent: event_idevent
        ]
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Memuat"
        hud.show(in: self.view)
        Alamofire.request(Keys.URL_CRD_COMMENT, method:.post, parameters:parameters).responseJSON { response in
            hud.dismiss()
            self.komentars = [EventComment]()
            switch response.result {
            case .success:
                let arrJson = response.result.value as! NSArray
                for element in arrJson {
                    let data = EventComment()
                    data.Populate(dictionary: element as! NSDictionary)
                    self.komentars.append(data)
                    print(data.comment_text)
                }
                self.commentcollection.reloadData()
            case .failure( _):
                print(Keys.error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return komentars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentCell
        
        let wid = cell.image.frame.size.width/2
        cell.image.layer.cornerRadius = wid
        let foto = komentars[indexPath.row].user_thumbnail
        if !foto.isEmpty{
            cell.image.sd_setImage(with: URL(string: foto), placeholderImage: UIImage(named: "icon"))
        }
        
        cell.teks.text = komentars[indexPath.row].comment_text
        cell.nama.text = komentars[indexPath.row].user_nama
        cell.waktu.text = komentars[indexPath.row].comment_created
        if komentars[indexPath.row].user_nrp == akun.user_nrp {
            cell.hapus.isHidden = false
        }
        cell.hapus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))

        
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
        
        return cell
        
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let indexa = self.commentcollection.indexPathForItem(at: sender.location(in: self.commentcollection))
        
        let popup = PopupDialog(title: "Peringatan", message: "Anda yakin menghapus?", buttonAlignment: .horizontal, gestureDismissal: true)
        let buttonOne = CancelButton(title: "Batal") {
        }
        let buttonTwo = DestructiveButton(title: "Ya") {
            
            let parameters = [
                Keys.idcomment: self.komentars[(indexa?.row)!].idcomment,
                Keys.mode: Keys.delete
            ]
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = "Menghapus"
            hud.show(in: self.view)
            Alamofire.request(Keys.URL_CRD_COMMENT, method:.post, parameters:parameters).responseString { response in
                hud.dismiss()
                switch response.result {
                case .success:
                    if response.result.value == "berhasil" {
                        self.getdata()
                    }
                case .failure( _):
                    print(Keys.error)
                }
            }
            
        }
        popup.addButtons([buttonOne, buttonTwo])
        self.present(popup, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
