//
//  LearnMoreVC.swift
//  KINDER FOOD FINDER
//
//  Created by Boning He on 2019/04/26.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class LearnMoreVC: UIViewController ,UITextViewDelegate{
    var Rawdata : Rawdata!

    @IBOutlet weak var titile: UITextView!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var learnImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titile.delegate = self
        detail.delegate = self
        contents()
        // Do any additional setup after loading the view.
    }
    func contents(){
        if Rawdata.product_category == "Egg"{
            detail.text = "NB. There are welfare issues associated with all egg production systems whereby male chicks having no commercial value (only female chickens lay eggs) and are routinely killed at birth. Additionally, hens are often considered 'spent' and killed at approximately 18 months old in conventional systems, and approximately 30 months in free-range and organic system (layer hens natural lifespan is up to 12 years). Furthermore, under the guidelines outlined in the Model Codes of Practice for the Welfare of Animals, organic and free-range chickens can be transported and slaughtered in the same way, at the same facilities as factory farmed chickens.NB. RSPCA, FREPA and Egg Corp Assured Scheme allow for beak-trimming which is the partial removal of a layer hen's beak, which is done in an attempt to prevent the damage caused by feather pecking which could lead to cannibalism."
            titile.text = "Ratings Laying Hens:"
            learnImage.image = UIImage(named: "learnegg")
        }
        else if Rawdata.product_category == "Chicken"{
            detail.text = "NB. There are welfare issues associated with all chicken meat production systems where chicks that are deemed 'unviable' are killed at birth. Furthermore, under the guidelines outlined in the Model Codes of Practice for the Welfare of Animals, organic and free-range chickens can be transported and slaughtered in the same way, at the same facilities as factory farmed chickens.*There is the common misconception that chickens raised for meat are kept in cages liked chickens raised for egg production. In Australia, chickens raised for meat are never confined in cages; instead they are often grown on the floor of large sheds or barns. Therefore, claims such as cage-free are meaningless."
            titile.text = "Ratings broilers/ Meat chickens:"
            learnImage.image = UIImage(named: "learnchicken")
        }
        else{
            detail.text = "NB. There are welfare issues associated with all pig production that includes that growing pigs and breeding pigs are often slaughtered at around 5-6 months and 3-5 years respectively (pigs natural lifespan is 10-12 years). Furthermore, under the guidelines outlined in the Model Codes of Practice for the Welfare of Animals, organic and free-range pigs can be transported and slaughtered in the same way, at the same facilities as factory farmed pigs."
            titile.text = "Ratings pigs:"
            learnImage.image = UIImage(named: "learnpig")
        }
    }
}
