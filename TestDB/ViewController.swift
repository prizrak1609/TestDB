//
//  ViewController.swift
//  TestDB
//
//  Created by Dima Gubatenko on 25.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit

fileprivate let cellReuseIdentifier = "ChannelCell"

fileprivate enum Sections : Int {
    case unread = 0
    case read = 1
}

final class ViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var switchView: Switch!

    fileprivate let server = Server()
    fileprivate let database = Database()

    fileprivate var unreadModels = [ChannelModel]()
    fileprivate var readModels = [ChannelModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        switchView.backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.02745098039, blue: 0.02745098039, alpha: 0.2)
        switchView.layer.masksToBounds = true
        switchView.layer.cornerRadius = switchView.frame.height / 2
        switchView.leftText = "Chat"
        switchView.rightText = "Live Chat"
        switchView.rightLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        switchView.rightBadgeCount = 0
        switchView.leftBadge.backgroundColor = #colorLiteral(red: 0.3137254902, green: 0.7647058824, blue: 0.8901960784, alpha: 1)
        switchView.leftBadge.textColor = .white
        switchView.leftBadgeCount = 2
        switchView.leftBadge.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 1)
        switchView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "newChat"), style: .plain, target: nil, action: nil)
        initTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
}

extension ViewController : SwitchDelegate {
    func switchValueShouldChange(_ currentState: SwitchPosition) -> Bool {
        return true
    }

    func switchValueDidChange(_ currentState: SwitchPosition) {
        if currentState == .left {
            switchView.leftLabel.textColor = .black
            switchView.rightLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        } else {
            switchView.leftLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            switchView.rightLabel.textColor = .black
        }
    }
}

extension ViewController {

    func getData() {
        server.getChannels { [weak self] result in
            guard let welf = self else { return }
            if case .failure(let error) = result {
                showText(error.localizedDescription)
                return
            }
            if case .success(let models) = result {
                welf.unreadModels.removeAll(keepingCapacity: true)
                welf.readModels.removeAll(keepingCapacity: true)
                for model in models {
                    if let lastMessage = model.lastMessage, lastMessage.isRead {
                        welf.readModels.append(model)
                    } else {
                        welf.unreadModels.append(model)
                    }
                }
                welf.tableView.reloadData()
            }
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = ChannelCell.height
        tableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if !unreadModels.isEmpty {
            sections += 1
        }
        if !readModels.isEmpty {
            sections += 1
        }
        return sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
            case .unread: return unreadModels.count
            case .read: return readModels.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? ChannelCell,
            let section = Sections(rawValue: indexPath.section)
            else { return UITableViewCell() }
        switch section {
            case .unread: cell.model = unreadModels[indexPath.row]
            case .read: cell.model = readModels[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: NSLocalizedString("Remove", comment: "Main"), handler: { [weak self] _, indexPath in
            guard let welf = self, let section = Sections(rawValue: indexPath.section) else { return }
            let model: ChannelModel
            switch section {
                case .unread: model = welf.unreadModels.remove(at: indexPath.row)
                case .read: model = welf.readModels.remove(at: indexPath.row)
            }
            welf.database.delete(channel: model)
            welf.tableView.reloadData()
        })
        deleteAction.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let section = Sections(rawValue: indexPath.section) else { return }
        if let chatScreen = Storyboards.chatScreen as? ChatScreenController {
            switch section {
                case .unread: chatScreen.model = unreadModels[indexPath.row]
                case .read: chatScreen.model = readModels[indexPath.row]
            }
            navigationController?.pushViewController(chatScreen, animated: true)
        } else {
            log("can't get \(Storyboards.Name.chatScreen) storyboard")
        }
    }
}
