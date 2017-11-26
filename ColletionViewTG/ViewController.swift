//
//  ViewController.swift
//  ColletionViewTG
//
//  Created by Vandan Patel on 11/24/17.
//  Copyright © 2017 Vandan Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    var collectionData = ["1 🧛‍♂️", "2 💼", "3 😘", "4 🍩", "5 🖥", "6 ❤️", "7 🕉", "8 ✝️", "9 🇮🇳", "10 🇺🇸", "11 🍕", "12 👪"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        let width = (view.frame.size.width - 40) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.isToolbarHidden = true
    }
    
    @IBAction func deleteSelected() {
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            let items = indexPaths.map {$0.item}.sorted().reversed()
            for item in items {
                collectionData.remove(at: item)
            }
            collectionView.deleteItems(at: indexPaths)
            navigationController?.isToolbarHidden = true
        }
        
    }
    
    @IBAction func didTapAdd() {
        let text = "\(collectionData.count + 1) 👀"
        collectionData.append(text)
        let indexPath = IndexPath(item: collectionData.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    @objc func refresh() {
        didTapAdd()
        collectionView.refreshControl?.endRefreshing()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MyCollectionViewCell
        cell.layer.cornerRadius = 10.0
        cell.titleLabel.text = collectionData[indexPath.item]
        cell.isEditing = isEditing
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        } else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let destination = segue.destination as? DetailedViewController, let index = collectionView.indexPathsForSelectedItems?.first {
                destination.selection = collectionData[index.item]
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addBarButtonItem.isEnabled = !editing
        deleteButton.isEnabled = editing
        collectionView.allowsMultipleSelection = editing
        let indexes = collectionView.indexPathsForVisibleItems
        for index in indexes {
            let cell = collectionView.cellForItem(at: index) as! MyCollectionViewCell
            cell.isEditing = editing
        }
        if !editing {
            navigationController?.isToolbarHidden = true
        }
    }
}

