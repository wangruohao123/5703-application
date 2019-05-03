//
//  DetailController.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/04/06.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class DetailController: UITableViewController {
    
    @IBOutlet weak var hearderImageView: UIImageView!
    
    var Rawdata : Rawdata!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hearderImageView.image = UIImage(named: Rawdata.image_label)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
// Configure the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.text = "Brand Name"
            cell.valueLabel.text = Rawdata.product_name
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.text = "Accreditation"
            cell.valueLabel.text = Rawdata.accreditation
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCell.self), for: indexPath) as! DetailCell
            cell.fieldLabel.text = "Rating"
            cell.valueLabel.text = Rawdata.rating
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
            cell.valueLabel.text = Rawdata.availability
            return cell
        case 4:
             let cell = tableView.dequeueReusableCell(withIdentifier: "LearnCell", for: indexPath)
            cell.textLabel?.text = "Learn more about our rating means (Click it)"
             return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
            cell.textLabel?.text = "Report where you found this product (Click it)"
            return cell
        }
        
    }
    
// prepare for the next scenes
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReport" {
    
            let destination = segue.destination as! Reportvc
            destination.Rawdata = Rawdata
        }
        if segue.identifier == "showLearn" {
            let destination = segue.destination as! LearnMoreVC
            destination.Rawdata = Rawdata
        }
        if segue.identifier == "Mapvc" {
            let destination = segue.destination as! Mapvc
            destination.Rawdata = Rawdata
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
 
   
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */


}
