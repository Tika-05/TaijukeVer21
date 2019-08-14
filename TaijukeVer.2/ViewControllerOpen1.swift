//
//  ViewControllerOpen1.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/08/06.
//  Copyright © 2019 sea&see. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerOpen1: UIViewController {
    
    // coredata 設定 ------------------------------------------------------------------------------------------------------------------------
    
    //EntityのSData型の配列を宣言   SDataEntityから引っ張ってきたデータを入れるためSData型にしておく
    var Sdata:[SData] = []

    // 永続的にデータが保存されている場所みたいな マネージドオブジェクトコンテキスト
    var MOCT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //NSFetchRequestを使って「任意のEntityの全データを取得する」という取得条件を変数に打ち込む
    let conditionsData = NSFetchRequest<NSFetchRequestResult>(entityName: "SData")
    
    func readCoreData(){
        do{
            //マネージドオブジェクトコンテキストのfetchに先ほどの取得条件を食わせて、返ってきたデータをSData型に強制ダウンキャスト
            //取得したデータを入れる
            Sdata = try MOCT.fetch(conditionsData) as! [SData]
        }catch{
            print("エラーだよ")
        }
    }
    
    // coredata のデータを消す
    func deleteCoreData(array : [String]){
        //属性date,destination,producerが検索文字列と一致するデータをフェッチ対象にする。 (SQLみたいに)
        conditionsData.predicate = NSPredicate(format:"date = %@ and destination = %@ and producer = %@", array[0], array[1], array[2])
        do {
            //取得したデータを入れる 消すデータ
            let Ddata = try MOCT.fetch(conditionsData) as! [SData]
            for task in Ddata{
                // データ消す
                MOCT.delete(task)
            }
        } catch {
            print("Fetching Failed.")
        }
        // 削除したあとのデータを保存する
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    
    
    // 本体 ---------------------------------------------------------------------------------------------------------------------------------
    
    // 表示するTableView
    @IBOutlet weak var tableView: UITableView!
    
    // tableview に表示する配列
    var tableV = [[String]]()
    
    // 送る配列   (日付　行き先　生産者)
    var OpenCheck : [String] = ["","",""]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController(上のバー)の戻るボタン消す
        self.navigationItem.hidesBackButton = true
        // ナビゲーションバー透明にする  (なんかぜんViewに反映されている？)
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()

        
        // coredataの準備
        readCoreData()
        
        
        // 日付　行き先　生産者 同じものはまとめたいから
        for data in Sdata {
            // 同じ 日付　行き先　生産者 あるかどうか
            var flag = false
            for list in tableV{
                if data.date == list[0] && data.destination == list[1] && data.producer == list[2]{
                    flag = true
                    break
                }
            }
            if flag == false {
                tableV.append([data.date!,data.destination!,data.producer!])
            }
        }
        print(tableV)
    }
    
    // 画面遷移する時？
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 別のView に送信
        // "toOpen2ViewSegue"の名前の遷移のとき発動
        if (segue.identifier == "toOpen2ViewSegue") {
            // ViewControllerCreate2 の変数を持ってくる？
            let vc: ViewControllerOpen2 = segue.destination as! ViewControllerOpen2
            vc.OpenCheck = OpenCheck
        }
        
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
        return tableV.count
    }
    
    // Cell選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたセルの行番号を出力
        print("\(indexPath.row)番目の行が選択されました。")
        print(tableV[indexPath.row][0])
        print(tableV[indexPath.row][1])
        print(tableV[indexPath.row][2])
        //送る配列に格納
        OpenCheck[0] = tableV[indexPath.row][0]
        OpenCheck[1] = tableV[indexPath.row][1]
        OpenCheck[2] = tableV[indexPath.row][2]
    }
    
    // セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        // セルに表示する値を設定する
        cell.DateLabel.text = tableV[indexPath.row][0]
        cell.DestinationLabel.text = tableV[indexPath.row][1]
        cell.ProducerLabel.text = tableV[indexPath.row][2]
        
        return cell
    }
    
    // 行の挿入または削除をコミットするようにデータソースに要求する時に発動
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // セルが編集可能な状態(削除可能）な時
        if editingStyle == .delete {
            // 選択中のCellにあるLabelを保存配列から消す
            tableV.remove(at: indexPath.row)
            // 洗濯中のCellを削除
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // coredata のデータを消す
            deleteCoreData(array: tableV[indexPath.row])
        }
    }
}
