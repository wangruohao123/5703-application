//
//  ClassTableVC.swift
//  KINDER FOOD FINDER
//
//  Created by heboning on 2019/04/04.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class ClassTableVC: UITableViewController {
    //feild类型  235   0-》2，1-》3，2-》5
    var searchType:intmax_t = 0;
    //全部数据
    var rawdatas: [Rawdata] = []
    //当前feild数组
    var feildDatas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feildDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = String(describing: ClassCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ClassCell
        cell.classLabel.text = feildDatas[indexPath.row]
        
        return cell
    }
     //转场传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAll" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! BrowserResultVC
                destinationController.searchType = searchType
                destinationController.rawdatas = rawdatas;
                destinationController.searchString = feildDatas[indexPath.row]
            }
        }
    }
   

}
