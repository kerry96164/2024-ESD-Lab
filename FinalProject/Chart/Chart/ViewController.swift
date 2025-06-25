//
//  ViewController.swift
//  Chart
//
//  Created by Kerry Lu on 2024/6/1.
//

import UIKit
import DGCharts

class ViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    var r1:[Double?] = [20,15,01,nil,61,20,13,51,nil]
    var r2:[Double?] = [1,2,3,4,5,6,7,8,9,4]
    
    var dataEntries: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChart()
    }
    
    func updateChart(){
        var chartEntry1 = [ChartDataEntry]()
        var chartEntry2 = [ChartDataEntry]()
        var chartEntry3 = [ChartDataEntry]()
        var chartEntry4 = [ChartDataEntry]()
        
        for i in 0..<r1.count{
            if let r = r1[i]{
                let value = ChartDataEntry(x: Double(i), y: r)
                chartEntry1.append(value)
            }
        }
        for i in 0..<r2.count{
            if let r = r2[i]{
                let value = ChartDataEntry(x: Double(i), y: r)
                chartEntry2.append(value)
            }
        }
        

        let line = LineChartDataSet(entries: chartEntry1, label: "RSSI")
        line.colors = [.green]
        let data = LineChartData()
        data.append(line)
        lineChartView.data = data
        lineChartView.chartDescription.text = "Count"
    }

}
