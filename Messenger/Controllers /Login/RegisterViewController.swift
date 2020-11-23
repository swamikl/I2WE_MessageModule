//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/19/20.
//  Copyright © 2020 Swamik Lamichhane and Jaden Kim. All rights reserved.
// Followed a tutorial for a IOS messenging app to learn how to use swift and building an IOS app
// https://www.youtube.com/playlist?list=PL5PR3UyfTWvdlk-Qi-dPtJmjTj-2YIMMf


import UIKit
import FirebaseAuth
import JGProgressHUD

// UIPickerViewDelegate, UIPickerViewDataSource
class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let spinner = JGProgressHUD(style: .light)
    
    // container for scrolling in case of small devices, we might not be able to fit everything
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "First Name"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Last Name"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    
    // the email field for when users might want to register
    // making it look pretty
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Email Address"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done // after writing password, we want to let users into the app
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Password"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true // to get * for password
        field.layer.cornerRadius = 12
        return field
    }()
    
    
    private let ageField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Age"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    private let schoolField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "School"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    private let genderField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Gender"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    private let sexualityField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Sexuality"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    private let majorField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Major"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.cornerRadius = 12
        return field
    }()
    
    // the sexuality, gender, school, and majors are pickerviews
    
    var schoolChoice: String?
    var schoolList = ["HMC", "CMC", "Pomona", "Scripps", "Pitzer", "Other"]
    
    var genderChoice: String?
    var genderList = ["Male", "Female", "Transgender", "Other"]
    
    var sexualityChoice: String?
    var sexualityList = ["Hetrosexual", "Homosexual", "Bi-sexual", "Other"]
    
    var majorChoice: String?
    var majorList = [ "Engineering", "Computer Science", "Philosophy", "Buisiness", "Economics","Math", "Psychology", "Finance", "History", "Art",
                     "Anthropology", "Chemistry",  "Music", "Physics",  "Other"]
    
    
    let genderPicker = UIPickerView()
    let sexualityPicker = UIPickerView()
    let schoolPicker = UIPickerView()
    let majorPicker = UIPickerView()
    
    
    func createSchoolPickerView()
         {
             schoolPicker.delegate = self
             schoolField.inputView = schoolPicker
             schoolPicker.backgroundColor = UIColor.white
             
         }
    
    func createSexualityPickerView()
    {
        sexualityPicker.delegate = self
        sexualityField.inputView = sexualityPicker
        sexualityPicker.backgroundColor = UIColor.white
        
    }
    
    func createGenderPickerView()
      {
          genderPicker.delegate = self
          genderField.inputView = genderPicker
          genderPicker.backgroundColor = UIColor.white
          
      }
    
    func createMajorPickerView()
    {
        majorPicker.delegate = self
        majorField.inputView = majorPicker
        majorPicker.backgroundColor = UIColor.white
        
    }
    
    func createToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.red
        toolbar.backgroundColor = UIColor.white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,action: #selector(RegisterViewController.closePickerView))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        schoolField.inputAccessoryView = toolbar
        genderField.inputAccessoryView = toolbar
        sexualityField.inputAccessoryView = toolbar
        majorField.inputAccessoryView = toolbar
    }
    
    @objc func closePickerView()
    {
        view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            var countrows = 4
            if pickerView == sexualityPicker {
                countrows = self.sexualityList.count
            } else if pickerView == genderPicker {
                countrows = self.genderList.count
            } else if pickerView == majorPicker {
                countrows = self.majorList.count
            } else if pickerView == self.schoolPicker {
                countrows = self.schoolList.count
            }
            return countrows
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
        {
            if pickerView == sexualityPicker {
                let titleRow = sexualityList[row]
                 return titleRow
            } else if pickerView == genderPicker {
                let titleRow = genderList[row]
                return titleRow
            } else if pickerView == schoolPicker {
                let titleRow = schoolList[row]
                return titleRow
            } else if pickerView == majorPicker {
                let titleRow = majorList[row]
                return titleRow
            }

            return ""
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            if pickerView == sexualityPicker {
                self.sexualityField.text = self.sexualityList[row]
            } else if pickerView == genderPicker {
                self.genderField.text = self.genderList[row]
            } else if pickerView == schoolPicker {
                self.schoolField.text = self.schoolList[row]
            } else if pickerView == majorPicker {
                self.majorField.text = self.majorList[row]
            }
    }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 200.0
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 60.0
        }

    
    // for the blank person to show
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true // so it cannot overflow
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "log in"
        
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
//                                                            style: .done,
//                                                            target: self,
//                                                            action: #selector(didTapRegister))
        
        
        
        // where to go when login button is pressed
        registerButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        // when user hits return on password it calls login function
        emailField.delegate = self
        passwordField.delegate = self
        genderField.delegate = self
        majorField.delegate = self
        ageField.delegate = self
        
        // adding subviews: what is being shown on the screen
        // we are adding elements to the scroll view, so if page fills up, the container will allow for
        // scrollable content
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(ageField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        // the picker views
        scrollView.addSubview(schoolField)
        createSchoolPickerView()
        createToolbar()
        scrollView.addSubview(majorField)
        createMajorPickerView()
        scrollView.addSubview(genderField)
        createGenderPickerView()
        scrollView.addSubview(sexualityField)
        createSexualityPickerView()
        
        // the register button
        scrollView.addSubview(registerButton)
        
        // to make the image userinteractable
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        // want to make it so that the user can add a profile picture when the icon is tapped
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    
    // to give the frame for the image view
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: 375, height: 800)
        
        // the view.width comes from the extenstions.swift file
        let size = scrollView.width/3
        // the logo size
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        // create the image to look like a circle
        imageView.layer.cornerRadius = imageView.width/2.0
        
        // using the standard values for the text boxes and stuff, can change to make look better
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width - 60,
                                      height: 46)
        
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+10,
                                     width: scrollView.width - 60,
                                     height: 46)
        
        ageField.frame = CGRect(x: 30,
                                y: lastNameField.bottom+10,
                                width: scrollView.width - 60,
                                height: 46)
        
        schoolField.frame = CGRect(x: 30,
                                       y: ageField.bottom+10,
                                       width: scrollView.width - 60,
                                       height: 46)
        majorField.frame = CGRect(x: 30,
                                   y: schoolField.bottom+10,
                                   width: scrollView.width - 60,
                                   height: 46)
        
        genderField.frame = CGRect(x: 30,
                                y: majorField.bottom+10,
                                width: scrollView.width - 60,
                                height: 46)
        
        sexualityField.frame = CGRect(x: 30,
                                    y: genderField.bottom+10,
                                    width: scrollView.width - 60,
                                    height: 46)
        
        
        emailField.frame = CGRect(x: 30,
                                  y: sexualityField.bottom+10,
                                  width: scrollView.width - 60,
                                  height: 46)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 46)
        
        
        registerButton.frame = CGRect(x: 30,
                                      y: passwordField.bottom + 26,
                                      width: scrollView.width - 100,
                                      height: 46)
        registerButton.center.x = UIScreen.main.bounds.width/2
    }
    
    
    // to check if they actually signed in
    // also making sure password is at least 6 char long
    @objc private func registerButtonTapped(){
        
        // getting rid of keyboard after user has entered things
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        ageField.resignFirstResponder()
        sexualityField.resignFirstResponder()
        genderField.resignFirstResponder()
        schoolField.resignFirstResponder()
        majorField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let age = ageField.text,
            let email = emailField.text,
            let password = passwordField.text,
            let gender = genderField.text,
            let school = schoolField.text,
            let sexuality = sexualityField.text,
            let major = majorField.text,
            !email.isEmpty,
            !firstName.isEmpty,
            !age.isEmpty,
            !lastName.isEmpty,
            !gender.isEmpty,
            !sexuality.isEmpty,
            !major.isEmpty,
            !password.isEmpty,
            password.count >= 6
            else{
                alertUserRegisterError()
                return
        }
        
        spinner.show(in: view)
        
        // FIREBASE LOGIN STUFF
        
        // first check if a user with that email already is in our database
        DatabaseManager.shared.userExistis(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            // all UI stuff needs to be done in the main thread
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !exists else {
                // this is where the user alredy exists
                strongSelf.alertUserRegisterError(message: "User with that email already exists")
                return
            }
            // creating the user with their given email and password
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error creating user \(error)")
                    return
                }
                
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
                
                let appUser = AppUser(firstName: firstName,
                                      lastName: lastName,
                                      emailAddress: email,
                                      uid: "",
                                      age: age,
                                      gender: gender,
                                      sexuality: sexuality,
                                      school: school,
                                      major: major,
                                      name: firstName + " " + lastName)
                DatabaseManager.shared.insertUser(with: appUser, completion: { success in
                    if success {
                        // upload image
                        guard let image = strongSelf.imageView.image,
                            let data = image.pngData() else {
                                return
                        }
                        let fileName = appUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("storage manager error: \(error)")
                            }
                            
                        })
                    }
                })
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
        
    }
    
    func alertUserRegisterError(message: String = "Plese enter all info to create new account"){
        let alert = UIAlertController(title: "OH NO",
                                      message: message,
                                      preferredStyle: .alert)
        
        // allow the user to get rid of alert
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

// good way to seperate code is to make an extention
// this handels the validation part so the user dosent have to press the login button directly
extension RegisterViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == firstNameField{
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField {
            emailField.becomeFirstResponder()
        }
        else if textField == ageField {
            schoolField.becomeFirstResponder()
        }
        else if textField == schoolField {
            genderField.becomeFirstResponder()
        }
        else if textField == genderField {
            sexualityField.becomeFirstResponder()
        }
        else if textField == sexualityField {
            emailField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}



// for choosing the picture or taking a picture for the profile picture
// when users want to choose a profile pic, they get options on how to choose it
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "Select Picture",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        // allowing the user to crop their profile picture
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        // allowing the user to crop their profile picture
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        // to get the information of the pic selected from the info. the edited image is if the person crops the image
        // the as casts it as a UI image
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        // updating the image to be the selected image
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
