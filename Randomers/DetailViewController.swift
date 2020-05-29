//
//  DetailViewController.swift
//  Randomers
//
//  Created by ChengRosman on 29/05/20.
//  Copyright © 2020 Rosman Cheng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var dob: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let randomer = randomer {
            // avatar
            let picture = randomer["picture"] as! NSDictionary
            avatar.sd_setImage(with: URL(string: picture["large"] as! String), completed: nil)
            
            // title and name
            let nameDic = randomer["name"] as! NSDictionary
            name.text = (nameDic["title"] as! String) + ". " + (nameDic["first"] as! String) + " " + (nameDic["last"] as! String)
            
            // gender
            gender.text = randomer["gender"] as? String
            
            // dob
            let dobDic = randomer["dob"] as! NSDictionary
            dob.text = dobDic["date"] as? String
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var randomer: NSDictionary?
}

