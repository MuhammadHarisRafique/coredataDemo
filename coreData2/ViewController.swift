//
//  ViewController.swift
//  coreData2
//
//  Created by Higher Visibility on 7/23/16.
//  Copyright © 2016 Higher Visibility. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var people  = [NSManagedObject]()
    var cell_index: Int?
    
    @IBOutlet weak var txtbox: UITextField!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var delete: UIButton!
    

    @IBOutlet weak var tableviewList: UITableView!
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let mycell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let myperson = people[indexPath.row]
        mycell.textLabel?.text = myperson.valueForKey("name") as? String
        return mycell
        
    }
    
    func save(name: String){
        let appdelete = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext  = appdelete.managedObjectContext
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let myperson = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        myperson.setValue(name, forKey: "name")
        
    
        
        do{
            try managedContext.save()
            people.append(myperson)
        }catch let error as NSError{
              print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.cell_index = indexPath.row
        
    }
    
    func deleteRecord(){
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedcontext = appdelegate.managedObjectContext
        managedcontext.deleteObject(people[cell_index!])
        appdelegate.saveContext()
        people.removeAtIndex(cell_index!)
        tableviewList.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedcontext = appdelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        do{
            let result = try managedcontext.executeFetchRequest(fetchRequest)
            self.people  = result as! [NSManagedObject]
        }catch let error as NSError{
             print("Could not fetch \(error), \(error.userInfo)")
        }
     self.txtbox.layer.borderWidth = 2
    self.txtbox.layer.borderColor = UIColor.blackColor().CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func add_record(sender: AnyObject) {
         if self.txtbox.text != nil && self.txtbox.text != ""{
            self.save(self.txtbox.text!)
            self.tableviewList.reloadData()
         }
        
        
        
    }

    @IBAction func delete_record(sender: AnyObject) {
        if cell_index != nil{
            self.deleteRecord()
        }
        
        
        
    }
}

