//
//  BrandViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 11/12/2021.
//

import UIKit
import Firebase

class BrandViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    
    var events: [String] = []
    var brands: [String] = []
    var brand: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ModelCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadData()
    }
    
    func loadData() {
        db.collection(K.Event.colection).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let brand = data[K.Event.brand] as? String {
                         
                            self.events.append(brand)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    self.brands = Array(Set(self.events))
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BrandToModel" {
            let destinationVC = segue.destination as! ModelViewController
            destinationVC.brand = brand
        }
    }
}

extension BrandViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ModelCell
        cell.nameLabel.text = brands[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        brand = brands[indexPath.row]
        self.performSegue(withIdentifier: "BrandToModel", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
