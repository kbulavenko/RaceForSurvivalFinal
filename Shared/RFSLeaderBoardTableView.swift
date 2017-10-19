//
//  RFSLeaderBoardTableView.swift
//  RaceForSurvivalFinal
//
//  Created by Z on 20.06.17.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class RFSLeaderBoardTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
//    var   items : [[String]]  = [["Name",       "Time"],
//                                    ["Alex",       "02:08:09:89"],
//                                 ["Dmitry",     "03:28:19:35"],
//                                 ["Konstantin", "04:38:41:13"]]

    let    RFSDictionaryInUserDefaults  = "RFSDictionaryInUserDefaults"

    
    var    itemsDictionary  : Dictionary<String , [String]>  =    [
        "0"             :      ["Name",       "Time"],
        "76898901"      :      ["Alex",       "02:08:09:89"],
        "124993502"     :      ["Dmitry",     "03:28:19:35"],
        "167211303"     :      ["Konstantin", "04:38:41:13"]
    ]
    
    var    keysArray  : Array<String>?
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        
        
        itemsDictionary   = UserDefaults.standard.value(forKey: RFSDictionaryInUserDefaults) as! Dictionary<String , [String]>
        
        
        
        keysArray  = itemsDictionary.keys.sorted{ Int($0)! < Int($1)! }
        
        
     //   print("keysArray  : \(String(describing: keysArray))")
        
     //   let test  : String  = "00222"
        
        //let test1  : Int   =    String()
        
        self.delegate = self
        self.dataSource = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keysArray!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        var  cell : UITableViewCell?
        
        if cell == nil  {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
            
        }
        
        cell?.backgroundColor? = UIColor.init(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 0)
        cell?.textLabel?.backgroundColor = UIColor.init(colorLiteralRed: 0.1, green: 0.1, blue: 0.1, alpha: 0)
        cell?.textLabel?.font = UIFont.init(name: "Arial", size: 12)
        cell?.textLabel?.textColor = UIColor.init(colorLiteralRed: 0.8, green: 0.3, blue: 0.4, alpha: 1)

        cell?.textLabel?.text =  itemsDictionary[(keysArray?[indexPath.row])!]?[0]
            //self.items[indexPath.row][0]
        
        
        
        
        cell?.detailTextLabel?.text =  itemsDictionary[(keysArray?[indexPath.row])!]?[1]
        //cell?.detailTextLabel?.text = self.items[indexPath.row][1]

        
      //  cell?.detailTextLabel?.text =   "dfdsfsdfsdfsd"
        cell?.detailTextLabel?.backgroundColor = UIColor.init(colorLiteralRed: 0.2, green: 0.3, blue: 0.4, alpha: 0)
        cell?.detailTextLabel?.textColor = UIColor.init(colorLiteralRed: 0.8, green: 0.3, blue: 0.4, alpha: 1)
        
        cell?.detailTextLabel?.font = UIFont.init(name: "Arial", size: 14)
        
       // print("\(String(describing: cell?.detailTextLabel))")
        
            //self.items[indexPath.row][1]
        return cell!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
        //return "    "
       // return "Section \(section)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let   headerView   : UITableViewHeaderFooterView =  (view as? UITableViewHeaderFooterView)!
        let   label : UILabel   = UILabel.init(frame: rectForHeader(inSection: section))
        label.text = " Name                                              Time"
        
        
        label.font   = UIFont.init(name: "Arial", size: 12)
        
        headerView.backgroundView?.backgroundColor   =  UIColor.init(colorLiteralRed: 0.2, green: 0.3, blue: 0.4, alpha: 0)

       
        
        headerView.contentView.addSubview(label)
        
       
        
        print("headerView.contentView.subviews : \( headerView.contentView.subviews)")
        
    }
    
}
