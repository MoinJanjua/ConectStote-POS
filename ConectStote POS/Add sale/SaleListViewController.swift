//
//  SaleListViewController.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 31/12/2024.
//

import UIKit

class SaleListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
       
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
                
           if let savedData = UserDefaults.standard.array(forKey: "salesList") as? [Data]
           {
               let decoder = JSONDecoder()
               sales_list = savedData.compactMap { data in
                   do {
                       let order = try decoder.decode(salesList.self, from: data)
                       return order
                   } catch {
                       print("Error decoding medication: \(error.localizedDescription)")
                       return nil
                   }
               }
           }

           noDataLabel.text =  "There is no sales available, please create sales first"
           if sales_list.isEmpty {
               TableView.isHidden = true
               noDataLabel.isHidden = false
           } else {
               TableView.isHidden = false
               noDataLabel.isHidden = true
           }
           
           TableView.reloadData()
           
       }
    
    
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return sales_list.count
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! salesTableViewCell
           
           let sales = sales_list[indexPath.row]
           
           cell.productName?.text = "Product Name : \(sales.productname)"
           cell.price?.text = "Product Price : $\(sales.pric)"
           cell.qty?.text = "Product Qty :\(sales.qty)"
           cell.ciustomername?.text = "Customer Name :\(sales.customername)"
           cell.anyNotes?.text = "Note : \(sales.note)"
           cell.date?.text = sales.sellingdate
           if sales.note.isEmpty
           {
               cell.anyNotes?.text = "Note : N/A"
           }
           cell.discpunt?.text = "Discount : $\(sales.discount)"
           
           if sales.discount.isEmpty
           {
               cell.discpunt?.text = "Discount : $0.00"
           }
           
           return cell
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 157
           
       }
       
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
       {
           if editingStyle == .delete {
               sales_list.remove(at: indexPath.row)
               
               let encoder = JSONEncoder()
               do {
                   let encodedData = try sales_list.map { try encoder.encode($0) }
                   UserDefaults.standard.set(encodedData, forKey: "salesList")
               } catch {
                   print("Error encoding medications: \(error.localizedDescription)")
               }
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
      
       
       
       @IBAction func addbtnPressed(_ sender:UIButton)
       {
           
           let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddSaleViewController") as! AddSaleViewController
           newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
           newViewController.modalTransitionStyle = .crossDissolve
           self.present(newViewController, animated: true, completion: nil)
       }
       
   }
