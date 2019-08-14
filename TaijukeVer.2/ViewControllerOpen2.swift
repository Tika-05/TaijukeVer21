//
//  ViewControllerOpen2.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/08/14.
//  Copyright © 2019 sea&see. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerOpen2: UIViewController {
    
    // coredata 設定 ------------------------------------------------------------------------------------------------------------------------
    
    //EntityのSData型の配列を宣言   SDataEntityから引っ張ってきたデータを入れるためSData型にしておく
    // allNum:総尾数　num:カゴ入り　allWei:商品とカゴ重量　cageWei:カゴ重量　waterCut:水引き　proWei:商品重量　average:平均重量  date:日付　destination:行き先　producer:生産者
    var Sdata:[SData] = []
    // 永続的にデータが保存されている場所みたいな マネージドオブジェクトコンテキスト
    var MOCT = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func readCoreData(){
        // 開く条件を設定した時に 前のViewで
        if(OpenCheck[0] != "") {
            //NSFetchRequestを使って「任意のEntityの全データを取得する」という取得条件を変数に打ち込む
            let conditionsData = NSFetchRequest<NSFetchRequestResult>(entityName: "SData")
            //属性date,destination,producerが検索文字列と一致するデータをフェッチ対象にする。 (SQLみたいに)
            conditionsData.predicate = NSPredicate(format:"date = %@ and destination = %@ and producer = %@", OpenCheck[0], OpenCheck[1], OpenCheck[2])
            // フェッチする
            do{
                //マネージドオブジェクトコンテキストのfetchに先ほどの取得条件を食わせて、返ってきたデータをSData型に強制ダウンキャスト
                //取得したデータを入れる
                Sdata = try MOCT.fetch(conditionsData) as! [SData]
            }catch{
                print("エラーだよ")
            }
        }
        
        
    }
    
    
    
    // 本体 ---------------------------------------------------------------------------------------------------------------------------------
    
    // 受け取る配列　coredataから持ってくるデータの条件
    var OpenCheck = [String]()

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var destinationLabel: UITextField!
    @IBOutlet weak var producerLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // coredataの準備
        readCoreData()
        
        print(OpenCheck)
        
        print(Sdata)

        // 日付 行き先　生産者 ラベル
        dateLabel.text = OpenCheck[0]
        destinationLabel.text = OpenCheck[1]
        producerLabel.text = OpenCheck[2]
        
        
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
            Thead.frame = CGRect(x: x*100-50, y: 50+200, width: 80, height: 30)
            Thead.textAlignment = NSTextAlignment.center
            Thead.textColor = UIColor.black
            self.view.addSubview(Thead)
        }
        
        
        // 中身
        // y 列
        for y in 0 ..< Sdata.count{
            // x 行
            for x in 1...7 {
                // 値表示TextField
                let TField = UITextField()
                TField.frame = CGRect(x: x*100-50, y: (y+1)*50+250, width: 80, height: 30)
                TField.backgroundColor = UIColor.white
                TField.textAlignment = NSTextAlignment.center
                TField.textColor = UIColor.black
                switch x{
                case 1: // 総尾数
                    TField.text = String(Sdata[y].allNum)
                    break
                case 2: // 個入り
                    TField.text = "\(String(Sdata[y].num))入"
                    break
                case 3: // 商品とかごの総重量
                    TField.text = String(Sdata[y].allWei)
                    break
                case 4: // カゴ総重量
                    TField.text = String(Sdata[y].cageWei)
                    break
                case 5: // 水引き
                    TField.text = String(Sdata[y].waterCut)
                    break
                case 6: // 商品だけの総重量
                    TField.text = String(Sdata[y].proWei)
                    break
                case 7: // 商品だけの平均
                    TField.text = String(Sdata[y].average)
                    break
                default:
                    TField.text = String("error")
                }
                self.view.addSubview(TField)
                
                // 間の記号
                let Tmark = UILabel()
                Tmark.frame = CGRect(x: x*100+25, y: (y+1)*50+250, width: 30, height: 30)
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
