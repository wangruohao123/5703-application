//
//  AccraSearchTableVC.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/03/28.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit


class AccraSearchTableVC: UITableViewController , UISearchResultsUpdating{
    
    
    var Rawdatas: [Rawdata] = []
    var sc: UISearchController!
    var searchResults: [Rawdata] = []
    var favorites: [Favorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
        loadJsonfav()
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.searchBarStyle = .minimal
        sc.searchBar.placeholder = "Search By Accreditation..."
        
    }
    // select data by accreditation
    func searchFilter(text: String){
        searchResults = Rawdatas.filter({ (Rawdata) -> Bool in
            return Rawdata.accreditation.localizedCaseInsensitiveContains(text) // || Rawdata.FIELD5.localizedCaseInsensitiveContains(text) || Rawdata.FIELD4.localizedCaseInsensitiveContains(text)
        })
    }

    
    
    
// favorite feature
   @IBAction func favBtnTap(_ sender: UIButton) {
        let btnPos = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: btnPos)!
       self.favorites[indexPath.row].FIELD6 = !self.favorites[indexPath.row].FIELD6

       let cell = tableView.cellForRow(at: indexPath) as! CardCell

        cell.favorite = self.favorites[indexPath.row].FIELD6
   }
    
    
    
// update result
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text{
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    

// download and parse JSON
    func loadJson(){
        let jsonUrlString = "   "
        guard let url = URL(string: jsonUrlString)  else {
            return
        }
        URLSession.shared.dataTask(with: url) {
            (data, response,err) in
            guard let data = data else {return}
            do{
                self.Rawdatas = try JSONDecoder().decode([Rawdata].self, from: data)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
            }catch let jsonErr{
                print("Error serilizing json",jsonErr)
            }
            }.resume()
    }
    
// Parse local JSON
    func loadJsonfav() {
        let coder = JSONDecoder()
        
        do{
            let url = Bundle.main.url(forResource: "favorite", withExtension: "json")!
            let data = try Data(contentsOf: url)
            favorites = try coder.decode([Favorite].self, from: data)
        }
        catch{
            print(error)
            
        }
    }
// warn the memory
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sc.isActive ? searchResults.count : Rawdatas.count
    }
    
// Configure the cell...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: CardCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! CardCell
        
        
        let Rawdata = sc.isActive ? searchResults[indexPath.row] : Rawdatas[indexPath.row]
  
        cell.classLabel.text  = Rawdata.product_category
        cell.accradLabel.text = Rawdata.accreditation
        cell.brandLabel.text = Rawdata.product_name
        cell.backImageView.image = UIImage(named: Rawdata.image_label)
        cell.favorite = favorites[indexPath.row].FIELD6
        
       
        return cell
    }
    
// share feature
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share")
        {
            (_, _, completion) in
            let text = "This is the \(self.Rawdatas[indexPath.row].product_name), the rating is \(self.Rawdatas[indexPath.row].rating), the accreditation is \(self.Rawdatas[indexPath.row].accreditation). "
            let image = UIImage(named: self.Rawdatas[indexPath.row].image_label)!
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
    
    
    
// prepare for next scene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            
            let row = tableView.indexPathForSelectedRow!.row
            let destination = segue.destination as! DetailController
            destination.Rawdata = sc.isActive ? searchResults[row] :
                Rawdatas[row]
        }
    }
}
