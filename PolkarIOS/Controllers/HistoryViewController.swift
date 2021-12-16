//
//  HistoryViewController.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 21/10/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var events: [Event] = []
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70.0
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "Event Cell")
        
        loadData()
    }
    
    func loadData() {
        db.collection(K.Event.colection).whereField(K.Event.userUID, isEqualTo: Auth.auth().currentUser?.uid ?? "").order(by: K.Event.time, descending: true).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data form firestore. \(e)")
            } else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let UID = data[K.Event.UID] as? String,
                           let carUID = data[K.Event.carUID] as? String,
                           let date = data[K.Event.date] as? String,
                           let description = data[K.Event.description] as? String,
                           let mileage = data[K.Event.mileage] as? Float,
                           let price = data[K.Event.price] as? Float,
                           let type = data[K.Event.type] as? String,
                           let reminder = data[K.Event.reminder] as? Bool,
                           let mileageReminder = data[K.Event.mileageReminder] as? Float,
                           let model = data[K.Event.model] as? String,
                           let brand = data[K.Event.brand] as? String,
                           let userUID = data[K.Event.userUID] as? String {
                         
                            let newEvent = Event(UID: UID, carUID: carUID, date: date, description: description, mileage: mileage, price: price, type: type, reminder: reminder, mileageReminder: mileageReminder, model: model, brand: brand, userUID: userUID)
                            self.events.append(newEvent)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventToEditEvent" {
            let destinationVC = segue.destination as! EditEventViewController
            destinationVC.event = event
        }
    }
    
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell", for: indexPath) as! EventCell
        
        cell.nameLabel.text = events[indexPath.row].brand + " " + events[indexPath.row].model
        cell.dateLabel.text = events[indexPath.row].date
        cell.mileageLabel.text = String(events[indexPath.row].mileage)
        cell.typeLabel.text = events[indexPath.row].type
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        event = events[indexPath.row]
        self.performSegue(withIdentifier: "EventToEditEvent", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
