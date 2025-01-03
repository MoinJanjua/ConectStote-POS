import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var todaysale: UILabel!
    @IBOutlet weak var monthlysale: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var greetingLb: UILabel!

    var sales_list = [salesList]()
    var filteredSales = [salesList]()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy" // Match the sellingdate format
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        loadSalesData()
        updateSalesSummary()
        filterSales(by: .all) // Default to all sales
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSalesData()
        updateSalesSummary()
        updateGreeting()
    }
    
    func updateGreeting() {
          let hour = Calendar.current.component(.hour, from: Date())
          
          if hour < 12 {
              greetingLb.text = "Good Morning"
          } else if hour < 18 {
              greetingLb.text = "Good Afternoon"
          } else {
              greetingLb.text = "Good Evening"
          }
      }

    func loadSalesData() {
        if let savedData = UserDefaults.standard.array(forKey: "salesList") as? [Data] {
            let decoder = JSONDecoder()
            sales_list = savedData.compactMap { data in
                do {
                    return try decoder.decode(salesList.self, from: data)
                } catch {
                    print("Error decoding sales data: \(error.localizedDescription)")
                    return nil
                }
            }
            print("sales_list", sales_list)
        }
    }

    func updateSalesSummary() {
        let today = Date()
        let calendar = Calendar.current

        // Calculate today's sale
        let todaySales = sales_list.filter {
            if let saleDate = dateFormatter.date(from: $0.sellingdate) {
                return calendar.isDateInToday(saleDate)
            }
            return false
        }
        let todayTotal = todaySales.reduce(0) { $0 + (Int($1.pric) ?? 0) }
        todaysale.text = "$\(todayTotal).00"

        // Calculate monthly sale
        let currentMonth = calendar.component(.month, from: today)
        let currentYear = calendar.component(.year, from: today)
        let monthlySales = sales_list.filter {
            if let saleDate = dateFormatter.date(from: $0.sellingdate) {
                let month = calendar.component(.month, from: saleDate)
                let year = calendar.component(.year, from: saleDate)
                return month == currentMonth && year == currentYear
            }
            return false
        }
        let monthlyTotal = monthlySales.reduce(0) { $0 + (Int($1.pric) ?? 0) }
        monthlysale.text = "$\(monthlyTotal).00"
    }

    @IBAction func segmentedctrl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filterSales(by: .all)
        case 1:
            filterSales(by: .weekly)
        case 2:
            filterSales(by: .monthly)
        default:
            break
        }
    }

    func filterSales(by filter: SalesFilter) {
        let calendar = Calendar.current
        let today = Date()

        switch filter {
        case .all:
            filteredSales = sales_list
        case .weekly:
            filteredSales = sales_list.filter {
                if let saleDate = dateFormatter.date(from: $0.sellingdate) {
                    return calendar.isDate(saleDate, equalTo: today, toGranularity: .weekOfYear)
                }
                return false
            }
        case .monthly:
            let currentMonth = calendar.component(.month, from: today)
            let currentYear = calendar.component(.year, from: today)
            filteredSales = sales_list.filter {
                if let saleDate = dateFormatter.date(from: $0.sellingdate) {
                    let month = calendar.component(.month, from: saleDate)
                    let year = calendar.component(.year, from: saleDate)
                    return month == currentMonth && year == currentYear
                }
                return false
            }
        }

        TableView.reloadData()
        TableView.isHidden = filteredSales.isEmpty
        noDataLabel.isHidden = !filteredSales.isEmpty
    }
}

// TableView DataSource and Delegate
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSales.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! salesTableViewCell
        let sales = filteredSales[indexPath.row]

        cell.productName?.text = "Product Name: \(sales.productname)"
        cell.price?.text = "Product Price: $\(sales.pric)"
        cell.qty?.text = "Product Qty: \(sales.qty)"
        cell.ciustomername?.text = "Customer Name: \(sales.customername)"
        cell.anyNotes?.text = sales.note.isEmpty ? "Note: N/A" : "Note: \(sales.note)"
        cell.discpunt?.text = sales.discount.isEmpty ? "Discount: $0.00" : "Discount: $\(sales.discount)"
        cell.date?.text = sales.sellingdate
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
}

// Sales Filter Enum
enum SalesFilter {
    case all
    case weekly
    case monthly
}
