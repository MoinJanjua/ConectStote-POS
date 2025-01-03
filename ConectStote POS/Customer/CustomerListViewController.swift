//
//  CustomerListViewController.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 31/12/2024.
//

import UIKit

class CustomerListViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var createbtn: UIButton!
    
    var customers = [addCustomers]()
    var sales_list = [salesList]()
    var products = [addProducts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: createbtn)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedData = UserDefaults.standard.array(forKey: "addCustomers") as? [Data] {
            let decoder = JSONDecoder()
            customers = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(addCustomers.self, from: data)
                    return order
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        noDataLabel.text =  "There is no customer available, please create customer first"
        if customers.isEmpty {
            TableView.isHidden = true
            noDataLabel.isHidden = false
        } else {
            TableView.isHidden = false
            noDataLabel.isHidden = true
        }
        
        TableView.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customerTableViewCell
        
        let products = customers[indexPath.row]
        cell.nameTF?.text = "Full Name : \(products.name)"
        cell.emailTF?.text = "Email :\(products.email)"
        cell.phonetf?.text = "Phone Number :\(products.phone)"
        cell.genderTF?.text = "Gender :\(products.gender)"
        cell.addressTF?.text = "Address: \(products.address)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            customers.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try customers.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "addCustomers")
            } catch {
                print("Error encoding medications: \(error.localizedDescription)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let orderData = order_Detail[indexPath.row]
        //
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        if let newViewController = storyBoard.instantiateViewController(withIdentifier: "OrderDetailViewController") as?                      OrderDetailViewController {
        //            newViewController.selectedOrderDetail = orderData
        //
        //            newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //            newViewController.modalTransitionStyle = .crossDissolve
        //            self.present(newViewController, animated: true, completion: nil)
        //
        //        }
        
    }
    
    @IBAction func addbtnPressed(_ sender:UIButton)
    {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddCustomerViewController") as! AddCustomerViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
