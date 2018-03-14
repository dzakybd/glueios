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
    let defaults = Defaults()
    var issigned = false
    var foto = String()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func buttonakunclick(_ sender: Any) {
        if(issigned){
            self.performSegue(withIdentifier: "menu_to_editmember", sender: self)
        }else{
            self.performSegue(withIdentifier: "menu_to_login", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menu_to_editmember"  {
            if let navController = segue.destination as? UINavigationController {
                if let childVC = navController.topViewController as? EditMember {
                    childVC.own = true
                    childVC.create = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonakun.layer.cornerRadius = 5
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SampleMenuViewController.tapDetected))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)

        let wid = avatarImageView.frame.size.width/2
        avatarImageView.layer.cornerRadius = wid
        
        if defaults.has(Key<User>(Keys.saved_user)){
            issigned=true
            let akun = defaults.get(for: Key<User>(Keys.saved_user))!
            avatarImageView.sd_setImage(with: URL(string: akun.user_thumbnail), placeholderImage: UIImage(named: "icon"))
            buttonakun.setTitle(" fa:edit Ubah akun", for: .normal)
            labelnama.text = akun.user_nama
            labelemail.text = akun.user_email
            foto = akun.user_foto
            labelakses.text = Keys.UserAksesName(kode: akun.user_akses)
        }
        buttonakun.parseIcon()
    }
    
    @objc func tapDetected() {
       var photo:SKPhoto
        if foto.isEmpty {
            photo = SKPhoto.photoWithImage(UIImage(named: "icon")!)
        }else{
            photo = SKPhoto.photoWithImageURL(self.foto)
            photo.shouldCachePhotoURLImage = false
        }
        var images = [SKPhoto]()
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
        var title = ""
        switch cell.titleLabel.text! {
        case "Navigation Home News":
            icon="newspapero"
            title="News"
        case "Navigation Home Member":
            icon="users"
            title="Member"
        case "Navigation Home Chat":
            icon="comment"
            title="Chat"
        case "Navigation Home Near Me":
            icon="locationarrow"
            title="Near me"
        case "Wilayah & Universitas":
            icon="university"
            title="Wilayah & Universitas"
        default:
            icon="newspaper"
        }
        
        cell.titleLabel.font = UIFont.icon(from: .FontAwesome, ofSize: cell.titleLabel.font.pointSize)
        cell.titleLabel.text = String.fontAwesomeIcon(icon)! + " " + title
        
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
