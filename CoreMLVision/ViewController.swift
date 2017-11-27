//
//  ViewController.swift
//  CoreMLVision
//
//  Created by cao longjian on 2017/11/6.
//  Copyright © 2017年 cao longjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = self.makeTableView()
    let dataArray = ["人脸识别","特征识别","文字识别"]//,"实时检测Face","实时动态添加"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
    
}

// MARK - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = self.dataArray[indexPath.row];
        return cell!
    }
    
}

// MARK - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content: String = self.dataArray[indexPath.row];
        if content == "人脸识别" {
            let vc = FaceViewController();
            vc.detectionType = .Face
            self.navigationController?.pushViewController(vc, animated: true)
        } else if content == "特征识别" {
            let vc = FaceViewController();
            vc.detectionType = .Landmark
            self.navigationController?.pushViewController(vc, animated: true)
        } else if content == "文字识别" {
            let vc = FaceViewController();
            vc.detectionType = .TextRectangles
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}

