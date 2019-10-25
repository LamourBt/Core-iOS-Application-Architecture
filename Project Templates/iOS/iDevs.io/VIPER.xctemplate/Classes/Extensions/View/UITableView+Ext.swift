//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___
//

import UIKit

class TableViewPlaceholderLabel: UILabel {
    var inset: UIEdgeInsets = .zero
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += inset.left + inset.right
        size.height += inset.top + inset.bottom
        return size
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.inset))
    }
}

extension UITableViewController {
    func placeholder(message:String, fontSize: CGFloat = 20) {
        let messageLabel = TableViewPlaceholderLabel()
        messageLabel.inset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        messageLabel.backgroundColor = .clear
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 20)
        messageLabel.textColor = UIColor.systemGray
        messageLabel.textAlignment = .center;
        messageLabel.text = message
        
        self.tableView.backgroundView = messageLabel
    }
}

extension UITableViewCell {
    static var autoReuseIdentifier: String {
        
        return NSStringFromClass(self) + "AutogeneratedIdentifier"
    }
}

public extension UITableView {
    
    func dequeue<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: T.autoReuseIdentifier, for: indexPath) as? T
    }
    
    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        register(nibFromClass(cell), forCellReuseIdentifier: cell.autoReuseIdentifier)
    }
    
    // Private
    fileprivate func nibFromClass(_ type: UITableViewCell.Type) -> UINib? {
        guard let nibName = NSStringFromClass(type).components(separatedBy: ".").last
            else {
                return nil
        }
        
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension UITableView {
    var visibleSectionHeaders: [UITableViewHeaderFooterView] {
        get {
            var headerViews = [UITableViewHeaderFooterView]()
            if let visibleRows = self.indexPathsForVisibleRows {
                let visibleSections = visibleRows.map({$0.section})
                visibleSections.forEach { (index) in
                    if let view = self.headerView(forSection: index) {
                        headerViews.append(view)
                    }
                }
                
            }
            return headerViews
        }
    }
    
    private func indexesOfVisibleSections() -> Array<Int> {
        var visibleSectionIndexes = [Int]()
        
        for index in 0...numberOfSections {
            var headerRect: CGRect?
            
            if (self.style == .plain) {
                headerRect = self.rect(forSection: index)
            } else {
                headerRect = self.rectForHeader(inSection: index)
            }
            
            if headerRect != nil {
                let visiblePartOfTableView: CGRect = CGRect(
                    x: self.contentOffset.x,
                    y: self.contentOffset.y,
                    width: self.bounds.size.width,
                    height: self.bounds.size.height
                )
                
                if (visiblePartOfTableView.intersects(headerRect!)) {
                    visibleSectionIndexes.append(index)
                }
            }
        }
        
        return visibleSectionIndexes
    }
}

extension UITableView {
    func layoutTableHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func layoutTableFooterView() {
        
        guard let footerView = self.tableFooterView else { return }
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = footerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[footerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["footerView": footerView])
        
        footerView.addConstraints(temporaryWidthConstraints)
        
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        
        let footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = footerSize.height
        var frame = footerView.frame
        
        frame.size.height = height
        footerView.frame = frame
        
        self.tableFooterView = footerView
        
        footerView.removeConstraints(temporaryWidthConstraints)
        footerView.translatesAutoresizingMaskIntoConstraints = true
    }
}


