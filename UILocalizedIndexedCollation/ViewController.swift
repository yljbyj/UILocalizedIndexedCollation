//
//  ViewController.swift
//  UIindexedCollation
//
//  Created by liuyang on 2017/12/11.
//  Copyright © 2017年 wooyh. All rights reserved.
//

import UIKit

class Person: NSObject {

    @objc var name: String?
}

class ViewController: UITableViewController {

    /// 数据源
    private var dataArray = [[Person]]()
    /// 每个 section 的标题
    private var sectionTitleArray = [String]()
    
    private var indexedCollation = UILocalizedIndexedCollation.current()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nameArray = ["赵", "钱", "孙", "李", "周", "孙", "李", "周", "孙", "李", "周", "吴", "郑", "王", "郭", "松", "宋", "长", "大", "小"]
        var personArray = [Person]()
        for name in nameArray {
            let p = Person()
            p.name = name
            personArray.append(p)
        }

        // 获得索引数, 这里是27个（26个字母和1个#）
        let indexCount = indexedCollation.sectionTitles.count

        // 每一个一维数组可能有多个数据要添加，所以只能先创建一维数组，到时直接取来用
        for _ in 0..<indexCount {
            let array = [Person]()
            dataArray.append(array)
        }

        // 将数据进行分类，存储到对应数组中
        for person in personArray {
            
            // 根据 person 的 name 判断应该放入哪个数组里
            // 返回值就是在 indexedCollation.sectionTitles 里对应的下标
            let sectionNumber = indexedCollation.section(for: person, collationStringSelector: #selector(getter: Person.name))
            
            // 添加到对应一维数组中
            dataArray[sectionNumber].append(person)
        }

        // 对每个已经分类的一维数组里的数据进行排序，如果仅仅只是分类可以不用这步
        for i in 0..<indexCount {
            
            // 排序结果数组
            let sortedPersonArray = indexedCollation.sortedArray(from: dataArray[i], collationStringSelector: #selector(getter: Person.name))
            // 替换原来数组
            dataArray[i] = sortedPersonArray as! [Person]
        }
        
        // 用来保存没有数据的一维数组的下标
        var tempArray = [Int]()
        for (i, array) in dataArray.enumerated() {
            
            if array.count == 0 {
                tempArray.append(i)
            } else {
                // 给标题数组添加数据
                sectionTitleArray.append(indexedCollation.sectionTitles[i])
            }
        }
        
        // 删除没有数据的数组
        for i in tempArray.reversed() {
            dataArray.remove(at: i)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let id = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: id)
        }
        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row].name
        return cell!
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleArray[section]
    }

    /// 这是右侧可以点击跳转的控件 title
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitleArray
    }
}

