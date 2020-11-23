//
//  SearchViewController.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 11/10/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
//

import UIKit
import SwiftUI
import JGProgressHUD

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    private let spinner = JGProgressHUD(style: .light)

    private var hasFetched = false
    public var completion: (([String:String]) -> Void)?

    private var users = [[String: String]]()
    private var results = [[String: String]]()

    private var query = [String: String]()

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
        field.layer.borderWidth = 2
        // field.layer.borderColor = UIColor.systemTeal.cgColor
        field.layer.borderColor = .init(srgbRed: 255, green: 182, blue: 193, alpha: 255)
        field.minimumFontSize = 12
        field.placeholder = "Age"
        // to make the text not flush with the box
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.borderStyle = .none
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
        return field
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()

    // if users search and find no one with that name
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label

    }()

    // the sexuality, gender, school, and majors are pickerviews

    var schoolChoice: String?
    let searchSchoolList = ["HMC", "CMC", "Pomona", "Scripps", "Pitzer", "Other"]

    var genderChoice: String?
    let searchGenderList = ["Male", "Female", "Transgender", "Other"]

    var sexualityChoice: String?
    let searchSexualityList = ["Hetrosexual", "Homosexual", "Bi-sexual", "Other"]

    var majorChoice: String?
    let searchMajorList = [ "Engineering", "Computer Science", "Philosophy", "Buisiness", "Economics","Math", "Psychology", "Finance", "History", "Art",
                            "Anthropology", "Chemistry",  "Music", "Physics",  "Other"]


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
        var countrows = 4
        if pickerView == searchSexualityPicker {
            countrows = self.searchSexualityList.count
        } else if pickerView == searchGenderPicker {
            countrows = self.searchGenderList.count
        } else if pickerView == searchMajorPicker {
            countrows = self.searchMajorList.count
        } else if pickerView == searchSchoolPicker {
            countrows = self.searchSchoolList.count
        }
        return countrows
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == searchSexualityPicker {
            let titleRow = searchSexualityList[row]
            return titleRow
        } else if pickerView == searchGenderPicker {
            let titleRow = searchGenderList[row]
            return titleRow
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

        if pickerView == searchSexualityPicker {
            self.sexualityField.text = self.searchSexualityList[row]
        } else if pickerView == searchGenderPicker {
            self.genderField.text = self.searchGenderList[row]
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
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true // so it cannot overflow
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        return button
    }()

    // for the logo to show
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "logo_correct")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.

        // where to go when search button is pressed
        //MARK: when the searchbutton is tapped, this function is getting called
        searchButton.addTarget(self,
                               action: #selector(searchButtonTapped),
                               for: .touchUpInside)


        view.addSubview(scrollView)
        // scrollView.addSubview(imageView)

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
        scrollView.contentSize = CGSize(width: 375, height: 600)

        // the view.width comes from the extenstions.swift file
        // the logo size

        let size = scrollView.width/3
         // the logo size
//        imageView.frame = CGRect(x: (scrollView.width - size)/2 + 10,
//                                 y: 50,
//                                 width: size,
//                                 height: size)


        ageField.frame = CGRect(x: 30,
                                   y: 175,
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

        searchButton.frame = CGRect(x: 30,
                                    y: sexualityField.bottom+26,
                                    width: scrollView.width - 100,
                                    height: 46)
        searchButton.center.x = UIScreen.main.bounds.width/2


        tableView.frame = view.bounds
//        noResultsLabel.frame = CGRect(x: view.width/4,
//                                      y: (view.height-200)/2,
//                                      width: view.width/2,
//                                      height: 200)

    }

    @objc private func searchButtonTapped() {
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
        else {
            return
        }

        let myQuery = [FBKeys.User.age: age,
                       FBKeys.User.gender: gender,
                       FBKeys.User.school: school,
                       FBKeys.User.sexuality: sexuality,
                       FBKeys.User.major: major
        ]

        spinner.show(in: view)

        // Firebase searching stuff

        searchUsers(query: myQuery)
        hasFetched = true

        updateUI()
    }
    // MARK: didTapSearch code
//    @objc private func didTapSearch() {
//
////        hasFetched = true
////        updateUI()
//    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start the cconvo
        let targetUserData = results[indexPath.row]

        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })

        completion?(targetUserData)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }


    func searchUsers(query: [String: String]) {
        // check if array has firebase results
        print("pre-filter: \(self.users)")
        if hasFetched {
            // if it does: filter
            self.filterUsers(with: query)
            print("filtered users no fetch: \(results)")
        }
        else {
            // if not, fetch then filter
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    print("pre-filtered users fetch: \(usersCollection)")
                    self?.filterUsers(with: query)
                    print("filtered users fetch: \(self!.results)")
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
        }

    }

    func filterUsers(with params: [String: String]) {
        // update the UI: show the results or show no results label
        guard hasFetched else{
            return
        }

        self.spinner.dismiss()

        var results = [[String:String]]()
        for (key, val) in params {
            if val != "" {
                results = self.users.filter({
                    if $0[key]! == val {
                        return true
                    }
                    return false
                })
            }
        }

        self.results = results
    }



    func updateUI() {
        if results.isEmpty {
//            self.noResultsLabel.isHidden = true
//            self.tableView.isHidden = true
        }
        else {
//            self.noResultsLabel.isHidden = true
//            self.tableView.isHidden = false
//            self.tableView.reloadData()
            let vc = ResultsViewController()
            vc.results = self.results
            vc.title = "Results"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
