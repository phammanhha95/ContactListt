//
//  CreateContactViewController.swift
//  ContactList
//
//  Created by Phạm Mạnh Hà on 9/28/19.
//  Copyright © 2019 Phạm Mạnh Hà. All rights reserved.
//

import UIKit
import Photos

class CreateContactViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    
    let groups = [ GroupType.family, GroupType.friend, GroupType.another]
    var selectedGroup : String?
    
    // Khởi tạo
    let imagePicker = UIImagePickerController()
    
    // khai báo closure
    var passObject: ((Contact) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.04, green:0.04, blue:0.04, alpha:1.0)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        imagePicker.delegate = self
        avatarImage.isUserInteractionEnabled = true
        noteTextView.layer.borderWidth = 2
        noteTextView.layer.borderColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0).cgColor
        view1.backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        view2.backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        view3.backgroundColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        configControl()
        creategroupPicker()
        createToolbar()
        groupTextField.text = GroupType.family.rawValue
    }
    
    func configControl() {
        // gesture cho ảnh
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        avatarImage.addGestureRecognizer(tapGesture)
        avatarImage.layer.borderWidth = 2
        avatarImage.layer.borderColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0).cgColor
        avatarImage.layer.cornerRadius = 50
        avatarImage.contentMode = .scaleAspectFill
        
        // action cho nuts
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
    
    }
    @objc func selectImage(){
        print("selected")
        let alert = UIAlertController(title: "App", message: "Chọn ảnh từ", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        let camera = UIAlertAction(title: "Máy ảnh", style: .default, handler: { (_) in
            // gọi hàm mở camera
            self.fromCamera()
        })
        let libray = UIAlertAction(title: "Thư viện", style: .default, handler: { (_) in
            // gọi hàm mở thư viện
            self.fromGallery()
        })
        
        alert.addAction(camera)
        alert.addAction(libray)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    @objc func saveItem(){
        print("saved")
        // truyền dữ liệu vào trong closure
        passObject?(Contact(photo: avatarImage.image, name: nameTextField.text!, phone: phoneTextField.text!, note: noteTextView.text, group: GroupType(rawValue: groupTextField.text!)! ))
        // popViewController: back về màn trước nó
        
        navigationController?.popViewController(animated: true)
    }
    func setting(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.openURL(settingsUrl)
            } else {
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    // mở thư viện
    private func fromGallery(){
        func choosePhoto(){
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        // khai báo biến để lấy quyền truy cập
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // quyền truy cập đã được cấp
            choosePhoto()
        }else if (status == PHAuthorizationStatus.denied) {
            // quyền truy cập bị từ chối
            print("photo denied")
            setting()
            
        }else if (status == PHAuthorizationStatus.notDetermined) {
            
            // quyền truy cập chưa được xác nhận
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    choosePhoto()
                }else {
                    print("Không được cho phép truy cập vào thư viện ảnh")
                    self.setting()
                }
            })
        }else if (status == PHAuthorizationStatus.restricted) {
            // Truy cập bị hạn chế, thông thường sẽ không xảy ra
            print("Restricted access")
            setting()
        }
    }
    
    // mở camera
    private func fromCamera(){
        func takePhoto(){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.cameraDevice = .front
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true,completion: nil)
            }else{
                let alert = UIAlertController(title: "Sorry", message: "Không tìm thấy camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                takePhoto()
            } else {
                print("camera denied")
                self.setting()
            }
        }
    }
    
    // hàm này xử lý sau khi đã chọn được ảnh thì làm gì
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("error: \(info)")
            return
        }
        
        self.avatarImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    func creategroupPicker() {
        let groupPicker = UIPickerView()
        groupPicker.delegate = self
        groupTextField.inputView = groupPicker
        groupPicker.backgroundColor = .black
    }
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .black
        toolBar.tintColor = .white
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateContactViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        groupTextField.inputAccessoryView = toolBar
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension CreateContactViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row].rawValue
    
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedGroup = groups[row].rawValue
        groupTextField.text = selectedGroup
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)
        
        label.text = groups[row].rawValue
        
        return label
    }
}


