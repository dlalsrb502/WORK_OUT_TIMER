//
//  MainVC.swift
//  FirstProject
//
//  Created by 이민규 on 2021/02/27.
//

import UIKit

enum ButtonTag:Int{
    case start = 10
    case lap = 20
    case stop = 30
    case reset = 40
    case plus = 50
    case minus = 60

}


class MainVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var lapTableView: UITableView!
    var lapTableviewData = [String]()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var mainTimer : Timer?
    var timeCount : Int = 0

    @IBOutlet weak var cntLabel: UILabel!
    @IBOutlet weak var cntPlusButton: UIButton!
    @IBOutlet weak var cntMinusButton: UIButton!
    
    var touchCount : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lapTableView.delegate = self
        lapTableView.dataSource = self
        
        setButton(button: startButton, tag: .start)
        setButton(button: lapButton, tag: .lap)
        setButton(button: stopButton, tag: .stop)
        setButton(button: resetButton, tag: .reset)
        setButton(button: cntPlusButton, tag: .plus)
        setButton(button: cntMinusButton, tag: .minus)


        lapButton.isEnabled=false;
    }
    
    func setButton(button:UIButton, tag:ButtonTag){
        button.addTarget(self, action: #selector(buttonAction), for:.touchUpInside)
        button.tag=tag.rawValue;
    }
    
    
    @objc func buttonAction(_button:UIButton){
        
        if let select = ButtonTag(rawValue: _button.tag){
            
            switch select {
            case .start :   startAction()
            case .lap   :   lapAction()
            case .stop  :   stopAction()
            case .reset :   resetAction()
            case .plus  :   cntPlusAction()
            case .minus :   cntMinusAction()
             
            }
        }else{
            print("존재하지 않는 태그")
        }
    }
    
    func cntPlusAction(){
        self.touchCount+=1
        let cntString = "\(touchCount)"
        self.cntLabel.text = cntString
        
    }
    func cntMinusAction(){
        self.touchCount-=1
        let cntString = "\(touchCount)"
        self.cntLabel.text = cntString
    }
    
    func startAction(){
        print("start")
        
        startButton.isEnabled=false
        lapButton.isEnabled=true
        stopButton.isEnabled=true
        
        self.touchCount+=1
        let cntString = "\(touchCount)"
        self.cntLabel.text = cntString
        
        mainTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true,
                                         
                                         block:{ (_) in
                                            self.timeCount+=1
                                            DispatchQueue.main.async {
                                                let timeString = self.makeTimeLabel(count:self.timeCount)
                                                self.timeLabel.text=timeString
//                                                self.decimalLabel.text=".\(timeString.1)"
                                            }
                                         })
        
        
        
    }
    
    func lapAction(){
        print("lap")
        
        let timeString = self.makeTimeLabel(count: self.timeCount)
        self.lapTableviewData.append("\(timeString)")
        
        let indexPath = IndexPath(row: self.lapTableviewData.count - 1, section: 0)
        
        self.lapTableView.insertRows(at: [indexPath], with: .automatic)
        self.lapTableView.scrollToRow(at: indexPath, at: .none, animated: true)
      
        
    }
    func stopAction(){
        print("stop")
        
        mainTimer?.invalidate()
        mainTimer=nil
        
        startButton.isEnabled=true
        lapButton.isEnabled=false
        stopButton.isEnabled=false
    }
    func resetAction(){
        print("reset")
        
        mainTimer?.invalidate()
        mainTimer=nil
        timeCount=0
        timeLabel.text = "00:00.0"
        
        self.lapTableviewData.removeAll()
        self.lapTableView.reloadData()
        
        startButton.isEnabled=true
        lapButton.isEnabled=false
        stopButton.isEnabled=true
    }
    
    func makeTimeLabel(count:Int) -> (String){
        let decimalSec = count % 10
        let sec = (count/10) % 60
        let min = (count/10) / 60
        
        
        let sec_string = "\(sec)".count==1 ? "0\(sec)" : "\(sec)"
        let min_string = "\(min)".count==1 ? "0\(min)" : "\(min)"
        let dec_string = "\(decimalSec)"
        
        return("\(min_string):\(sec_string).\(dec_string)")
        
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

extension MainVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTableviewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableviewCell.cell_id,for: indexPath) as! MainTableviewCell
        
        let item = self.lapTableviewData[indexPath.row]
        cell.timeLabel.text = item
        
        
        return cell

    
    }
    
    
    
    
}
