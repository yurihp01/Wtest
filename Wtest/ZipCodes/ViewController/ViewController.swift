//
//  ViewController.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        activityIndicator.style = .medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityIndicator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        activityIndicator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.bringSubviewToFront(activityIndicator)
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        return view
    }()
    
    weak var coordinator: ViewCoordinator?
    var viewModel: ViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        getCSV()
    }
    
    func getCSV() {
        loadingView.isHidden = false
        
        if getZipCodes().count == 0 {
            getCSVFromApi()
        }
    }
        
    func getCSVFromApi() {
        viewModel?.getCSVFromApi(completion: { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.loadingView.isHidden = true
                }
            }
        })
    }
    
    @discardableResult
    func getZipCodes(by text: String = "") -> [ZipCodeEntity] {
        loadingView.isHidden = true
        
        var zipCodes = viewModel?.zipCodes ?? []
        
        viewModel?.getZipCodes(by: text, completion: { result in
            switch result {
            case .success(let response):
                zipCodes = response
            case .failure(let error):
                print(error)
            }
        })
        
        return zipCodes
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let text = searchBar.text, text.isEmpty {
            return 0
        }
        let zipCodes = viewModel?.zipCodes ?? []
        return zipCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let zipCodes = viewModel?.zipCodes ?? []
        cell.textLabel?.text = zipCodes[indexPath.row].zipCode
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchedText = searchBar.text ?? ""
        getZipCodes(by: searchedText)
        tableView.reloadData()
    }
}
