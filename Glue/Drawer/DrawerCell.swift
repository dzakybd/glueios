

import UIKit

class DrawerCell: UITableViewCell {

    @IBOutlet weak var lblController: UILabel!
    @IBOutlet weak var imgController: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
