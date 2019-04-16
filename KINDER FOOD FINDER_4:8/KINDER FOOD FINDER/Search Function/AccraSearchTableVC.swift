//
//  AccraSearchTableVC.swift
//  KINDER FOOD FINDER
//
//  Created by heboning on 2019/03/28.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class AccraSearchTableVC: UITableViewController , UISearchResultsUpdating{
    
    
    var Rawdatas: [Rawdata] = []
    var sc: UISearchController!
    var searchResults: [Rawdata] = []
    
    func searchFilter(text: String){
        searchResults = Rawdatas.filter({ (Rawdata) -> Bool in
            return Rawdata.FIELD3.localizedCaseInsensitiveContains(text)
        })
    }

    
    
    
    
    @IBAction func favBtnTap(_ sender: UIButton) {
        let btnPos = sender.convert(CGPoint.zero, to: self.tableView)
     
        let indexPath = tableView.indexPathForRow(at: btnPos)!
        

        self.Rawdatas[indexPath.row].FIELD6 = !self.Rawdatas[indexPath.row].FIELD6
        
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        
        cell.favorite = self.Rawdatas[indexPath.row].FIELD6
        
        
    }//收藏交互
    
    //    func saveToJson() {
    //       let coder = JSONEncoder()
    //    do {
    //            let data = try coder.encode(Rawdatas)
    //            let saveUrl = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Rawdata.json")
    //            try data.write(to: saveUrl)
    //            print("保存成功！路径:", saveUrl)
    //        } catch {
    //           print("编码错误", error)        }
    //    }
    
    
    
    func loadJson() {
        let coder = JSONDecoder()
        
        do{
            let url = Bundle.main.url(forResource: "Rawdata", withExtension: "json")!
            let data = try Data(contentsOf: url)
            Rawdatas = try coder.decode([Rawdata].self, from: data)
        }
        catch{
            print("解码错误",error)
            
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text{
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        navigationController?.navigationBar.largeTitleTextAttributes = [
        //            NSAttributedStringKey.foregroundColor : UIColor(named: "theme")!
        //        ]
        
        loadJson()
        //        saveToJson()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.placeholder = "Search By Accreditation..."
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sc.isActive ? searchResults.count : Rawdatas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: CardCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! CardCell
        
        
        let Rawdata = sc.isActive ? searchResults[indexPath.row] : Rawdatas[indexPath.row]
        // Configure the cell...
        cell.classLabel.text  = Rawdata.FIELD2
        cell.accradLabel.text = Rawdata.FIELD3
        cell.brandLabel.text = Rawdata.FIELD4
        cell.backImageView.image = UIImage(named: Rawdata.FIELD1)
        cell.favorite = Rawdata.FIELD6
        
        cell.accessoryType = Rawdata.FIELD6 ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share")
        {
            (_, _, completion) in
            let text = "This is\(self.Rawdatas[indexPath.row].FIELD4)，accreditation is \(self.Rawdatas[indexPath.row].FIELD3), rating is\(self.Rawdatas[indexPath.row].FIELD5)."
            let image = UIImage(named: self.Rawdatas[indexPath.row].FIELD1)!
            let ac = UIActivityViewController(activityItems: [text, image], applicationActivities: nil)
            
            if let pc = ac.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    pc.sourceView = cell
                    pc.sourceRect = cell.bounds
                    
                }
                
            }
            
            self.present(ac, animated: true)
            
            completion(true)
        }
        
        shareAction.backgroundColor = UIColor.orange
        let config = UISwipeActionsConfiguration(actions: [shareAction])
        return config
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !sc.isActive
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            
            let row = tableView.indexPathForSelectedRow!.row
            let destination = segue.destination as! DetailController
            destination.Rawdata = sc.isActive ? searchResults[row] :
                Rawdatas[row]
        }
        
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
   
    
    
}
}
