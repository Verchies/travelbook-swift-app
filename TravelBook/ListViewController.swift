//
//  ListViewController.swift
//  TravelBook
//
//  Created by Emre Köseoğlu on 4.08.2023.
//

import CoreData
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    var titleArray = [String]()
    var idArray = [UUID]()
    var choosenTitle = ""
    var choosenTitleID: UUID?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))

        tableView.delegate = self
        tableView.dataSource = self

        getData()
    }

    override func viewWillAppear(_: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }

    @objc func addButtonClicked() {
        choosenTitle = ""
        performSegue(withIdentifier: "toVC", sender: nil)
    }

    @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")

        do {
            let results = try context.fetch(request)

            if results.count > 0 {
                titleArray.removeAll(keepingCapacity: false)
                idArray.removeAll(keepingCapacity: false)

                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    tableView.reloadData()
                }
            }
        } catch {
            print("HATA")
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        titleArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenTitle = titleArray[indexPath.row]
        choosenTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "toVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "toVC" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = choosenTitle
            destinationVC.selectedTitleID = choosenTitleID
        }
    }
}
