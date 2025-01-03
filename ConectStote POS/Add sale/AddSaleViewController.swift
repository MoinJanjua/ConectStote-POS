//
//  AddSaleViewController.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 31/12/2024.
//

import UIKit

class AddSaleViewController: UIViewController {
    
    @IBOutlet weak var selectprodTF: DropDown!
    @IBOutlet weak var SelectCustomerTF: DropDown!
    @IBOutlet weak var qtytf: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var pproiceTF: UITextField!
    @IBOutlet weak var itemDiscountTF: UITextField!
    @IBOutlet weak var anyNotes: UITextField!
    
    var customers = [addCustomers]()
    var sales_list = [salesList]()
    var products = [addProducts]()
    var customer_id = String()
    var product_id = String()
    var quantity = Int()
    var price = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        fetchRecords()
        
    }
    
    func fetchRecords()
    {
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
        
        
        if let savedData = UserDefaults.standard.array(forKey: "addProducts") as? [Data]
        {
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
        
        print("products products",products)
        SelectCustomerTF.optionArray = customers.map{$0.name}
        SelectCustomerTF.didSelect { (selectedText, index, id) in
            self.customer_id = self.customers[index].id
        }
        
        selectprodTF.optionArray = products.map{$0.Name}
        selectprodTF.didSelect { (selectedText, index, id) in
            self.product_id = self.products[index].id
            self.quantity = Int(self.products[index].quantity) ?? 0
            self.price = (self.products[index].prodPrice)
            self.pproiceTF.text = self.price
        }
        
    }
    
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func saveData(_ sender: Any)
    {
        // Check if any of the text fields are empty
        guard let product = selectprodTF.text,
              let customer = SelectCustomerTF.text, !customer.isEmpty,
              let qty = qtytf.text, !qty.isEmpty
                
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let finaldate = dateFormatter.string(from:  date.date)
        
        
        if Int(qty) ?? 0 > self.quantity
        {
            showAlert(title: "Error", message: "The quantity entered exceeds the available stock of \(self.quantity). Please enter a valid quantity.")
            return
        }
        
        // Update available quantity
         if let index = products.firstIndex(where: { $0.id == self.product_id }) {
             let currentAvailQty = Int(products[index].AvailQty) ?? 0
             products[index].AvailQty = String(currentAvailQty - (Int(qty) ?? 0))
             
             // Save updated products to UserDefaults
             saveUpdatedProducts()
         } else {
             showAlert(title: "Error", message: "Product not found.")
             return
         }
        
        // Proceed with saving the data
        let id = generateOrderNumber()
        let newDetail = salesList(id: id, customer_id:  self.customer_id, product__id: self.product_id, sellingdate: finaldate, productname: product, customername: customer, pric: self.price, discount: itemDiscountTF.text ?? "0.00", note: anyNotes.text ?? "N/A", qty: qty)
        
        
        saveUserDetail(newDetail)
        
    }
    
    
    func saveUserDetail(_ employee: salesList) {
        var employees = UserDefaults.standard.object(forKey: "salesList") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            employees.append(data)
            UserDefaults.standard.set(employees, forKey: "salesList")
            clearTextFields()
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Products has been Saved successfully.")
    }
    
    func saveUpdatedProducts() {
        do {
            let encoder = JSONEncoder()
            let data = try products.map { try encoder.encode($0) }
            UserDefaults.standard.set(data, forKey: "addProducts")
        } catch {
            print("Error encoding products: \(error.localizedDescription)")
        }
    }

    
    
    func clearTextFields() {
        selectprodTF.text = ""
        SelectCustomerTF.text = ""
        qtytf.text = ""
        pproiceTF.text = ""
        itemDiscountTF.text = ""
        anyNotes.text = ""
        
    }
    
    @IBAction func startbtnPressed(_ sender:UIButton)
    {
        saveData(sender)
    }
    
    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
    
}
