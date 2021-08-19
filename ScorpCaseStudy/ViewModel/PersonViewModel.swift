//
//  PersonsViewModel.swift
//  ScorpCaseStudy
//
//  Created by ismailyildirim on 19.08.2021.
//

import Foundation


protocol PersonViewModelDelegate {
    func onSuccess()
    func onError(error: String)
}

protocol IPersonViewModel {
    var isDataLoading: Bool { get set }
    
    var numberOfItems: Int? { get }
    func item(at index: Int) -> Person
    
    func refreshData()
    func getData(isRefreshing: Bool)
    
}

class PersonViewModel: IPersonViewModel{
    
    private var delegate: PersonViewModelDelegate
    private var people: [Person] = []
    private var offSet: String? = nil
    
    
    init(delegate: PersonViewModelDelegate) {
        self.delegate = delegate
        getData(isRefreshing: true)
    }
    
    var isDataLoading: Bool = false
    
    var numberOfItems: Int?{
        return people.count
    }
    
    func item(at index: Int) -> Person {
        return people[index]
    }
    
    func refreshData() {
        getData(isRefreshing: true)
    }
    
    func getData(isRefreshing: Bool) {
        isDataLoading = true
        DataSource.fetch(next: self.offSet) { (response, err) in
            self.offSet = response?.next
            if response != nil {
                if isRefreshing{
                    self.people = response!.people
                }else{
                    response!.people.forEach { (p1) in
                        var isExist = false
                        self.people.forEach { (p2) in
                            if p2.id == p1.id {
                                isExist = true
                            }
                        }
                        if !isExist {
                            self.people.append(p1)
                        }
                    }
                }
                self.delegate.onSuccess()
            }else{
                self.delegate.onError(error: err?.errorDescription ?? "")
            }
        }
    }
    
    
}
