//
//  BrowserTableVC.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/03/29.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

//the browser structure is three-layer tree structure

class BrowserTableVC: UITableViewController{
//initialize all data
    var rawdatas: [Rawdata] = []
//initialize product_category data
    var feild2Datas: [String] = []
//initialize accreditation data
    var feild3Datas: [String] = []
//initialize rating data
    var feild5Datas: [String] = []
//title of dat
    var feildsTitles = [Array<String>]()

    @IBAction func refreshData(_ sender: UIBarButtonItem) {
      /*  DispatchQueue.main.async {
            self.tableView.reloadData()
            self.loadJson()
            self.loadFields()
        }
        */
        DispatchQueue.main.async(execute: {
            self.loadJson()
            self.loadFields()
            self.tableView.reloadData()
        })
    }
    // download and parse JSON
    func loadJson() {
        //let jsonUrlString = "https://api.myjson.com/bins/177jqw"
        let jsonUrlString = "http://ec2-13-239-136-215.ap-southeast-2.compute.amazonaws.com:8000/products/data?format=json"
        guard let url = URL(string: jsonUrlString)  else {
            return
        }
        URLSession.shared.dataTask(with: url) {
            (data, response,err) in
            guard let data = data else {return}
            do{
                self.rawdatas = try JSONDecoder().decode([Rawdata].self, from: data)
                DispatchQueue.main.async(execute: {
                    self.loadFields()
                    print(data)
                })
                
            }catch let jsonErr{
                print("Error serilizing json",jsonErr)
            }
            }.resume()
    }
    
//filter data based on different categories,accreditations and ratings, this is the secend layer of tree structure
    func loadFields() -> Void {
        
        for rawdata:Rawdata in rawdatas {
            if(!feild2Datas.contains(rawdata.product_category))
            {
                feild2Datas.append(rawdata.product_category);
            }
            if(!feild3Datas.contains(rawdata.accreditation))
            {
                feild3Datas.append(rawdata.accreditation);
            }
            if(!feild5Datas.contains(rawdata.rating))
            {
                feild5Datas.append(rawdata.rating);
            }
        }
        feildsTitles = [feild2Datas,feild3Datas,feild5Datas];
        self.tableView.reloadData()
    }
    
//string concatenation
   /* func creatFeildTitleStr(feildDatas:Array<String>) -> String {
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
  */

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
        loadFields()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feildsTitles.count   // 3 types
    }

// Configure the cell, this is the first layer of tree structure
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row==0
        {
            cell.textLabel?.text = "Category"
        }
            
        else if indexPath.row==1
        {
            cell.textLabel?.text = "Accreditation"
        }
        else
        {
            cell.textLabel?.text = "Ratings"
            //cell.textLabel?.text = creatFeildTitleStr(feildDatas: feildsTitles[indexPath.row])
        }
        
        
        return cell
    }
    
//prepare for the next scene(secend layer)
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

}

