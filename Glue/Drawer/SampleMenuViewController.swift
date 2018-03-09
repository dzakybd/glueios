//
// SampleMenuViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import InteractiveSideMenu
import SwiftIconFont
import ChameleonFramework
import SDWebImage
import SKPhotoBrowser
import DefaultsKit

/**
 Menu controller is responsible for creating its content and showing/hiding menu using 'menuContainerViewController' property.
 */
class SampleMenuViewController: MenuViewController, Storyboardable {

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet weak var buttonakun: UIButton!
    @IBOutlet weak var labelnama: UILabel!
    @IBOutlet weak var labelemail: UILabel!
    @IBOutlet weak var labelakses: UILabel!
    @IBOutlet weak var imageprofile: UIImageView!
    let defaults = Defaults()
    var issigned = false
    var foto = String()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func buttonakunclick(_ sender: Any) {
        if(issigned){
            self.performSegue(withIdentifier: "ubahakunsegue", sender: self)
        }else{
            self.performSegue(withIdentifier: "loginsegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ubahakunsegue"  {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? UbahAkun {
                    childVC.own = true
                    childVC.create = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let defa = UserDefaults.standard
//        defa.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        buttonakun.layer.cornerRadius = 5
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SampleMenuViewController.tapDetected))
        imageprofile.isUserInteractionEnabled = true
        imageprofile.addGestureRecognizer(tapGestureRecognizer)
        
        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)

        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        
        if defaults.has(Key<User>(Keys.saved_user)){
            issigned=true
            let akun = defaults.get(for: Key<User>(Keys.saved_user))!
            imageprofile.sd_setImage(with: URL(string: akun.user_thumbnail))
            buttonakun.setTitle(" fa:edit Ubah akun", for: .normal)
            labelnama.text = akun.user_nama
            labelemail.text = akun.user_email
            foto = akun.user_foto
            labelakses.text = Keys.UserAksesName(kode: akun.user_akses)
        }
        buttonakun.parseIcon()
    }
    
    @objc func tapDetected() {
        var images = [SKPhoto]()
        var photo:SKPhoto
        if foto.isEmpty {
            photo = SKPhoto.photoWithImage(UIImage(named: "icon")!)
        }else{
            photo = SKPhoto.photoWithImageURL(foto)
        }
        photo.shouldCachePhotoURLImage = false
        images.append(photo)
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: Keys.gradcolors)
    }

    deinit{
        print()
    }
}

extension SampleMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuContainerViewController?.contentViewControllers.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SampleTableCell.self), for: indexPath) as? SampleTableCell else {
            preconditionFailure("Unregistered table view cell")
        }
        
        cell.titleLabel.text = menuContainerViewController?.contentViewControllers[indexPath.row].title ?? "A Controller"
        
        var icon = ""
        switch cell.titleLabel.text! {
        case "News":
            icon="newspapero"
        case "Member":
            icon="users"
        case "Chat":
            icon="comment"
        case "Near me":
            icon="locationarrow"
        default:
            icon="newspaper"
        }
        cell.titleLabel.font = UIFont.icon(from: .FontAwesome, ofSize: cell.titleLabel.font.pointSize)
        cell.titleLabel.text = String.fontAwesomeIcon(icon)! + " " + cell.titleLabel.text!
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        menuContainerViewController.hideSideMenu()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}
