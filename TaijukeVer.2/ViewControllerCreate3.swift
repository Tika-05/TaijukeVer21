//
//  ViewControllerCreate3.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/07/05.
//  Copyright © 2019 sea&see. All rights reserved.
//

import UIKit

class ViewControllerCreate3: UIViewController {
    
    // ViewControllerCreate2Viewから  カゴのデータの配列  商品のデータ配列
    // [0]カゴの個入り　[1]行き先の名前　[2]カゴの数
    var BoxAllData = [[String]]()
    // [0]商品の個入り　[1]行き先の名前　
    var productAllData = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController(上のバー)の戻るボタン消す
        self.navigationItem.hidesBackButton = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
