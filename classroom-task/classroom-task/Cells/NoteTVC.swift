import SnapKit
import UIKit

final class NoteTVC: UITableViewCell {
    // MARK: Reuse Identifier

    static let reuseIdentifier = String(describing: NoteTVC.self)
    // ----------------------
    // MARK: Components

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        lbl.textColor = .label
        return lbl
    }()

    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .regular)
        lbl.textColor = .secondaryLabel
        return lbl
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        return sv
    }()

    private let chevron: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.right")
        image.tintColor = .systemGray
        return image
    }()

    // -------------------
    // MARK: LiveCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NoteTVC.reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        nameLabel.text = nil
        dateLabel.text = nil
    }

    // --------------------
    // MARK: Functions

    func configure(_ data: Notes) {
        nameLabel.text = data.name
        dateLabel.text = data.edit.timeAgo()
    }

    private func setupUI() {
        addSubViews()
        addConstraints()
    }

    private func addSubViews() {
        contentView.addSubview(stackView)
        contentView.addSubview(chevron)
        [
            nameLabel,
            dateLabel
        ].forEach(stackView.addArrangedSubview)
    }

    private func addConstraints() {
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.verticalEdges.equalToSuperview().inset(12)
            make.trailing.equalTo(chevron.snp.leading).offset(-8)
        }
        chevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(28)
        }
    }
    //-------------------
}
