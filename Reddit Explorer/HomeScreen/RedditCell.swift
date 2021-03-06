//
//  RedditCell.swift
//  Reddit Explorer
//
//  Created by Vladimir Aridov on 20.12.2020.
//

import UIKit

class RedditCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    
    var redditEntry: RedditEntry?
    var didTapThumbnail: ((RedditEntry) -> Void)?
    
    func setRedditEntry(_ redditEntry: RedditEntry) {
        self.redditEntry = redditEntry
        
        authorLabel.text = redditEntry.author
        titleLabel.text = redditEntry.title
        commentsLabel.text = String(redditEntry.num_comments)
        
        updateEntryDate()
        updateThumbnail()
    }
    
    override func prepareForReuse() {
        redditEntry = nil
        
        authorLabel.text = nil
        entryDateLabel.text = nil
        titleLabel.text = nil
        commentsLabel.text = nil
        thumbnailImageView.image = nil
    }
    
    fileprivate func updateEntryDate() {
        guard let entry = redditEntry else { return }
        
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = currentTime - entry.created_utc
        let secondsInHour = 3600
        let hoursAgo = Int(timeDifference) / secondsInHour
        
        entryDateLabel.text = "\(hoursAgo) hours ago"
    }
    
    fileprivate func updateThumbnail() {
        guard let entry = redditEntry else { return }
        
        if (entry.thumbnail.hasPrefix("http")) {
            thumbnailImageView.downloadImage(from: entry.thumbnail)
            thumbnailHeightConstraint.constant = 200
        } else {
            thumbnailHeightConstraint.constant = 1
        }
    }
    
    @IBAction func thumbnailAction(_ sender: Any) {
        guard let entry = redditEntry else { return }
        if (entry.url_overridden_by_dest.count > 0 && entry.post_hint == "image") {
            didTapThumbnail?(entry)
        }
    }
}
