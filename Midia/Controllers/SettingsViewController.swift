//
//  SettingsViewController.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 17/03/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import UIKit

struct SettingsCellModel {
    var title : String
    var subtitle: String
    
    mutating func setSubtitle(with subtitle: String) {
        self.subtitle = subtitle
    }
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cells = UINib(nibName: SettingsTableViewCell.reuseId, bundle: nil)
            tableView.register(cells, forCellReuseIdentifier: SettingsTableViewCell.reuseId)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var cells: [SettingsCellModel] = [SettingsCellModel(title: "Mode",
                                                        subtitle: Repository.shared.mode.rawValue)]
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseId, for: indexPath)
        if let cell = cell as? SettingsTableViewCell {
            let model = cells[indexPath.row]
            cell.title.text = model.title
            cell.subtitle.text = model.subtitle
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Switch mode", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Books", style: .destructive, handler: {[weak self] (action) in
                Repository.shared.mode = .book
                self?.cells[0].setSubtitle(with: Repository.shared.mode.rawValue )
                tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            alertController.addAction(UIAlertAction(title: "Movies", style: .destructive, handler: {[weak self]  (action) in
                Repository.shared.mode = .movie
                self?.cells[0].setSubtitle(with: Repository.shared.mode.rawValue )
                tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
