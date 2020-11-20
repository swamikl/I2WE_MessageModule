//
//  SearchViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 11/10/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import JGProgressHUD

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    private let spinner = JGProgressHUD(style: .light)
    
    // container for scrolling in case of small devices, we might not be able to fit everything
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let ageField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Age"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let schoolField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "School"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let genderField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Gender"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let sexualityField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Sexuality"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let majorField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemPink.cgColor
        field.placeholder = "Major"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    // the sexuality, gender, school, and majors are pickerviews
    
    var schoolChoice: String?
    let searchSchoolList = ["HMC", "CMC", "Pomona", "Scripps", "Pitzer", "Other"]
    
    var genderChoice: String?
    let searchGenderList = ["Male", "Female", "Transgender", "Other"]
    
    var sexualityChoice: String?
    let searchSexualityList = ["Hetrosexual", "Homosexual", "Bisexual", "Other"]
    
    var majorChoice: String?
    let searchMajorList = [ "Engineering", "Computer Science", "Philosophy", "Business", "Economics", "Math", "Psychology", "Finance", "History", "Art", "Anthropology", "Chemistry",  "Music", "Physics",  "Other"]
    
    
    let searchGenderPicker = UIPickerView()
    let searchSexualityPicker = UIPickerView()
    let searchSchoolPicker = UIPickerView()
    let searchMajorPicker = UIPickerView()
    
    
    func createSearchSchoolPickerView()
    {
        searchSchoolPicker.delegate = self
        schoolField.inputView = searchSchoolPicker
        searchSchoolPicker.backgroundColor = UIColor.white
        
    }
    
    func createSearchSexualityPickerView()
    {
        searchSexualityPicker.delegate = self
        sexualityField.inputView = searchSexualityPicker
        searchSexualityPicker.backgroundColor = UIColor.white

    }
    
    func createSearchGenderPickerView()
    {
        searchGenderPicker.delegate = self
        genderField.inputView = searchGenderPicker
        searchGenderPicker.backgroundColor = UIColor.white
        
    }
    
    func createSearchMajorPickerView()
    {
        searchMajorPicker.delegate = self
        majorField.inputView = searchMajorPicker
        searchMajorPicker.backgroundColor = UIColor.white
        
    }
    
    func createToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.red
        toolbar.backgroundColor = UIColor.white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,action: #selector(SearchViewController.searchClosePickerView))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        schoolField.inputAccessoryView = toolbar
        genderField.inputAccessoryView = toolbar
        sexualityField.inputAccessoryView = toolbar
        majorField.inputAccessoryView = toolbar
    }
    
    @objc func searchClosePickerView()
    {
        view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows = 3 //4
        if pickerView == searchGenderPicker {
            countrows = self.searchGenderList.count
        } else if pickerView == searchSexualityPicker {
            countrows = self.searchSexualityList.count
        } else if pickerView == searchMajorPicker {
            countrows = self.searchMajorList.count
        } else if pickerView == searchSchoolPicker {
            countrows = self.searchSchoolList.count
        }
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == searchGenderPicker {
            let titleRow = searchGenderList[row]
            return titleRow
//        } else if pickerView == searchSexualityPicker {
//            let titleRow = searchSexualityList[row]
//            return titleRow
        } else if pickerView == searchSchoolPicker {
            let titleRow = searchSchoolList[row]
            return titleRow
        } else if pickerView == searchMajorPicker {
            let titleRow = searchMajorList[row]
            return titleRow
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == searchGenderPicker {
            self.genderField.text = self.searchGenderList[row]
        } else if pickerView == searchSexualityPicker {
            self.sexualityField.text = self.searchSexualityList[row]
        } else if pickerView == searchSchoolPicker {
            self.schoolField.text = self.searchSchoolList[row]
        } else if pickerView == searchMajorPicker {
            self.majorField.text = self.searchMajorList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true // so it cannot overflow
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    // for the logo to show
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        // where to go when search button is pressed
        //MARK: when the searchbutton is tapped, this function is getting called
        searchButton.addTarget(self,
                               action: #selector(didTapSearch),
                               for: .touchUpInside)
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.addSubview(ageField)
        
        // the picker views
        scrollView.addSubview(schoolField)
        createSearchSchoolPickerView()
        createToolbar()
        scrollView.addSubview(majorField)
        createSearchMajorPickerView()
        scrollView.addSubview(genderField)
        createSearchGenderPickerView()
        scrollView.addSubview(sexualityField)
        createSearchSexualityPickerView()
        
        // the search button
        scrollView.addSubview(searchButton)
        scrollView.isUserInteractionEnabled = true
        
        searchSchoolPicker.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        // the view.width comes from the extenstions.swift file
        // the logo size
        
        let size = scrollView.width/3
        // the logo size
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        
        ageField.frame = CGRect(x: 30,
                                y: imageView.bottom+10,
                                width: scrollView.width - 60,
                                height: 52)
        
        schoolField.frame = CGRect(x: 30,
                                       y: ageField.bottom+10,
                                       width: scrollView.width - 60,
                                       height: 52)
        majorField.frame = CGRect(x: 30,
                                   y: schoolField.bottom+10,
                                   width: scrollView.width - 60,
                                   height: 52)
        
        genderField.frame = CGRect(x: 30,
                                y: majorField.bottom+10,
                                width: scrollView.width - 60,
                                height: 52)
        
        sexualityField.frame = CGRect(x: 30,
                                    y: genderField.bottom+10,
                                    width: scrollView.width - 60,
                                    height: 52)
        
        searchButton.frame = CGRect(x: 30,
                                      y: genderField.bottom+10,
                                      width: scrollView.width - 60,
                                      height: 52)
        
        
    }
    
    //MARK: Maybe this is the code for the searchbutton tapped, combine with the didTapSearch
    @objc private func searchButtonTapped(){
        ageField.resignFirstResponder()
        sexualityField.resignFirstResponder()
        genderField.resignFirstResponder()
        schoolField.resignFirstResponder()
        majorField.resignFirstResponder()
        
        guard let age = ageField.text,
        let gender = genderField.text,
        let school = schoolField.text,
        let sexuality = sexualityField.text,
        let major = majorField.text
            else{
                return
        }
        
        spinner.show(in: view)
        
        // Firebase searching stuff
        
    }
    
    // MARK: didTapSearch code
    @objc private func didTapSearch(){
        let vc = RegisterViewController()
        vc.title = "Search Users"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
