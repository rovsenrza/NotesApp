import SnapKit
import UIKit

final class LoginVC: UIViewController {
    // MARK: Properties

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // ----------------------
    // MARK: Components

    private let loginTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Login"
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textAlignment = .left
        return lbl
    }()

    private let loginPassword: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 10
        return tf
    }()

    private let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Login"
        return UIButton(configuration: config)
    }()

    private let registerTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Register"
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        return lbl
    }()

    private let registerPassword: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 10
        return tf
    }()

    private let registerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Register"
        config.baseBackgroundColor = .systemGreen
        return UIButton(configuration: config)
    }()

    // -------------------
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // --------------------
    // MARK: Functions

    private func setupUI() {
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)

        addSubViews()
        addConstraints()
    }

    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            loginTitle, loginPassword, loginButton,
            registerTitle, registerPassword, registerButton
        ].forEach { contentView.addSubview($0) }
    }

    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }

        loginTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
        }

        loginPassword.snp.makeConstraints { make in
            make.top.equalTo(loginTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(loginPassword.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        registerTitle.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }

        registerPassword.snp.makeConstraints { make in
            make.top.equalTo(registerTitle.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerPassword.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-40)
        }
    }

    @objc private func login() {
        if let enteredPassword = loginPassword.text {
            let savedPassword = KeychainHelper.read("userPassword")

            print("Saved:", savedPassword ?? "nil")
            print("Entered:", enteredPassword)

            if enteredPassword == savedPassword {
                let main = MainVC()
                navigationController?.setViewControllers([main], animated: true)
            } else {
                let alert = UIAlertController(title: "Error",
                                              message: "Wrong password",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
            }
        }
    }

    @objc private func register() {
        if let password = registerPassword.text {
            KeychainHelper.save(password, for: "userPassword")

            let alert = UIAlertController(title: "Success",
                                          message: "You registered",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }

    // -------------------
}
