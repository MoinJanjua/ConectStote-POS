//
//  AddProductsViewController.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 30/12/2024.
//

import UIKit

class AddProductsViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var retailPrice: UITextField!
    @IBOutlet weak var dateTF: UIDatePicker!
    @IBOutlet weak var quantiotTF: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        
        dateTF.addTarget(self, action: #selector(fromDatePickerChanged(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func fromDatePickerChanged(_ sender: UIDatePicker) {
        filterTransactions()
    }

    
    func filterTransactions() {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Adjust this format to match the format of your `startdate`
        let date = dateFormatter.string(from: dateTF.date)
        let finaldate = dateFormatter.date(from: date)
        dateTF.date = finaldate ?? Date()
        
        // Reload the table view with the filtered data
       
    }

    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func saveData(_ sender: Any) {
        // Check if any of the text fields are empty
        guard let name = nameTF.text,
              let price = priceTF.text, !price.isEmpty,
              let retailPrice = retailPrice.text, !retailPrice.isEmpty,
              let quantity = quantiotTF.text
             
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        if Int(price) ?? 0 <= 0
        {
            showAlert(title: "Error", message: "Please add a price above 0.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let finaldate = dateFormatter.string(from:  dateTF.date)
        // Check if the entered percentage is a valid number
        if let quantityText = quantiotTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let qty = Double(quantityText), qty > 0 {
            // Proceed with saving the data
            let id = generateOrderNumber()
            let newDetail = addProducts(id: id, Name: name, prodPrice: price, retailPrice: retailPrice, quantity: quantityText, AvailQty: quantityText, date: finaldate)
            saveUserDetail(newDetail)
        } else {
            // Show error if quantity is not valid or <= 0
            showAlert(title: "Error", message: "Please enter a valid quantity greater than 0.")
        }

    }

    
    func saveUserDetail(_ employee: addProducts) {
        var employees = UserDefaults.standard.object(forKey: "addProducts") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            employees.append(data)
            UserDefaults.standard.set(employees, forKey: "addProducts")
            clearTextFields()
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Products has been Saved successfully.")
    }

    
    
    func clearTextFields() {
        nameTF.text = ""
        priceTF.text = ""
        retailPrice.text = ""
        quantiotTF.text = ""
      
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
