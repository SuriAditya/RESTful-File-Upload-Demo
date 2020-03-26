//
//  ViewController.swift
//  FileUploader
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let rest = RestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        uploadSingleFile()
        //uploadMultipleFiles()
    }


    func uploadSingleFile() {
        let fileURL = Bundle.main.url(forResource: "samplePDF", withExtension: "pdf")
        let fileInfo = RestManager.FileInfo(withFileURL: fileURL, filename: "samplePDF.pdf", name: "claim_file", mimetype: "application/pdf")
        
        //rest.httpBodyParameters.add(value: "Hello 😀 !!!", forKey: "greeting")
        //rest.httpBodyParameters.add(value: "AppCoda", forKey: "user")
        rest.httpBodyParameters.add(value: "ETSecured", forKey: "apiLogin")
        rest.httpBodyParameters.add(value: "ETPassSecured", forKey: "apiPass")

        //print(rest.httpBody)
        upload(files: [fileInfo], toURL: URL(string: "http://192.168.29.97/trackpay/api/save_claim_files/"))
    }
    
    
    
    func uploadMultipleFiles() {
        let textFileURL = Bundle.main.url(forResource: "sampleText", withExtension: "txt")
        let textFileInfo = RestManager.FileInfo(withFileURL: textFileURL, filename: "sampleText.txt", name: "uploadedFile", mimetype: "text/plain")
        
        let pdfFileURL = Bundle.main.url(forResource: "samplePDF", withExtension: "pdf")
        let pdfFileInfo = RestManager.FileInfo(withFileURL: pdfFileURL, filename: "samplePDF.pdf", name: "uploadedFile", mimetype: "application/pdf")
        
        let imageFileURL = Bundle.main.url(forResource: "sampleImage", withExtension: "jpg")
        let imageFileInfo = RestManager.FileInfo(withFileURL: imageFileURL, filename: "sampleImage.jpg", name: "uploadedFile", mimetype: "image/jpg")
        
        upload(files: [textFileInfo, pdfFileInfo, imageFileInfo], toURL: URL(string: "http://localhost:3000/multiupload"))
    }
    
    
    
    func upload(files: [RestManager.FileInfo], toURL url: URL?) {
        if let uploadURL = url {
            rest.upload(files: files, toURL: uploadURL, withHttpMethod: .post) { (results, failedFilesList) in
                print("HTTP status code:", results.response?.httpStatusCode ?? 0)
                
                if let error = results.error {
                    print(error)
                }
                
                if let data = results.data {
                    print("Success \(String(describing: results))")
                    if let toDictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        print("Inside")
                        print(toDictionary)
                    }
                }
                
                if let failedFiles = failedFilesList {
                    for file in failedFiles {
                        print(file)
                    }
                }
            }
        }
    }
    
}

