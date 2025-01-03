//
//  AddCustomerViewController.swift
//  ConectStote POS
//
//  Created by Unique Consulting Firm on 31/12/2024.
//

import UIKit

class AddCustomerViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phonetf: UITextField!
    @IBOutlet weak var genderTF: DropDown!
    @IBOutlet weak var addressTF: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture2.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture2)
        
        genderTF.optionArray = ["Male", "Female"]
        genderTF.didSelect { (selectedText, index, id) in
            self.genderTF.text = selectedText
        }
//        dateTF.addTarget(self, action: #selector(fromDatePickerChanged(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    

    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func saveData(_ sender: Any) {
        // Check if any of the text fields are empty
        guard let name = nameTF.text,
              let phone = phonetf.text, !phone.isEmpty,
              let gender = genderTF.text, !gender.isEmpty
             
        else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
  
            // Proceed with saving the data
            let id = generateOrderNumber()
        let newDetail = addCustomers(id: id, name: name, email: emailTF.text ?? "No Eamil Found", phone: phone, gender: gender, address: addressTF.text ?? "No Address Found")
        saveUserDetail(newDetail)

    }

    
    func saveUserDetail(_ employee: addCustomers) {
        var employees = UserDefaults.standard.object(forKey: "addCustomers") as? [Data] ?? []
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(employee)
            employees.append(data)
            UserDefaults.standard.set(employees, forKey: "addCustomers")
            clearTextFields()
        } catch {
            print("Error encoding medication: \(error.localizedDescription)")
        }
        showAlert(title: "Done", message: "Customer has been Saved successfully.")
    }

    
    
    func clearTextFields() {
        nameTF.text = ""
        emailTF.text = ""
        phonetf.text = ""
        addressTF.text = ""
        genderTF.text = ""
      
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
