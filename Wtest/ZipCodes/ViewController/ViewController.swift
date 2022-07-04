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
    @IBOutlet weak var indicatorView: UIView!
    
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
        if !UserDefaults.standard.bool(forKey: "hasFinished") {
            getCSVFromApi()
        }
    }
        
    func getCSVFromApi() {
        viewModel?.getCSVFromApi(completion: { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.indicatorView.removeFromSuperview()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.indicatorView.removeFromSuperview()
                }
            }
        })
    }
    
    @discardableResult
    func getZipCodes(by text: String = "") -> [ZipCodeEntity] {
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
