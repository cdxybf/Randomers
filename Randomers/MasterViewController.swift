//
//  MasterViewController.swift
//  Randomers
//
//  Created by ChengRosman on 29/05/20.
//  Copyright © 2020 Rosman Cheng. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage

class MasterViewController: UITableViewController, UISearchBarDelegate {

    let randomService = RandomerService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 100
        tableView.sectionHeaderHeight = 50

        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.randomService.resetPage()
            self?.randomService.fetchRandomers(finished: { (succeed) in
                self?.tableView.mj_header?.endRefreshing()
                self?.tableView.reloadData()
            })
        })
        
        tableView.mj_footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            self?.randomService.fetchRandomers(finished: { (succeed) in
                self?.tableView.mj_footer?.endRefreshing()
                self?.tableView.reloadData()
            })
        })
        
        tableView.mj_header?.beginRefreshing()
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = randomService.randomers[indexPath.row] as! NSDictionary
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.randomer = object
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomService.randomers.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .detailDisclosureButton
        
        let avatar = cell.contentView.viewWithTag(10) as! UIImageView
        let name = cell.contentView.viewWithTag(20) as! UILabel
        let gender = cell.contentView.viewWithTag(30) as! UILabel
        let dob = cell.contentView.viewWithTag(40) as! UILabel
        
        let randomer = randomService.randomers[indexPath.row] as! NSDictionary
       
        // avatar
        let picture = randomer["picture"] as! NSDictionary
        avatar.sd_setImage(with: URL(string: picture["thumbnail"] as! String), completed: nil)
        
        // title and name
        let nameDic = randomer["name"] as! NSDictionary
        name.text = (nameDic["title"] as! String) + ". " + (nameDic["first"] as! String) + " " + (nameDic["last"] as! String)
        
        // gender
        gender.text = randomer["gender"] as? String
        
        // dob
        let dobDic = randomer["dob"] as! NSDictionary
        dob.text = dobDic["date"] as? String
        
        return cell
    }
    
    // MARK: - Search Bar
    private var _headerView: UIView?
    private var headerView: UIView? {
        get {
            if (_headerView == nil) {
                _headerView = UIView()
                let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
                _headerView?.addSubview(searchBar)
                
                searchBar.delegate = self
            }
            return _headerView
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.mj_header?.beginRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        randomService.setupKeyWord(keyWord: searchText)
    }
}

