//
//  ModelViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 11/12/2021.
//

import UIKit
import Firebase

class ModelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var brand: String?
    var models: [String] = []
    var model: String = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ModelCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadData()
    }
    
    func loadData() {
        db.collection(K.Event.colection).whereField(K.Event.brand, isEqualTo: brand ?? "").getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let model = data[K.Event.model] as? String {
                         
                            self.models.append(model)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    self.models = Array(Set(self.models))
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModelToGlobal" {
            let destinationVC = segue.destination as! GlobalStatViewController
            destinationVC.model = model
        }
    }
}

extension ModelViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ModelCell
        cell.nameLabel.text = models[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model = models[indexPath.row]
        self.performSegue(withIdentifier: "ModelToGlobal", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
