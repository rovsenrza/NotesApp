import SnapKit
import UIKit

final class AddVC: UIViewController {
    // MARK: Properties

    var addedNote: Notes = .init(name: "", desc: "", edit: Date())
    var add: (Notes) -> () = { _ in }

    // ----------------------
    // MARK: Components

    private let seperator: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray6
        return v
    }()

    private let nameField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .systemGray6
        field.font = .systemFont(ofSize: 15)
        field.clipsToBounds = true
        field.layer.cornerRadius = 12
        return field
    }()

    private let detailField: UITextView = {
        let field = UITextView()
        field.backgroundColor = .systemGray6
        field.font = .systemFont(ofSize: 15)
        field.clipsToBounds = true
        field.layer.cornerRadius = 12
        return field
    }()

    private let saveButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Save"
        return UIButton(configuration: config)
    }()

    // -------------------
    // MARK: LifeCycle

    init(addNote: @escaping (Notes) -> ()) {
        add = addNote
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // --------------------
    // MARK: Functions

    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(save)
        )

        addSubViews()
        addConstraints()
    }

    private func addSubViews() {
        view.addSubview(seperator)
        view.addSubview(nameField)
        view.addSubview(detailField)
    }

    private func addConstraints() {
        seperator.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }

        nameField.snp.makeConstraints { make in
            make.top.equalTo(seperator.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }

        detailField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    @objc private func save() {
        addedNote.name = nameField.text ?? ""
        addedNote.desc = detailField.text ?? ""
        addedNote.edit = Date()

        add(addedNote)
        navigationController?.popViewController(animated: true)
    }

    // -------------------
}
