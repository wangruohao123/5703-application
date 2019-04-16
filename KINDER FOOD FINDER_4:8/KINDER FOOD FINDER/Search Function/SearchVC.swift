//
//  SearchVC.swift
//  KINDER FOOD FINDER
//
//  Created by heboning on 2019/04/02.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //customize the navigation back button in iOS 12 and above without title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }
    

}
