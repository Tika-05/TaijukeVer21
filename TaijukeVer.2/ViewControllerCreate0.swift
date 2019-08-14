//
//  ViewControllerCreate0.swift
//  TaijukeVer.2
//
//  Created by Kota Takagi on 2019/07/19.
//  Copyright © 2019 sea&see. All rights reserved.
//

//トキヤ参上致した
// コウタ乱入した


import UIKit

class ViewControllerCreate0: UIViewController {
    
    // 行先設定
    // ピッカー画面
    var vi: UIView = UIView()
    // 名前選択用配列
    var arrayPickName : [String] = ["","羽山","川島","マルタ","丸銀"]
    // 選択中の入力する行先
    @IBOutlet weak var selectName: UITextField!
    // 生産者
    @IBOutlet weak var selectName2: UITextField!
    
    
    // 名前選択ボタン押した時発動
    @IBAction func NameSelectClick(_ sender: Any) {
        // 今開いてるpicker画面を消す
        vi.removeFromSuperview()
        // 名前選択用ピッカー作成
        namePickerCreate()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController(上のバー)の戻るボタン消す
        self.navigationItem.hidesBackButton = true
        // ナビゲーションバー透明にする  (なんかぜんViewに反映されている？)
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像（境界線の画像）を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()

        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 送る配列   (行き先　生産者)
        var NameData = [String]()
        NameData.append(selectName.text ?? "")
        NameData.append(selectName2.text ?? "")
        
        // 別のView に送信
        // "toCreate2ViewSegue"の名前の遷移のとき発動
        if (segue.identifier == "toCreate1ViewSegue") {
            // ViewControllerCreate2 の変数を持ってくる？
            let vc: ViewControllerCreate1 = segue.destination as! ViewControllerCreate1
            vc.NameData = NameData
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



// pickerの設定 ------------------------------------------------------------------------------------------------------------------------------

extension ViewControllerCreate0: UIPickerViewDelegate, UIPickerViewDataSource{

    // UIPickerViewDataSource
    // 表示する列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // アイテム表示個数を指定する
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayPickName.count
    }

    // UIPickerViewDelegate
    //表示する文字列を指定する
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return arrayPickName[row]
    }
    // 選択時の処理 (選択されている値)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        // カゴ個数のTextFieldに入れる
        selectName.text = arrayPickName[row]
    }



    func namePickerCreate(){

        // 名前選択時のピッカーView
        let pickerView2: UIPickerView = UIPickerView()
        // ピッカーの位置やサイズ
        pickerView2.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: pickerView2.bounds.size.height)
        // ピッカーするべき設定
        pickerView2.delegate = self
        pickerView2.dataSource = self

        pickerView2.tag = 2
        pickerView2.showsSelectionIndicator = true
        pickerView2.backgroundColor = UIColor(red: 203.0 / 255.0, green: 230.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
        // デフォルト設定　（始めにさす所）
        pickerView2.selectRow(0, inComponent: 0, animated: false)

        // ピッカーを表示する画面
        vi = UIView(frame: pickerView2.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(pickerView2)

        // ピッカーのツールバー
        let toolBar = UIToolbar()
        // ツールバー設定
        toolBar.frame = CGRect(x: 0, y: 0, width: 320, height: 40)
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ViewControllerCreate2.doneButtonTapped))
        // ツールバー追加
        toolBar.items = [spacer, doneButton]
        // 画面に追加
        vi.addSubview(toolBar)

        // viをviewに追加し、下からアニメーション表示
        view.addSubview(vi)
        let screenSize = UIScreen.main.bounds.size
        vi.frame.origin.y = screenSize.height
        UIView.animate(withDuration: 0.3) {
            self.vi.frame.origin.y = screenSize.height - self.vi.bounds.size.height * 2
        }

    }
    // 閉じるボタンが押されたらキーボードを閉じる
    @objc func doneButtonTapped (){
        // picker画面を消す
        vi.removeFromSuperview()
    }
}

