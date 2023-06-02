//
//  TestCoreDataViewController.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 31/05/2023.
//

import UIKit
import CoreData
import SwiftUtils

class TestCoreDataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var users: [NSManagedObject] = []
    var money: Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TestTableViewCell.self)
        tableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
              guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
              let managedContext = appDelegate.persistentContainer.viewContext
              
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataUser")
              
              do {
                users = try managedContext.fetch(fetchRequest)
                tableView.reloadData()
              } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
              }

    }
    
    fileprivate func showStampPopup(_ thumImage: UIImage?, stamp: Int, dailyStamp: Int, animation: Bool, complete: @escaping () -> Void) {
        let vc = DisplayStampViewController()
        vc.totalStamp = stamp
        vc.isAnimation = animation
        vc.thumImage = thumImage
        vc.setCloseClosure({
            complete()
        })

        if let topViewController = presentedViewController {
            topViewController.present(vc, animated: animation, completion: nil)
        } else {
            present(vc, animated: animation, completion: nil)
        }
    }

    
    @IBAction func addInfo(_ sender: Any) {
        showStampPopup(nil, stamp: 21, dailyStamp: 1, animation: true) {
            print("aaaa")
        }
        let vc = DisplayStampViewController()
        navigationController?.present(vc, animated: true)
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//                let managedContext = appDelegate.persistentContainer.viewContext
//                let fetchRequest: NSFetchRequest<DataUser> = DataUser.fetchRequest()
//                let entity = NSEntityDescription.entity(forEntityName: "DataUser", in: managedContext)!
//                let user = NSManagedObject(entity: entity, insertInto: managedContext)
//                fetchRequest.predicate = NSPredicate(format:"money == 3000")
//                print("")
//
//                money += 1000
//                user.setValue("test category", forKey: "category")
//                user.setValue("test info", forKey: "info")
//                user.setValue("test descriptionInfo", forKey: "descriptionInfo")
//                user.setValue(money, forKey: "money")
//
//                do {
//                  try managedContext.save()
//                    users.append(user)
//                    tableView.reloadData()
//                } catch let error as NSError {
//                  print("Could not save. \(error), \(error.userInfo)")
//                }
    }
}

extension TestCoreDataViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user = users[indexPath.row]
    let cell = tableView.dequeue(TestTableViewCell.self)
    let category = (user.value(forKey: "category") as? String) ?? ""
    let money = (user.value(forKey: "money") as? Int64) ?? 0
      let descriptionInfo = (user.value(forKey: "descriptionInfo") as? String) ?? ""
      let info = (user.value(forKey: "info") as? String) ?? ""
      let text = "\(category) - \(money) - \(descriptionInfo) - \(info)"
      cell.money = text
    return cell
  }
}
