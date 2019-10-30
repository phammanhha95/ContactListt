//
//  MainViewController.swift
//  ContactList
//
//  Created by Phạm Mạnh Hà on 9/28/19.
//  Copyright © 2019 Phạm Mạnh Hà. All rights reserved.
//

import UIKit

enum GroupType: String {
    case friend = "Bạn bè"
    case family = "Gia đình"
    case another = "Khác"
}

class MainViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var contacts = [Contact]()
    var currentcontacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.04, green:0.04, blue:0.04, alpha:1.0)
      // searchBar.backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        searchBar.barTintColor = UIColor(red:0.04, green:0.04, blue:0.04, alpha:1.0)
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ContactList"
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white]
       // navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newData))
        setuptableView()
        createData()
        searchBar.delegate = self
            }
    @objc func newData(){
        // khởi tạo màn 2
        let createVC = CreateContactViewController()
        createVC.title = "Liên hệ mới"
        
        // hứng closure (hứng dữ liệu từ màn 2)
        createVC.passObject = {
            [weak self] data in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.contacts.append(data)
            strongSelf.currentcontacts.append(data)
            strongSelf.tableView.reloadData()
            
        }
        // chuyển sang màn 2
        navigationController?.pushViewController(createVC, animated: true)
        
    }
    func setuptableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let viewbackground = UIView()
        viewbackground.backgroundColor = UIColor(red:0.04, green:0.04, blue:0.04, alpha:1.0)
        tableView.tableFooterView = viewbackground
        tableView.backgroundColor = UIColor(red:0.04, green:0.04, blue:0.04, alpha:1.0)
    }
    func createData(){
        contacts = [
            Contact(photo: UIImage(named: "spiderman"), name: "Spiderman", phone: "0988321135", note: "Nhện nhọ", group: .another),
            Contact(photo: UIImage(named: "hulk"), name: "Hulk", phone: "098620465", note: "Khổng Lồ Xanh", group: .friend),
            Contact(photo: UIImage(named: "batman"), name: "Batman", phone: "0364329856", note: "Phantom", group: .family),
            Contact(photo: UIImage(named: "ironman"), name: "Ironman", phone: "0364329856", note: "3000", group: .family),
            Contact(photo: UIImage(named: "harleyquinn"), name: "Harley Quinn", phone: "0364329859", note: "mcu", group: .friend),
            Contact(photo: UIImage(named: "wonderwoman"), name: "Wonder Woman", phone: "0364329851", note: "<><><> ", group: .another),
            
        ]
        currentcontacts = contacts
    }

        

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentcontacts = contacts.filter({ contact -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return contact.name.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return contact.group == .family }
                return contact.name.lowercased().contains(searchText.lowercased()) &&
                    contact.group == .family
            case 2:
                if searchText.isEmpty { return contact.group == .friend }
                return contact.name.lowercased().contains(searchText.lowercased()) &&
                    contact.group == .friend
            case 3:
                if searchText.isEmpty { return contact.group == .another }
                return contact.name.lowercased().contains(searchText.lowercased()) &&
                    contact.group == .another
            default:
                return false
            }
        })
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
             currentcontacts = contacts
        case 1:
            currentcontacts = contacts.filter({ contact -> Bool in
                contact.group == GroupType.family
            })
        case 2:
            currentcontacts = contacts.filter({ contact -> Bool in
                contact.group == GroupType.friend
            })
        case 3:
            currentcontacts = contacts.filter({ contact -> Bool in
                contact.group == GroupType.another
            })
        default:
            break
        }
        tableView.reloadData()
    }
    
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentcontacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
        cell.backgroundColor = UIColor(red:0.04, green:0.04, blue:0.04, alpha:1.0)
        cell.selectionStyle = .none
        cell.avatarImageView.image = currentcontacts[indexPath.row].photo
        cell.nameLabel.text = currentcontacts[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        let countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        countLabel.center = viewFooter.center
        countLabel.text = "\(currentcontacts.count) liên hệ "
        countLabel.textColor = .white
        countLabel.font = UIFont.boldSystemFont(ofSize: 15)
        viewFooter.addSubview(countLabel)
        viewFooter.backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        return viewFooter
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // khởi tạo nút delete kiểu UITableViewRowAction
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("delete")
          
            self.contacts.remove(at: indexPath.row)
            self.currentcontacts.remove(at: indexPath.row)
            
            //self.contacts = self.contacts.remove(at: currentcontacts[indexPath.row])
           
            self.tableView.reloadData()
        }
        
        // khởi tạo nút edit kiểu UITableViewRowAction
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            print("edit")
            let newContactVC = CreateContactViewController()
            let _ = newContactVC.view
            
            newContactVC.avatarImage.image = self.currentcontacts[indexPath.row].photo
            newContactVC.nameTextField.text = self.currentcontacts[indexPath.row].name
            newContactVC.phoneTextField.text = self.currentcontacts[indexPath.row].phone
            newContactVC.noteTextView.text = self.currentcontacts[indexPath.row].note
            newContactVC.groupTextField.text = self.currentcontacts[indexPath.row].group.rawValue
            
            newContactVC.passObject = {
                [weak self] newData in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.contacts[indexPath.row].photo = newData.photo
                strongSelf.contacts[indexPath.row].name = newData.name
                strongSelf.contacts[indexPath.row].phone = newData.phone
                strongSelf.contacts[indexPath.row].note = newData.note
                strongSelf.contacts [indexPath.row].group = newData.group
                strongSelf.tableView.reloadData()
                
            }
            self.navigationController?.pushViewController(newContactVC, animated: true)
        }
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        
        // trả về mảng gồm 2 nút
        return [delete, edit]
    }
    
    // hàm chọn cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("đã chọn cell")
        let newContactVC = CreateContactViewController()
        let _ = newContactVC.view
        
        newContactVC.avatarImage.image = self.currentcontacts[indexPath.row].photo
        newContactVC.nameTextField.text = self.currentcontacts[indexPath.row].name
        newContactVC.phoneTextField.text = self.currentcontacts[indexPath.row].phone
        newContactVC.noteTextView.text = self.currentcontacts[indexPath.row].note
        newContactVC.groupTextField.text = self.currentcontacts[indexPath.row].group.rawValue
        
        newContactVC.passObject = {
            [weak self] newData in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contacts[indexPath.row].photo = newData.photo
            strongSelf.contacts[indexPath.row].name = newData.name
            strongSelf.contacts[indexPath.row].phone = newData.phone
            strongSelf.contacts[indexPath.row].note = newData.note
            strongSelf.contacts [indexPath.row].group = newData.group
            strongSelf.tableView.reloadData()
            
        }
        self.navigationController?.pushViewController(newContactVC, animated: true)
    }
    
}
