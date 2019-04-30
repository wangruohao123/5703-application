//
//  MoreVC.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/04/12.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class MoreVC: UIViewController {
    var abouttitle = ["About Us","FAQs","Glossary of term"]

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        //sign out
    }
}

extension MoreVC : UITableViewDelegate,UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)
            cell.textLabel?.text = abouttitle[indexPath.row]
        return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsCell", for: indexPath)
            cell.textLabel?.text = abouttitle[indexPath.row]
        return cell
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "GlossaryCell", for: indexPath)
            cell.textLabel?.text = abouttitle[indexPath.row]
            return cell
    }
    
    

}
}
