//
//  ViewControllerCreate3.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/07/05.
//  Copyright © 2019 sea&see. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerCreate3: UIViewController {
    
    // coredata 設定 ------------------------------------------------------------------------------------------------------------------------
    
    // 永続的にデータが保存されている場所みたいな マネージドオブジェクトコンテキスト
    var MOCT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // 保存ボタン押された時
    @IBAction func addBtn(_ sender: Any) {
        for x in 0 ..< ArrayTextField.count {
            //フィールドで作ったマネージドオブジェクトコンテキスト内にData型のマネージドオブジェクトを作る
            let newObject = SData(context: self.MOCT)
            //新規オブジェクトのそれぞれのプロパティに上書き
            // [0]総尾数　[1]カゴ入り　[2]商品とカゴ重量　[3]カゴ重量　[4]水引き　[5]商品重量　[6]平均重量
            // [1]カゴ入り 数字と文字があるから -> 1.0入    入を消す
            var moji = String(ArrayTextField[x][1].text!)
            if let range = moji.range(of: "入") {
                moji.replaceSubrange(range, with: "")
                ArrayTextField[x][1].text = moji
            }
            
            newObject.allNum = Double(ArrayTextField[x][0].text ?? "") ?? 0
            newObject.num = Double(ArrayTextField[x][1].text ?? "") ?? 0
            newObject.allWei = Double(ArrayTextField[x][2].text ?? "") ?? 0
            newObject.cageWei = Double(ArrayTextField[x][3].text ?? "") ?? 0
            newObject.waterCut = Double(ArrayTextField[x][4].text ?? "") ?? 0
            newObject.proWei = Double(ArrayTextField[x][5].text ?? "") ?? 0
            newObject.average = Double(ArrayTextField[x][6].text ?? "") ?? 0
            // 行き先 生産者
            newObject.destination = destination.text
            newObject.producer = producer.text
            // 保存日付
            newObject.date = dateLabel.text
        }
        //appdelegateのsaveContextメソッドを使って保存
        //saveContextは現在のマネージドオブジェクトの変更内容をDBに反映する
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    
    
    // 本体 ---------------------------------------------------------------------------------------------------------------------------------
    
    // ViewControllerCreate2Viewから  名前のデータ配列　カゴのデータの配列  商品のデータ配列
    // [0]カゴの重さ  [1]カゴの個入り　[2]カゴの数
    var BoxAllData = [[String]]()
    // [0]商品の重さ  [1]カゴの個入り　[2]半端数
    var productAllData = [[String]]()
    // [0]行き先　[1]生産者  <- 保存する
    var NameData = [String]()
    
    
    // 日付ラベル
    @IBOutlet weak var dateLabel: UILabel!
    // 行き先　生産者 テキストフィールド
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var producer: UITextField!
    
    // 全てのテキストフィールドをまとめて管理配列
    var ArrayTextField = [[UITextField]]()
    
    
    // 初期動作 ------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController(上のバー)の戻るボタン消す
        self.navigationItem.hidesBackButton = true
        
        print("カゴのデータ \(BoxAllData) ")
        print("鯛のデータ \(productAllData) ")
        print("名前のデータ \(NameData)")
        
        
        //現在の日付を取得
        let date:Date = Date()
        //日付のフォーマットを指定する。
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        //日付をStringに変換する
        let sDate = format.string(from: date)
        dateLabel.text = sDate
        print(sDate)
        
        
        // 行き先　生産者　表示
        destination.text = NameData[0]
        producer.text = NameData[1]
        
        
        // 何個入りのカゴ使われたか確認
        // 今回使われた何個入りをまとめる
        var QuantityCheck = [Int]()
        for list in productAllData[1]{
            // 同じ個数入りあるかどうか
            var flag = false
            for check in QuantityCheck {
                if Int(list) == check {
                    flag = true
                    break
                }
            }
            // 同じ個数入りがなければ追加
            if flag == false && list != ""{
                QuantityCheck.append(Int(list) ?? 0)
            }
        }
        print("個数配列の")
        print(QuantityCheck)
        
        
        
        // 列 ヘッダー
        for x in 1  ... 7{
            let Thead = UILabel()
            switch x {
            case 1:
                Thead.text = String("総尾数")
            case 2:
                Thead.text = String("カゴ入")
            case 3:
                Thead.text = String("総重量")
            case 4:
                Thead.text = String("カゴ")
            case 5:
                Thead.text = String("水引き")
            case 6:
                Thead.text = String("商品重量")
            case 7:
                Thead.text = String("平均")
            default:
                Thead.text = String()
            }
            Thead.backgroundColor = UIColor.white
            Thead.frame = CGRect(x: x*100-40, y: 50+330, width: 80, height: 30)
            Thead.textAlignment = NSTextAlignment.center
            Thead.textColor = UIColor.black
            self.view.addSubview(Thead)
        }
        
        
        // 中身
        // 一列のデータをまとめる
        // [0]総尾数　[1]カゴ入り　[2]商品とカゴ重量　[3]カゴ重量　[4]水引き　[5]商品重量　[6]平均重量
        var ColumnData = [Double]()
        
        // y 列
        for y in 0 ..< QuantityCheck.count{
            
            ColumnData = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,]
            // 列のテキストフィールドをまとめる配列 テキストフィールドの中が変更されてもいいように
            var ColumnTextField = [UITextField]()
            
            // x 行
            for x in 1...7 {
                // 値表示TextField
                let TField = UITextField()
                TField.frame = CGRect(x: x*100-40, y: (y+1)*35+400, width: 80, height: 30)
                TField.backgroundColor = UIColor.white
                TField.textAlignment = NSTextAlignment.center
                TField.textColor = UIColor.black
                // キーボードは数字のみ
                TField.keyboardType = UIKeyboardType.numberPad
                switch x{
                case 1: // 総尾数の計算
                    var count = 0
                    for list in productAllData[1]{
                        // 同じ個数入りの総尾数を求めるから  個数確認の配列から照合する
                        if Int(list) == QuantityCheck[y] {
                            if productAllData[2][count] == "" {
                                ColumnData[0] += Double(QuantityCheck[y])
                            }else{ // 半端数の時
                                ColumnData[0] += Double(productAllData[2][count]) ?? 0
                            }
                        }
                        count += 1
                    }
                    TField.text = String(ColumnData[0])
                    ColumnTextField.append(TField)
                    break
                case 2: // 個入り
                    ColumnData[1] = Double(QuantityCheck[y])
                    TField.text = "\(String(ColumnData[1]))入"
                    ColumnTextField.append(TField)
                    break
                case 3: // 商品とかごの総重量
                    var count = 0
                    for list in productAllData[1]{
                        // 同じ個数入りの総重量を求めるから  個数確認の配列から照合する
                        if Int(list) == QuantityCheck[y] {
                            ColumnData[2] += Double(productAllData[0][count]) ?? 0
                        }
                        count += 1
                    }
                    TField.text = String(ColumnData[2])
                    ColumnTextField.append(TField)
                    break
                case 4: // カゴ総重量
                    var count = 0
                    for list in BoxAllData[1]{
                        // 同じ個数入りの総重量を求めるから  個数確認の配列から照合する
                        if Int(list) == QuantityCheck[y] {
                            ColumnData[3] += Double(BoxAllData[0][count]) ?? 0
                        }
                        count += 1
                    }
                    TField.text = String(ColumnData[3])
                    ColumnTextField.append(TField)
                    break
                case 5: // 水引き
                    ColumnData[4] = 0.96
                    TField.text = String(ColumnData[4])
                    ColumnTextField.append(TField)
                    break
                case 6: // 商品だけの総重量
                    ColumnData[5] = (ColumnData[2] - ColumnData[3]) * ColumnData[4]
                    TField.text = String(ColumnData[5])
                    ColumnTextField.append(TField)
                    break
                case 7: // 商品だけの平均
                    ColumnData[6] = ColumnData[5] / Double(ColumnData[0])
                    TField.text = String(ColumnData[6])
                    ColumnTextField.append(TField)
                    break
                default:
                    TField.text = String("error")
                    ColumnTextField.append(TField)
                }
                self.view.addSubview(TField)
                
                // 間の記号
                let Tmark = UILabel()
                Tmark.frame = CGRect(x: x*100+35, y: (y+1)*35+400, width: 30, height: 30)
                switch x{
                case 1:
                    Tmark.text = String()
                case 2:
                    Tmark.text = String("(")
                case 3:
                    Tmark.text = String("-")
                case 4:
                    Tmark.text = String(")")
                case 5:
                    Tmark.text = String("=")
                case 6:
                    Tmark.text = String("[")
                case 7:
                    Tmark.text = String("]")
                default:
                    Tmark.text = String()
                }
                Tmark.textAlignment = NSTextAlignment.center
                Tmark.textColor = UIColor.black
                self.view.addSubview(Tmark)
                
            }
            // 全てのテキストフィールドを管理する配列に格納
            ArrayTextField.append(ColumnTextField)
        }
        print("送信する")
        
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
