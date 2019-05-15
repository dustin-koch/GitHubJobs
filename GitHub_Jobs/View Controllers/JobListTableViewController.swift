//
//  JobListTableViewController.swift
//  GitHub_Jobs
//
//  Created by Dustin Koch on 5/14/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class JobListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        JobController.shared.fetchJobsWith(searchTerm: "iOS", location: "95116") {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - IB Actions
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        presentAlertController()
    }
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(JobController.shared.jobString) jobs in \(JobController.shared.location)..."
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let jobsArray = JobController.shared.jobs else { return 1 }
        return jobsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobCell", for: indexPath)
        guard let job = JobController.shared.jobs?[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = job.company
        cell.detailTextLabel?.text = job.title

        return cell
    }
    
    // MARK: - Navigation segue to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //IIDOO
        if segue.identifier == "toJobDetailView" {
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            if let destinationVC = segue.destination as? JobDetailViewController {
                guard let job = JobController.shared.jobs?[index] else { return }
                destinationVC.job = job
            }
        }
    }
    
    //MARK: - Search Button Alert Controller
    func presentAlertController() {
        let searchAlertController = UIAlertController(title: "Engineering Job Search", message: "Enter job and location here 👇🏽", preferredStyle: .alert)
        searchAlertController.addTextField { (jobField) in
            jobField.placeholder = "Enter job description..."
        }
        searchAlertController.addTextField { (locationField) in
            locationField.placeholder = "Filter by city, state, zip code, or country"
        }
        let dismissAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let searchAction = UIAlertAction.init(title: "Search", style: .default) { (_) in
            guard let jobText = searchAlertController.textFields?.first?.text,
            searchAlertController.textFields?.first?.text != "",
            let locationText = searchAlertController.textFields?.last?.text,
                searchAlertController.textFields?.last?.text != "" else { return }
            JobController.shared.fetchJobsWith(searchTerm: jobText, location: locationText, completion: {
                DispatchQueue.main.async {
                    JobController.shared.jobString = jobText
                    JobController.shared.location = locationText
                    if JobController.shared.jobs! == [] {
                        self.presentNoJobAlert()
                    }
                    self.tableView.reloadData()
                }
            })
        }
        searchAlertController.addAction(dismissAction)
        searchAlertController.addAction(searchAction)
        self.present(searchAlertController, animated: true, completion: nil)
    }
    
    func presentNoJobAlert() {
        let noJobAlertController = UIAlertController(title: "Sorry... No jobs like that", message: "Search again with different criteria/filters", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Shucks", style: .cancel, handler: nil)
        noJobAlertController.addAction(dismissAction)
        self.present(noJobAlertController, animated: true, completion: nil)
    }

}//END OF CLASS


