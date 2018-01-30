
import UIKit

class DrawerController: UIViewController, DrawerControllerDelegate {

    var drawerVw = DrawerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pushTo(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func actShowMenu(_ sender: Any) {
        drawerVw = DrawerView(aryControllers:DrawerArray.array, isBlurEffect:false, isHeaderInTop:true, controller:self)
        drawerVw.delegate = self
        
        //**** OPTIONAL ****//
        // Can change GradientColor of background view, text color, user name text color, font, username
        drawerVw.changeProfilePic(img: #imageLiteral(resourceName: "proPicTwo.png"))
        drawerVw.changeGradientColor(colorTop: UIColor(red:0.788, green: 0.078, blue: 0.435, alpha: 1.00), colorBottom: UIColor(red:0.929, green: 0.204, blue: 0.165, alpha: 1.00))
        drawerVw.changeCellTextColor(txtColor: UIColor.white)
        drawerVw.changeUserNameTextColor(txtColor: UIColor.lightText)
//        drawerVw.changeFont(font: UIFont(name:"Avenir Next", size:18)!)
        drawerVw.changeUserName(name: "Josep Vijay")
        drawerVw.show()
    }
}

// 7.Struct for add storyboards which you want show on navigation drawer
struct DrawerArray {
    static let array:NSArray = ["MyAccount", "Offers", "History","Offers", "Language", "Settings", "History"]
}
