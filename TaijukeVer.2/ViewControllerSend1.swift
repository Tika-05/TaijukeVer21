//
//  ViewControllerSend1.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/08/15.
//  Copyright © 2019 sea&see. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerSend1: UIViewController {

    // coredata 設定 ------------------------------------------------------------------------------------------------------------------------
    
    //EntityのSData型の配列を宣言   SDataEntityから引っ張ってきたデータを入れるためSData型にしておく
    // tableViewに表示するためのデータ
    var Sdata:[SData] = []
    // メール送信用に条件をつけたデータ
    var SendData : [SData] = []
    
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
    
    
    // coredataのデータ読み込む
    func readSendCoreData(){
        // 送信条件を設定した時に 空じゃなければ
        if !(SendCheck.isEmpty) {
            for x in 0 ..< SendCheck.count {
                //属性date,destination,producerが検索文字列と一致するデータをフェッチ対象にする。 (SQLみたいに)
                conditionsData.predicate = NSPredicate(format:"date = %@ and destination = %@ and producer = %@", SendCheck[x][0], SendCheck[x][1], SendCheck[x][2])
                // フェッチする
                do{
                    //マネージドオブジェクトコンテキストのfetchに先ほどの取得条件を食わせて、返ってきたデータをSData型に強制ダウンキャスト
                    //取得したデータを入れる
                    SendData += try MOCT.fetch(conditionsData) as! [SData]
                }catch{
                    print("エラーだよ")
                }
            }
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
    
    // メール送信したい情報データの識別用 配列   (日付　行き先　生産者)
    var SendCheck = [[String]]()

    
    // 送信ボタン 押された時
    @IBAction func sendBtn(_ sender: Any) {
        print(SendCheck)
        print("前Sdataの個数 : \(SendData.count)")
        readSendCoreData()
        print("後Sdataの個数 : \(SendData.count)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // NavigationController(上のバー)の戻るボタン消す
//        self.navigationItem.hidesBackButton = true
//        // ナビゲーションバー透明にする  (なんかぜんViewに反映されている？)
//        // 空の背景画像設定
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        // ナビゲーションバーの影画像（境界線の画像）を空に設定
//        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        // tableViewの複数選択可にする
        tableView.allowsMultipleSelection = true
        
        
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
        // 順番を逆さまにする
        tableV = Array(tableV.reversed())
        print(tableV)
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

extension ViewControllerSend1: UITableViewDelegate, UITableViewDataSource{
    
    // テーブルのセクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "   日付                                                           行き先　　　　　　　　　　　　生産者"
    }
    
    // セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableV.count
    }
    
    // Cellの選択時に
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // マークつける　選択したことわかるように
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        // タップされたセルの行番号を出力
        print("\(indexPath.row)番目の行が選択されました。")
        
        // 送信する配列へ追加する　同じものがない時
        let _set: NSSet = NSSet(array: SendCheck)
        let any = [tableV[indexPath.row][0],tableV[indexPath.row][1],tableV[indexPath.row][2]]
        if(!_set.contains(any)){
            SendCheck.append(any)
        }
    }
    
    // Cellの選択解除時に
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // マークつける　選択したことわかるように
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
        
        // 配列から特定の値消す
        let _set: NSSet = NSSet(array: SendCheck)
        let any = [tableV[indexPath.row][0],tableV[indexPath.row][1],tableV[indexPath.row][2]]
        if(_set.contains(any)){
            SendCheck = (SendCheck.filter {$0 != any})
        }
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
}
