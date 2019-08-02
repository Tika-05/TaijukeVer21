// CoustomTableViewCell.swift
//
// Cell -> Indentifier "Cell" 名前つける
// Cell -> class "CoustomTableViewCell" に設定
// Referencing Outlet -> CoustomTableViewCell.swift へ接続
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // Cell内の値が入るLabel
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var BoxLabel: UILabel!
    
    @IBOutlet weak var productLabel2: UILabel!
    @IBOutlet weak var QuantityLabel2: UILabel!
    @IBOutlet weak var NameLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
