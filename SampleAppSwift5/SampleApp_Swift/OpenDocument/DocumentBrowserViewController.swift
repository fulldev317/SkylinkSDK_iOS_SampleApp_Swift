//
//  DocumentBrowserViewController.swift
//  SampleApp_Swift
//
//  Created by  Temasys on 16/4/19.
//  Copyright © 2019 Temasys. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
         view.tintColor = .blue
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let newDocumentURL = URL(fileURLWithPath: documentDirectory + "/" + "newFile\(arc4random_uniform(100)).txt")
//        let data = "test".data(using: .utf8)
//        FileManager.default.createFile(atPath: newDocumentURL.absoluteString, contents: data, attributes: nil)
        let newDocumentURL = Bundle.main.url(forResource: "NewFile", withExtension: "txt")
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .copy)
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        documentViewController.view.frame = view.bounds
        documentViewController.document = Document(fileURL: documentURL)
        view.addSubview(documentViewController.view)
        addChild(documentViewController)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, applicationActivitiesForDocumentURLs documentURLs: [URL]) -> [UIActivity] {
        let doc = Document(fileURL: documentURLs[0])
        return [DocumentActivity(document: doc)]
    }
}