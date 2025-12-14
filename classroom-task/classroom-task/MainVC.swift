import SnapKit
import UIKit

final class MainVC: UIViewController {
    // MARK: Properties

    private var sampleData: [Notes] = []

    // ----------------------
    // MARK: Components

    private let pageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 32, weight: .bold)
        lbl.text = "Notes"
        return lbl
    }()

    private let exitButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Exit"
        let btn = UIButton(configuration: config)
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
        return btn
    }()

    private let seperator: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        return v
    }()

    private lazy var notesTableView: UITableView = {
        let tv = UITableView()
        tv.register(NoteTVC.self, forCellReuseIdentifier: NoteTVC.reuseIdentifier)
        tv.backgroundColor = .systemBackground
        tv.delegate = self
        tv.dataSource = self
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 16
        return tv
    }()

    private let addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        let btn = UIButton(configuration: config)
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
        return btn
    }()

    // -------------------
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notesTableView.reloadData()
        saveData()
    }

    // --------------------
    // MARK: Functions

    private func setupUI() {
        view.backgroundColor = .systemGray6
        addSubViews()
        addConstraints()

        addButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
    }

    private func addSubViews() {
        view.addSubview(pageLabel)
        view.addSubview(seperator)
        view.addSubview(notesTableView)
        view.addSubview(addButton)
        view.addSubview(exitButton)
    }

    private func addConstraints() {
        pageLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }

        seperator.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }

        notesTableView.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-40)
            make.size.equalTo(60)
        }

        exitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-40)
            make.size.equalTo(60)
        }
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "data"),
           let decoded = try? JSONDecoder().decode([Notes].self, from: data)
        {
            sampleData = decoded
        }
    }

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(sampleData) {
            UserDefaults.standard.set(encoded, forKey: "data")
        }
    }

    @objc private func addNote() {
        let addVC = AddVC {[weak self] note in
            self?.sampleData.insert(note, at: 0)
            self?.saveData()
        }
        navigationController?.pushViewController(addVC, animated: true)
    }

    @objc private func exit() {
        KeychainHelper.delete("userPassword")
        let loginVC = LoginVC()
        navigationController?.setViewControllers([loginVC], animated: true)
    }

    // -------------------
}

// -------------------
// MARK: TableView Delegate

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC(dataNote: sampleData[indexPath.row]) {[weak self] updated in
            if let index = self?.sampleData.firstIndex(where: { $0.id == updated.id }) {
                self?.sampleData[index] = updated
                self?.saveData()
            }
        }

        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, done in
            self?.sampleData.remove(at: indexPath.row)
            self?.saveData()
            tableView.reloadData()
            done(true)
        }

        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

// -------------------
// MARK: TableView DataSource

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sampleData.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteTVC.reuseIdentifier,
            for: indexPath
        ) as? NoteTVC else {
            return UITableViewCell()
        }

        cell.configure(sampleData[indexPath.row])
        return cell
    }
}
