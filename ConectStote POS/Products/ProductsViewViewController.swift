//
//  ProductsViewViewController.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 30/12/2024.
//

import UIKit

class ProductsViewViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var createbtn: UIButton!
    
    var products = [addProducts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: createbtn)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let savedData = UserDefaults.standard.array(forKey: "addProducts") as? [Data] {
            let decoder = JSONDecoder()
            products = savedData.compactMap { data in
                do {
                    let order = try decoder.decode(addProducts.self, from: data)
                    return order
                } catch {
                    print("Error decoding medication: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        noDataLabel.text = "There is no records available, please create products first"
        
        if products.isEmpty {
            TableView.isHidden = true
            noDataLabel.isHidden = false
        } else {
            TableView.isHidden = false
            noDataLabel.isHidden = true
        }
        TableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! productsTableViewCell
        
        let products = products[indexPath.row]
        cell.nameTF?.text = "Product Name\(products.Name)"
        cell.priceTF?.text = products.prodPrice
        cell.retailPrice?.text = "Reatils Price :\(products.retailPrice)"
        cell.quantiotTF?.text = products.quantity
        cell.availableQty?.text = "Available Qty: \(products.AvailQty)"
        cell.dateTF.text = products.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) 
    {
        if editingStyle == .delete {
            products.remove(at: indexPath.row)
            
            let encoder = JSONEncoder()
            do {
                let encodedData = try products.map { try encoder.encode($0) }
                UserDefaults.standard.set(encodedData, forKey: "addProducts")
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
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AddProductsViewController") as! AddProductsViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
