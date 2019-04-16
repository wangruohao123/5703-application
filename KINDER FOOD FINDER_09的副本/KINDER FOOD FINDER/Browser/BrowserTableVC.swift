//
//  BrowserTableVC.swift
//  KINDER FOOD FINDER
//
//  Created by heboning on 2019/03/29.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit
//筛选feild 2 3 5
class BrowserTableVC: UITableViewController{
    //全部数据
    var rawdatas: [Rawdata] = []
    //feild2标题
    var feild2Datas: [String] = []
    //feild3标题
    var feild3Datas: [String] = []
    //feild5标题
    var feild5Datas: [String] = []
    //标题数组
    var feildsTitles = [Array<String>]()
    //加载全部数据
    func loadJson() {
        let coder = JSONDecoder()
        
        do{
            let url = Bundle.main.url(forResource: "Rawdata", withExtension: "json")!
            let data = try Data(contentsOf: url)
            rawdatas = try coder.decode([Rawdata].self, from: data)
//            print("数据",Rawdatas.count)
        }
        catch{
            print("wrong code",error)
            
        }
    }
    
    //加载二级标题 2 3 5
    func loadFields() -> Void {
        for rawdata:Rawdata in rawdatas {
            if(!feild2Datas.contains(rawdata.FIELD2))
            {
                feild2Datas.append(rawdata.FIELD2);
            }
            if(!feild3Datas.contains(rawdata.FIELD3))
            {
                feild3Datas.append(rawdata.FIELD3);
            }
            if(!feild5Datas.contains(rawdata.FIELD5))
            {
                feild5Datas.append(rawdata.FIELD5);
            }
        }
        //
        feildsTitles = [feild2Datas,feild3Datas];
        tableView.reloadData()
    }
    
    //拼接字符串
    func creatFeildTitleStr(feildDatas:Array<String>) -> String {
        var titles:String = ""
        for title:String in feildDatas {
            if(titles.isEmpty)
            {
                titles += title
            }else
            {
                titles += ("," + title)
            }
            
        }
       
        return titles;
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
        loadFields()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feildsTitles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell... 一级标题
        if indexPath.row==0 {
            cell.textLabel?.text = "Category"
        }
        else if indexPath.row==1
        {
            cell.textLabel?.text = "Accreditation"
           // cell.textLabel?.text = creatFeildTitleStr(feildDatas: feildsTitles[indexPath.row])
        }
        else
        {
            cell.textLabel?.text = "Rating"
        }
        
        return cell
    }
     //转场传值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClass" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! ClassTableVC
                destinationController.searchType = indexPath.row
                destinationController.rawdatas = rawdatas;
                destinationController.feildDatas = feildsTitles[indexPath.row]
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

