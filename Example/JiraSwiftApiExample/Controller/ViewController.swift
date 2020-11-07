//
//  ViewController.swift
//  JiraSwiftApiExample
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

import Cocoa
import WebKit
import JiraSwiftAPI

class ViewController: NSViewController {
    
    @IBOutlet weak var dropdownSprints: NSPopUpButton!
    @IBOutlet weak var textNvxTickets: NSTextField!
    @IBOutlet weak var textTotalTickets: NSTextField!
    @IBOutlet weak var textNvxTicketsDodOK: NSTextField!
    @IBOutlet weak var textTotalTicketsDodOK: NSTextField!
    @IBOutlet weak var textTicketsDodKO: NSTextField!
    @IBOutlet weak var textVelocite: NSTextField!
    @IBOutlet weak var textBugsDod: NSTextField!
    @IBOutlet weak var textVelociteBugs: NSTextField!
    @IBOutlet weak var sprintTableView: NSTableView!
    
    @IBOutlet weak var dropDownRelease: NSPopUpButton!
    @IBOutlet weak var datePickerRelease: NSDatePicker!
    @IBOutlet weak var wkReleaseNote: WKWebView!
    
    
    let tableRowsLabel:[String] = ["Nbr de tickets dans le sprint",
                                   "Nbr de Bugs ajoutés en cours de sprint",
                                   "Nbr de Tickets En cours",
                                   "Nbr de Tickets DOD Ok",
                                   "Nbr de bugs DOD OK",
                                   "--------------------",
                                   "Vélocité (points)"]
    
    
    private let sprintViewModel = SprintViewModel()
    private let releaseViewModel = ReleaseViewModel()

    override var representedObject: Any? {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetView()
        self.populateSprintsDropdown()
        self.populateReleaseDropdown()
        
        self.wkReleaseNote.navigationDelegate = self
    }
    
    private func resetView() {
        sprintViewModel.reset()
        sprintTableView.reloadData()
        textNvxTickets.stringValue = ""
        textTotalTickets.stringValue = ""
        textNvxTicketsDodOK.stringValue = ""
        textTotalTicketsDodOK.stringValue = ""
        textTicketsDodKO.stringValue = ""
        textVelocite.stringValue = ""
        textBugsDod.stringValue = ""
        textVelociteBugs.stringValue = ""
    }
    
    //MARK: -- IBAction buttons clic
    @IBAction func sprintButtonAction(_ sender: Any) {
        self.resetView()
        
        guard let sprint = sprintViewModel.getSprintFrom(index: dropdownSprints.indexOfSelectedItem) else {
            return
        }
        
        sprintViewModel.retrieveEstimationField(sprint: sprint.id) { [weak self] (_) in
            
            // I need to set custom field for estimation before fetching all issues
            self?.sprintViewModel.loadAllIssues(sprint: sprint.id) { (total) in
                guard let self = self else { return }
                let newIssues = self.sprintViewModel.countNewTicketsSprint()
                let dodOk = self.sprintViewModel.countTicketsDodOK()
                let newDod = self.sprintViewModel.countNewTicketsDod()
                let dodKo = self.sprintViewModel.countTicketsDodKO()
                let velocity = self.sprintViewModel.calculateVelocity()
                let bugs = self.sprintViewModel.countResolvedBugsInSprint()
                
                DispatchQueue.main.async {
                    self.textNvxTickets.stringValue = "\(newIssues)"
                    self.textTotalTickets.stringValue = "\(dodOk+dodKo)"
                    
                    self.textNvxTicketsDodOK.stringValue = "\(newDod)"
                    self.textTotalTicketsDodOK.stringValue = "\(dodOk)"
                    
                    self.textTicketsDodKO.stringValue = String(dodKo)
                    
                    self.textVelocite.stringValue = "\(velocity)"
                    self.textBugsDod.stringValue = "\(bugs)"
                    self.textVelociteBugs.stringValue = "\(velocity+bugs)"
                    
                    self.sprintTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func buttonReleaseAction(_ sender: Any) {
        guard let version = releaseViewModel.getVersionFrom(index: dropDownRelease.indexOfSelectedItem) else {
            return
        }
        
        let date = datePickerRelease.dateValue
//        releaseViewModel.releaseVersion(version: version, date: date) { [weak self] (versions) in
//            DispatchQueue.main.async {
//                self?.dropDownRelease.removeAllItems()
//                let items = versions.map { $0.name }
//                self?.dropDownRelease.addItems(withTitles: items)
//            }
//        }
        
        guard let request = releaseViewModel.changelogRequest(version: version) else {
            return
        }
        self.wkReleaseNote.load(request)
    }
    
    
    private func populateSprintsDropdown() {
        sprintViewModel.getSprintsForDropdown { [weak self] (sprints) in
            DispatchQueue.main.async {
                self?.dropdownSprints.removeAllItems()
                let items = sprints.map { $0.name }
                self?.dropdownSprints.addItems(withTitles: items)
            }
        }
    }
    
    private func populateReleaseDropdown() {
        releaseViewModel.getReleasesForDropdown { [weak self] (versions) in
            DispatchQueue.main.async {
                self?.dropDownRelease.removeAllItems()
                let items = versions.map { $0.name }
                self?.dropDownRelease.addItems(withTitles: items)
            }
        }
    }
}

extension ViewController: NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tableViewCellLabel"), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        let components = [Component.android, Component.ios, Component.web]
        
        if tableColumn == tableView.tableColumns[0] {
            cell.textField?.stringValue = self.tableRowsLabel[row]
        } else {
            guard let tableColumn = tableColumn,
                  let index = tableView.tableColumns.firstIndex(of: tableColumn) else {
                return nil
            }
            
            if row == 0 { // Nombre de tickets dans le sprint
                cell.textField?.stringValue = String(self.sprintViewModel.countTickets(component: components[index - 1]))
            } else if row == 1 { // Nombre de bugs ajoutés en cours de sprint
                cell.textField?.stringValue = String(self.sprintViewModel.countAddedBug(component: components[index - 1]))
            } else if row == 2 { // Tickets in progress
                cell.textField?.stringValue = String(self.sprintViewModel.countTicketsDodKO(component: components[index - 1]))
            } else if row == 3 { // New tickets DOD
                cell.textField?.stringValue = String(self.sprintViewModel.countNewTicketsDod(component: components[index - 1]))
            } else if row == 4 { // Nombre de bugs DOD OK
                cell.textField?.stringValue = String(self.sprintViewModel.countResolvedBugsInSprint(component: components[index - 1]))
            } else if row == 5 {
                cell.textField?.stringValue = "-"
            } else if row == 6 { // Vélocité
                cell.textField?.stringValue = String(self.sprintViewModel.calculateVelocity(component: components[index - 1]))
            }
        }
        return cell
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableRowsLabel.count
    }
    
}

extension ViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 20.0
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript = """
    document.getElementById('editcopy').remove();
    var items = document.getElementsByTagName('h2');
    items[items.length - 1].remove();
    document.getElementsByClassName('aui-page-panel-content')[0].getElementsByTagName('p')[0].remove();
    document.getElementById('header').remove();
    document.getElementById('footer').remove();
    document.getElementsByClassName('ops-cont')[0].innerHTML = "<h1>[📦 Player] Release Player Android 5.0.0</h1> \
<p>Bonjour à toutes et à tous,</p> \
<p>L'équipe Player est heureuse de vous présenter la toute nouvelle Release disponible. Il s'agit de la <b>version 5.0.0 du Player Android</b> que nous vous invitons à découvrir sans plus attendre.</p> \
<p>Voici le contenu de cette version :</p>";
    document.getElementsByClassName('aui-page-panel-content')[0].insertAdjacentHTML( 'beforeend', "<p>Nous vous souhaitons une très belle journée.</p>" );
    document.getElementsByClassName('aui-page-panel')[0].style.margin = 0;
"""
        self.wkReleaseNote.evaluateJavaScript(javascript, completionHandler: nil)
    }
}
