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
    

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFilter(text: searchString)
        tableView.reloadData()
     
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
      
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share")
        {
            (_, _, completion) in
            let text = "This is the \(self.searchResults[indexPath.row].product_name), the rating is \(self.searchResults[indexPath.row].rating), the accreditation is \(self.searchResults[indexPath.row].accreditation). "
           // let image = UIImage(named: self.searchResults[indexPath.row].image_label)!
           // let ac = UIActivityViewController(activityItems: [text, image], applicationActivities: nil)
             let ac = UIActivityViewController(activityItems: [text], applicationActivities: nil)
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
            
            let brand_name = searchResults[row].product_name
            let user_age = UserDefaults.standard.string(forKey: "age")
            let user_gender = UserDefaults.standard.string(forKey: "gender")
            let product_type = searchResults[row].product_category
            let myUrl = NSURL(string: "http://ec2-13-239-136-215.ap-southeast-2.compute.amazonaws.com:8000/feedback/")
            let request = NSMutableURLRequest(url: myUrl! as URL)
            request.httpMethod = "POST"
            let postString = "brand_name=\(brand_name ?? "")&user_age=\(user_age ?? "")&user_gender=\(user_gender ?? "")&product_type=\(product_type ?? "")";
            request.httpBody = postString.data(using: String.Encoding.utf8);
            print(postString)
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                if error != nil{
                    print("error=\(error)")
                    return
                }
                let json = try? JSON(data: data!)
                print("___________")
                print(response ?? "")
                print(json ?? "")
                let httpResponse = response as! HTTPURLResponse
                let code = httpResponse.statusCode
                var result: Double = Double(code)
                print(code)
            }
                task.resume()
           
        }
    }
 
    
}
