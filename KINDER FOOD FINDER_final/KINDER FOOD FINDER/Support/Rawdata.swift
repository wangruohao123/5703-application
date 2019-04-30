//
//  Data.swift
//  KINDER FOOD FINDER
//
//  Created by Boning Het on 2019/03/28.
//  Copyright © 2019 KINDER FOOD FINDER. All rights reserved.
//

struct Rawdata: Decodable{
    let id : Int
    var image_label = ""
    var product_category = ""
    var accreditation = ""
    var product_name = ""
    var rating = ""
    var availability = ""
}
