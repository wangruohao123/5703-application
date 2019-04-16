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
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = String(describing: DetailCell.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Accreditation"
            cell.valueLabel.text = Rawdata.FIELD3
        case 1:
            cell.fieldLabel.text = "Rating"
            cell.valueLabel.text = Rawdata.FIELD5
        case 2:
            cell.fieldLabel.isHidden = true
            cell.valueLabel.text = "Learn more about what this rating means for it"
        case 3:
            cell.fieldLabel.text = "Avaliable at:"
            cell.valueLabel.text = Rawdata.FIELD7
        default:
            cell.fieldLabel.isHidden = true
            cell.valueLabel.text = "Report where you found this product"
        }
        
        
        
        return cell
    }
    


}
