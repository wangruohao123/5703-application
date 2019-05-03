//
//  BrowserResultVC.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/04/09.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class BrowserResultVC: UITableViewController {
    //types of feild  235   0-》2，1-》3，2-》5
    var searchType:intmax_t = 0;
    //all data
    var rawdatas: [Rawdata] = []
    var searchString:String = ""
    var searchResults: [Rawdata] = []
    var favorites: [Favorite] = []
    
    
// this is the third layer, display all product information based on current feild(different types of category, accreditation or rating), filter results by selected fields
    func searchFilter(text: String){
        switch searchType {
        case 0:
            searchResults = rawdatas.filter({ (Rawdata) -> Bool in
                return Rawdata.product_category.localizedCaseInsensitiveContains(text)})
        case 1:
            searchResults = rawdatas.filter({ (Rawdata) -> Bool in
                return Rawdata.accreditation.localizedCaseInsensitiveContains(text)})
        case 2:
            searchResults = rawdatas.filter({ (Rawdata) -> Bool in
                return Rawdata.rating.localizedCaseInsensitiveContains(text)})
        default:
            searchResults = rawdatas.filter({ (Rawdata) -> Bool in
                return Rawdata.product_category.localizedCaseInsensitiveContains(text)})
        }
    }
    
    @IBAction func favBtnTap(_ sender: UIButton) {
        let btnPos = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: btnPos)!
        self.favorites[indexPath.row].FIELD6 = !self.favorites[indexPath.row].FIELD6
        
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        
        cell.favorite = self.favorites[indexPath.row].FIELD6
    }
    
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFilter(text: searchString)
        tableView.reloadData()
        loadJsonfav()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }
 
// Configure the cell...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: CardCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! CardCell
        
        
        let Rawdata = searchResults[indexPath.row]
        cell.classLabel.text  = Rawdata.product_category
        cell.accradLabel.text = Rawdata.accreditation
        cell.brandLabel.text = Rawdata.product_name
        cell.backImageView.image = UIImage(named: Rawdata.image_label)
        cell.favorite = favorites[indexPath.row].FIELD6
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share")
        {
            (_, _, completion) in
            let text = "This is the \(self.searchResults[indexPath.row].product_name), the rating is \(self.searchResults[indexPath.row].rating), the accreditation is \(self.searchResults[indexPath.row].accreditation). "
            let image = UIImage(named: self.searchResults[indexPath.row].image_label)!
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
// prepare for the next scene(detailed product information)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showclassDetail" {
            
            
            let row = tableView.indexPathForSelectedRow!.row
            let destination = segue.destination as! DetailController
            destination.Rawdata = searchResults[row]
        }
    }
 
    
}
