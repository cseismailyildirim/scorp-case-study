//
//  ViewController.swift
//  ScorpCaseStudy
//
//  Created by ismailyildirim on 19.08.2021.
//

import UIKit

class PersonViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: IPersonViewModel?
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PersonViewModel(delegate: self)
        tableView.register(cellType: PersonTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        pullToRefreshControl()
        
    }
    private func pullToRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel?.refreshData()
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkScroll()
    }
    
    private func checkScroll(){
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height){
            if !(viewModel?.isDataLoading ?? true) {
                self.viewModel?.getData(isRefreshing: false)
            }
        }
    }
    
    private func showAlert(error: String){
        let alert = UIAlertController(title: "Hata", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension PersonViewController: PersonViewModelDelegate {
    func onSuccess() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.viewModel?.isDataLoading = false
        self.checkScroll()
    }
    
    func onError(error: String) {
        self.showAlert(error: error)
        self.refreshControl.endRefreshing()
        self.viewModel?.isDataLoading = false
    }
}

//Tableview Delegate
extension PersonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: PersonTableViewCell.self, for: indexPath)
        cell.initialize(person: viewModel!.item(at: indexPath.row))
        return cell
    }

}

