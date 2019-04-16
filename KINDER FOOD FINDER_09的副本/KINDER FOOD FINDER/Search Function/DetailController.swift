//
//  DetailController.swift
//  KINDER FOOD FINDER
//
//  Created by heboning on 2019/04/06.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class DetailController: UITableViewController {
    
    @IBOutlet weak var hearderImageView: UIImageView!
    
    var Rawdata : Rawdata!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hearderImageView.image = UIImage(named: Rawdata.FIELD1)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view delegate
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.text = "Brand Name"
            cell.valueLabel.text = Rawdata.FIELD4
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.text = "Accreditation"
            cell.valueLabel.text = Rawdata.FIELD3
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.text = "Rating"
            cell.valueLabel.text = Rawdata.FIELD5
            if cell.valueLabel.text == "Best"{
                cell.valueLabel.textColor = UIColor.green
            }
            else if cell.valueLabel.text == "Good"
                {cell.valueLabel.textColor = UIColor.orange
            }
            else{
                cell.valueLabel.textColor = UIColor.red
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.text = "Avaliable at:"
            cell.valueLabel.text = Rawdata.FIELD7
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.isHidden = true
            cell.valueLabel.text = "Learn more about what this rating means for the animals"
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.isHidden = true
            cell.valueLabel.text = "Report where you found this product"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailMapCell.self), for: indexPath) as! DetailMapCell
            return cell
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
 
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */


