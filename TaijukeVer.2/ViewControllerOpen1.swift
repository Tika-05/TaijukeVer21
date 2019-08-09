//
//  ViewControllerOpen1.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/08/06.
//  Copyright © 2019 sea&see. All rights reserved.
//

import UIKit

class ViewControllerOpen1: UIViewController {

    
    @IBOutlet weak var f1: UITextField!
    @IBOutlet weak var f2: UITextField!
    @IBOutlet weak var f3: UITextField!
    
    // csvファイルの中身を格納する配列
    var csvLines = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cscファイル開くために探す　ファイルのパス　ファイル形式
        guard let path = Bundle.main.path(forResource:"dataList", ofType:"csv") else {
            print("csvファイルがないよ")
            return
        }
        
        // csvファイル取り出す
        // csvファイルが空なら失敗
        do {
            // csvファイルの中身をStrrin型へ変更
            let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            // 改行ごとに配列に格納する
            csvLines = csvString.components(separatedBy: .newlines)
            // 改行で最後の列は何も書かれてなくていらないから消す
            csvLines.removeLast()
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
        
        // 表示する
        for DataList in csvLines {
            // コンマごとに配列に格納する
            let data = DataList.components(separatedBy: ",")
            print("【ゲーム名】\(data[0])　【伝説ポケモン】\(data[1]) 様　【地方】\(data[2]) 地方")
        }
        
        
        // テキストフィールドに表示する
        f1.text = csvLines[0]
        f2.text = csvLines[1]
        f3.text = csvLines[2]
        
        
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
