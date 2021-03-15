//
//  HostController.swift
//  monitor
//
//  Created by cc on 2021/3/10.
//  Copyright © 2021 cc. All rights reserved.
//

import UIKit

class HostController: UITableViewController {
    
    var datas: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "风险监控"
        self.view.backgroundColor = .black
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addHost))
        self.navigationItem.rightBarButtonItem!.tintColor = .white
        
        let defaults = UserDefaults.standard
        let hosts = defaults.stringArray(forKey: "hosts")
        if hosts.isNilOrEmpty {
            datas = ["45.141.154.22", "81.92.200.6"]
            defaults.setValue(datas, forKey: "hosts")
        } else {
            datas = hosts!
        }
        
        tableView.separatorStyle = .none
        tableView.register(HostCell.self, forCellReuseIdentifier: HostCell.reuseIdentifier)
        tableView.reloadData()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func addHost() {
        let alert = UIAlertController(title: "请输入地址", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "请输入ip地址"
        }
        alert.addAction(title: "取消", style: .cancel, isEnabled: true, handler: nil)
        alert.addAction(title: "确定", style: .default, isEnabled: true) { (action) in
            let str = alert.textFields?.first?.text
            self.datas.append(str!)
            UserDefaults.standard.setValue(self.datas, forKey: "hosts")
            UserDefaults.standard.synchronize()
        }
        alert.show()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HostCell.reuseIdentifier, for: indexPath) as! HostCell
        cell.ipLabel.text = datas[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = ViewController()
        vc.host = datas[indexPath.row]
        navigationController?.pushViewController(vc)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
