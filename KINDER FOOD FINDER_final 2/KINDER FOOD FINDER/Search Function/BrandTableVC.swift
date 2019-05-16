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
 
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
       
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
                self.Rawdatas = try JSONDecoder().decode([Rawdata].self, from: data)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
            }catch let jsonErr{
                print("Error serilizing json",jsonErr)
            }
            }.resume()    }
    
 
    
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
       6
        
//        cell.accessoryType = Rawdata.FIELD6 ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share")
        {
            (_, _, completion) in
            let text = "This is the \(self.Rawdatas[indexPath.row].product_name), the rating is \(self.Rawdatas[indexPath.row].rating), the accreditation is \(self.Rawdatas[indexPath.row].accreditation). "
           // let image = UIImage(named: self.Rawdatas[indexPath.row].image_label)!
          //  let ac = UIActivityViewController(activityItems: [text, image], applicationActivities: nil)
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
            
            let brand_name = Rawdatas[row].product_name
            let user_age = UserDefaults.standard.string(forKey: "age")
            let user_gender = UserDefaults.standard.string(forKey: "gender")
            let product_type = Rawdatas[row].product_category
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
