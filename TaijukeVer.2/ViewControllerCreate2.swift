//
//  ViewControllerCreate2.swift
//  TaijukeVer.2
//


import UIKit

class ViewControllerCreate2: UIViewController {
    
    // ViewControllerCreateViewからのカゴのデータの配列
    // [0]カゴの個入り　[1]行き先の名前　[2]カゴの数
    var BoxAllData = [[String]]()

    
    
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    // TableView に入るデータ
    // 半端数
    var AnyProductData : [String] = [""]
    // 個入り
    var QuantityData : [String] = [""]
    
    
    // 個入り設定
    // 個入りボタンの配列
    var arrayQuantity : [UIButton] = []
    // 個入り選択ボタン
    @IBOutlet weak var Quantity5: UIButton!
    @IBOutlet weak var Quantity6: UIButton!
    @IBOutlet weak var Quantity7: UIButton!
    @IBOutlet weak var Quantity8: UIButton!
    @IBOutlet weak var Quantity9: UIButton!
    @IBOutlet weak var Quantity10: UIButton!
    @IBOutlet weak var Quantity11: UIButton!
    @IBOutlet weak var Quantity12: UIButton!
    
    // X個入りの時 選択ボタン  入力Field
    @IBOutlet weak var QuantityX: UIButton!
    @IBOutlet weak var QuantityXField: UITextField!
    // 選択中の入力する個入り
    var selectQuantity : String = ""
    
    // 行先設定
    // ピッカー画面
    var vi: UIView = UIView()
    // 半端数選択用配列
    var arrayAnyProduct : [String] = ["","1","2","3","4","5","6","7","8","9","10","11"]
    // 選択中の入力する半端数
    @IBOutlet weak var selectAnyProduct: UITextField!
    
    
    
    
    
    
    
    
    // 個入りのボタンが押された時発動
    @IBAction func onClick(_ sender: UIButton) {
        // trueなら操作可、falseなら操作不可
        QuantityXField.isEnabled = false;
        QuantityXField.text = ""
        
        // 保存する用へ
        selectQuantity = String(sender.tag)
        
        // 選択中でないボタンは半透明に
        for i in 0 ... 7 {
            // 半透明にする (0で透明化する)
            arrayQuantity[i].alpha = 0.3
        }
        QuantityX.alpha = 0.3
        //押されているボタンは普通に
        sender.alpha = 1
    }
    // X匹入ボタン押された時発動
    @IBAction func QauntityXClick(_ sender: UIButton) {
        // trueなら操作可、falseなら操作不可
        QuantityXField.isEnabled = true
        
        // 選択中でないボタンは半透明に
        for i in 0 ... 7 {
            // 半透明にする (0で透明化する)
            arrayQuantity[i].alpha = 0.3
        }
        //押されているボタンは普通に
        sender.alpha = 1
    }
    
    
    
    
    // 半端数選択ボタン押した時発動
    @IBAction func NameSelectClick(_ sender: Any) {
        // 今開いてるpicker画面を消す
        vi.removeFromSuperview()
        // 半端数選択用ピッカー作成
        boxPickerCreate()
    }
    
    
    
    // 保存ボタン押された時発動
    @IBAction func saveClick(_ sender: Any){
        // 保存用(テーブル表示用)の配列の[0]番目に代入する
        // X個入りに対応
        if QuantityXField.isEnabled == true{
            QuantityData.insert(QuantityXField.text ?? "", at: 0)
        }else{
            QuantityData.insert(selectQuantity, at: 0)
        }
        
        AnyProductData.insert(selectAnyProduct.text!, at: 0)
        
        print(QuantityData)
        print(AnyProductData)
        
        // tableView更新
        tableView.reloadData()
    }
    


    // 初期処理 ------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController(上のバー)の戻るボタン消す
        self.navigationItem.hidesBackButton = true
        
        print(BoxAllData)
        
        
        // TableView用の初期設定  http://sayulemon46.hatenablog.com/entry/2017/03/06/171934
        // 処理を任せる
        tableView.delegate = self
        // テーブルに表示する内容を提供する
        tableView.dataSource = self
        
        
        // 個入りの配列にまとめて追加
        arrayQuantity.append(contentsOf: [Quantity5, Quantity6, Quantity7, Quantity8, Quantity9, Quantity10, Quantity11, Quantity12])
        // 個入りのボタンか
        var tagb = 5
        for i in 0 ... 7 {
            arrayQuantity[i].tag = tagb
            tagb += 1
        }
        // falseなら操作不可  半端数ボタンが押された時に操作可能に
        QuantityXField.isEnabled = false

    }
    
    // 画面遷移で値渡す-------------------------------------------------------------------------------------------------------------------------
    
    // 画面遷移する時？
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 送る配列   (商品の個入り　行き先の名前)
        var productAllData = [[String]]()
//        BoxAllData.append(QuantityData)
//        BoxAllData.append(NameData)
//        BoxAllData.append(BoxData)
        
        // 別のView に送信
        // "toCreate2ViewSegue"の名前の遷移のとき発動
        if (segue.identifier == "toCreate3ViewSegue") {
            // ViewControllerCreate2 の変数を持ってくる？
            let vc: ViewControllerCreate3 = segue.destination as! ViewControllerCreate3
            vc.BoxAllData = BoxAllData
            vc.productAllData = productAllData
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

extension ViewControllerCreate2: UITableViewDelegate, UITableViewDataSource{
    
    // テーブルのセクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "   重さ                                                                        何匹入                                                                        半端数"
    }
    
    // セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnyProductData.count
    }
    
    // セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        // セルに表示する値を設定する
        cell.productLabel2.text = ""
        cell.QuantityLabel2.text = QuantityData[indexPath.row]
        cell.NameLabel2.text = AnyProductData[indexPath.row]
        
        return cell
    }
    
    // 行の挿入または削除をコミットするようにデータソースに要求する時に発動
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // セルが編集可能な状態(削除可能）な時
        if editingStyle == .delete {
            // 選択中のCellにあるLabelを保存配列から消す
            QuantityData.remove(at: indexPath.row)
            AnyProductData.remove(at: indexPath.row)
            // 洗濯中のCellを削除
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}






// pickerの設定 ------------------------------------------------------------------------------------------------------------------------------

extension ViewControllerCreate2: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // UIPickerViewDataSource
    // 表示する列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // アイテム表示個数を指定する
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayAnyProduct.count
    }
    
    // UIPickerViewDelegate
    //表示する文字列を指定する
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return arrayAnyProduct[row]
    }
    // 選択時の処理 (選択されている値)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        // カゴ個数のTextFieldに入れる
        selectAnyProduct.text = arrayAnyProduct[row]
    }
    
    
    
    func boxPickerCreate(){
        
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