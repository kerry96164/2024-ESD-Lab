//
//  ViewController.swift
//  Bookkeeping
//
//  Created by Kerry Lu on 2024/3/12.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate {
    
    var keyArrary = [String]()
    var groupDataArrary = [String:[[String:Any]]]()
    let saveDataFileName = "data.txt"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCostLable: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var newCostField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataArray()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keyArrary[section]
        return groupDataArrary[key]!.count
    }
    
    //how row show data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic Cell", for: indexPath)
        let dateKey = keyArrary[indexPath.section]
        //name=>String otherwise "No name"
        let name = groupDataArrary[dateKey]![indexPath.row]["name"] as? String ?? "No name"
        //cost=>Double otherwise "0.0"
        let cost = groupDataArrary[dateKey]![indexPath.row]["cost"] as? Double ?? 0.0
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = "\(cost)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //啟用所有row的edit功能
        return true
    }
    
    //Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case.delete:
            groupDataArrary[keyArrary[indexPath.section]]!.remove(at: indexPath.row)
            dataUpdate()
            saveDataArray()
        default:
            break
        }
    }

    @IBAction func addData(_ sender: Any) {
        //check textfield has text?
        guard let newCostString = newCostField.text, !newCostString.isEmpty else{return}
        //check could string to double?
        guard let newCost = Double(newCostString) else{return}
        //check namefield has text?
        guard let newName = nameField.text, !newCostString.isEmpty else{return}
        //get current time
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy/MM/dd hh:mm"
        let newDateString = dateFormatter.string(from: currentDate)
        
        //add new datato array
        var dataArray = [[String:Any]]()
        for group in groupDataArrary{
            for item in group.value{
                dataArray.append(item)
            }
        }
        dataArray.append(["name":newName,"cost":newCost,"date":newDateString])
        groupDataArrary = groupDictByTime(dict: dataArray)
        dataUpdate()
        
        //let refreshIndexPath = IndexPath.init(row: dataArray.count-1,section: 0)
        //tableView.insertRows(at: [refreshIndexPath], with: .top)

        newCostField.text = ""
        nameField.text = ""
        newCostField.resignFirstResponder()
        saveDataArray()
    }
    
    func dataUpdate(){
        //dump(groupDataArrary)
        //chech none element group
        for group in groupDataArrary{
            if group.value.isEmpty{
                groupDataArrary.removeValue(forKey: group.key)
                //print(groupDataArrary)
            }
        }
        
        keyArrary = Array(groupDataArrary.keys)
        keyArrary = keyArrary.sorted()
        
        tableView.reloadData()
        
        //==update Total==
        var total:Double = 0
        for group in groupDataArrary{
            for dict in group.value{
                total += dict["cost"] as? Double ?? 0.0
            }
        }
        totalCostLable.text = "\(total)"
        //=================
    }
    
    
//==================SAVE & LOAD============================
    
    //Save dataArray to text
    func saveDataArray(){
        var finalString = ""
        for group in groupDataArrary{
            for dict in group.value{
                if !dict.isEmpty{
                    let date = dict["date"] as! String
                    let name = dict["name"] as! String
                    let cost = dict["cost"] as! Double
                    finalString.append(date+","+name+","+String(cost)+"\n")
                }
            }
        }
        //print(finalString)
        writeStringToFile(writeString: finalString, fileName: saveDataFileName)
        print("[System] Save Success!")
    }
    
    //load dataArray from text
    func loadDataArray(){
        var finalArray = [[String:Any]]()
        let csvString = readFileToString(fileName: saveDataFileName)
        if csvString.isEmpty {
            print("csv is empty")
            return
        }
        //split txt line
        let lineOfString = csvString.components(separatedBy: "\n")
        for line in lineOfString{
            let data = line.components(separatedBy: ",")
            if data.count == 3{
                let date = String(data[0])
                let name = String(data[1])
                let cost = Double(data[2])
                finalArray.append(["date":date,"name":name,"cost":cost as Any])
            }
            else {print("")}
        }
        //dataArray = finalArray
        groupDataArrary = groupDictByTime(dict: finalArray)
        dataUpdate()
        
    }
    
    //Save text File
    func writeStringToFile(writeString:String, fileName:String){
        //get app file url
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{return}
        let fileURL = dir.appendingPathComponent(fileName)
        do{
            try writeString.write(to: fileURL, atomically: false, encoding: .utf8)
        }catch{
            print("Write Error!!")
        }
        //print("\(fileURL)")
        //print(writeString)
    }
    
    //Load text File
    func readFileToString(fileName:String) -> String{
        //get app file url
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{return ""}
        let fileURL = dir.appendingPathComponent(fileName)
        var readString = ""
        do{
            try readString = String.init(contentsOf: fileURL, encoding: .utf8)
        }catch{
            print("Read Error!!")
        }
        return readString
    }
    
    
//=================SECTION SHOW TIME=======================
    
    //sort dict
    func groupDictByTime(dict: [[String:Any]]) -> [String:[[String:Any]]] {
        let output = Dictionary.init(grouping: dict) { (item:Dictionary<String,Any>)->
            String in
            return item["date"] as! String
        }
        print(output)
        return output
    }
    
    //return how many section
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArrary.count
    }
    
    //input # of section return section title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keyArrary[section]
    }
}

    	
