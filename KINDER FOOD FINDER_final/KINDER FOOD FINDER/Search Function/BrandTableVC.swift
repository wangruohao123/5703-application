//
//  BrandTableVC.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/04/02.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

//this class is similar with AccraSearchTableVC
class BrandTableVC: UITableViewController , UISearchResultsUpdating{
    
    
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
        sc.searchBar.placeholder = "Search By Brand Name..."
    }
    
    func searchFilter(text: String){
        searchResults = Rawdatas.filter({ (Rawdata) -> Bool in
            return Rawdata.product_name.localizedCaseInsensitiveContains(text)
        })
    }
  
    
    @IBAction func favBtnTap(_ sender: UIButton) {
        let btnPos = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: btnPos)!

        self.favorites[indexPath.row].FIELD6 = !self.favorites[indexPath.row].FIELD6

        let cell = tableView.cellForRow(at: indexPath) as! CardCell

        cell.favorite = self.favorites[indexPath.row].FIELD6


    }
    
    
    
    func loadJson() {
        let jsonUrlString = "https://api.myjson.com/bins/177jqw"
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
            }.resume()    }
    
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
    
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text{
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sc.isActive ? searchResults.count : Rawdatas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: CardCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! CardCell
        
        
        let Rawdata = sc.isActive ? searchResults[indexPath.row] : Rawdatas[indexPath.row]
        // Configure the cell...
        cell.classLabel.text  = Rawdata.product_category
        cell.accradLabel.text = Rawdata.accreditation
        cell.brandLabel.text = Rawdata.product_name
        cell.backImageView.image = UIImage(named: Rawdata.image_label)
        cell.favorite = favorites[indexPath.row].FIELD6
        
//        cell.accessoryType = Rawdata.FIELD6 ? .checkmark : .none
        return cell
    }
    
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
    
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            
            let row = tableView.indexPathForSelectedRow!.row
            let destination = segue.destination as! DetailController
            destination.Rawdata = sc.isActive ? searchResults[row] :
                Rawdatas[row]
        }
        
    }
    
    
}