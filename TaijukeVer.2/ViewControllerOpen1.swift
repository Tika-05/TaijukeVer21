//
//  ViewControllerOpen1.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/08/06.
//  Copyright © 2019 sea&see. All rights reserved.
//

import UIKit

class ViewControllerOpen1: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var Sdata = [["7/1","あれ","あの"],["7/2","これ","この"],["7/3","それ","その"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
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


// TabelView 表示 ---------------------------------------------------------------------------------------------------------------------------

extension ViewControllerOpen1: UITableViewDelegate, UITableViewDataSource{
    
    // テーブルのセクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "   日付                                                           行き先　　　　　　　　　　　　生産者"
    }
    
    // セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sdata.count
    }
    
    // Cell選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたセルの行番号を出力
        print("\(indexPath.row)番目の行が選択されました。")
        print(Sdata[indexPath.row][0])
        print(Sdata[indexPath.row][1])
        print(Sdata[indexPath.row][2])
    }
    
    // セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        // セルに表示する値を設定する
        cell.DateLabel.text = Sdata[indexPath.row][0]
        cell.DestinationLabel.text = Sdata[indexPath.row][1]
        cell.ProducerLabel.text = Sdata[indexPath.row][2]
        
        return cell
    }
    
//    // 行の挿入または削除をコミットするようにデータソースに要求する時に発動
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        // セルが編集可能な状態(削除可能）な時
//        if editingStyle == .delete {
//            // 選択中のCellにあるLabelを保存配列から消す
//            WeightData.remove(at: indexPath.row)
//            QuantityData.remove(at: indexPath.row)
//            AnyProductData.remove(at: indexPath.row)
//            // 洗濯中のCellを削除
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
}
