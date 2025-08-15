//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

typealias ArrayTableViewControllerItem = CustomStringConvertible & Equatable

class ArrayTableViewController<T: ArrayTableViewControllerItem>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()

    private let allCases: [T]
    private var selectedCase: T?
    var rowSelected: ((T) -> Void)? = nil

    private var selectedIndexPath: IndexPath?

    init(allCases: [T], initialSelection: T?) {
        self.allCases = allCases
        self.selectedCase = initialSelection
        if let selectedCase, let row = allCases.firstIndex(where: { $0 == selectedCase }) {
            selectedIndexPath = IndexPath(row: row, section: 0)
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseId")
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
        let item = allCases[indexPath.row]

        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = "\(item)"
        cell.contentConfiguration = contentConfig
        if item == selectedCase {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCase = allCases[indexPath.row]
        rowSelected?(selectedCase!)

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [selectedIndexPath, indexPath].compactMap { $0 }, with: .automatic)
        selectedIndexPath = indexPath
    }
}


enum TestEnum: CustomStringConvertible, CaseIterable {
    case one
    case two
    case three
    case four

    var description: String {
        switch self {
        case .one: return "One"
        case .two: return "Two two"
        case .three: return "Three"
        case .four: return "Four"
        }
    }
}

let vc = ArrayTableViewController(allCases: TestEnum.allCases, initialSelection: .three)
vc.rowSelected = { item in
    print("\(item) selected.")
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = vc
