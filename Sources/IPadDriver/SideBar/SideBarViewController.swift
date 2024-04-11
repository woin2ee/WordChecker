//
//  SideBarViewController.swift
//  IPadDriver
//
//  Created by Jaewon Yun on 4/11/24.
//  Copyright © 2024 woin2ee. All rights reserved.
//

import IOSSupport
import SnapKit
import Then
import UIKit
import UIKitPlus

internal final class SideBarViewController: UIViewController {

    let menuList: [[SideBarMenu]] = [
        [.wordChecking, .wordList],
        [.userSettings],
    ]
    
    private let appNameLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right:20)).then {
        $0.text = LocalizedString.appName
        $0.font = .preferredFont(forTextStyle: .title1, weight: .semibold)
    }
    
    private(set) lazy var menuTableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.dataSource = self
        $0.register(SideBarCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        self.view.addSubview(menuTableView)
        self.view.addSubview(appNameLabel)
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension SideBarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SideBarCell.self, for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = menuList[indexPath.section][indexPath.row].title
        config.image
        cell.contentConfiguration = config
        return cell
    }
}
