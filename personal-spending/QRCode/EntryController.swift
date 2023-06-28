//
//  Entry.swift
//  template
//
//  Created by shayanbo on 2023/5/20.
//

import UIKit
import CoreImage

public class EntryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    var tableView: UITableView!
    var textView: UITextView?
    var imageView: UIImageView?

    var generateBtn: UIButton?
    var saveBtn: UIButton?

    let context = CIContext()

    public override func viewDidLoad() {

        self.navigationItem.title = "QrCode Generator"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        let backButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(backButtonTapped))
        // Assign the custom button to the leftBarButtonItem
        navigationItem.leftBarButtonItem = backButton

        /// add tableview
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: .zero, style: .grouped)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    //MARK: Action

    @objc func generate() {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return
        }
        guard let tv = textView, tv.text.count > 0 else {
            return
        }
        guard let iv = imageView else {
            return
        }
        guard let data = tv.text.data(using: .utf8) else {
            return
        }

        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return
        }

        let scaleX = iv.frame.size.width / ciImage.extent.size.width
        let scaleY = iv.frame.size.height / ciImage.extent.size.height
        let finalImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        guard let cgImage = context.createCGImage(finalImage, from: finalImage.extent) else {
            return
        }
        imageView?.image = UIImage(cgImage: cgImage)
        self.saveBtn?.isEnabled = true
    }

    @objc func save() {

        guard let image = self.imageView?.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveDone), nil)
    }

    @objc func saveDone(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        let alert = UIAlertController(title: nil, message: "Save To Album", preferredStyle: .alert)
        if let err = error {
            alert.addAction(UIAlertAction(title: err.localizedDescription, style: .destructive))
        } else {
            alert.addAction(UIAlertAction(title: "Done", style: .destructive))
        }
        self.present(alert, animated: true)
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        // Create a toolbar
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//
//        // Add a flexible space before the "Done" button to align it to the right
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//        // Create the "Done" button
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
//
//        // Set the toolbar items
//        toolbar.items = [flexibleSpace, doneButton]
//
//        // Set the toolbar as the input accessory view of the text view
//        textView.inputAccessoryView = toolbar
    }

    @objc func handleTap() {
        view.endEditing(true)
    }

//    @objc func doneTapped() {
//        textView?.endEditing(true)
//    }
    
    @objc func backButtonTapped() {
        let vc = WelcomeViewController()
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    //MARK: UITableView DataSource & Delegate

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.section == 0) {
            if indexPath.item == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Input") {
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "Input")
                    let tv = UITextView()
                    tv.delegate = self
                    cell.contentView.addSubview(tv)

                    tv.translatesAutoresizingMaskIntoConstraints = false
                    tv.heightAnchor.constraint(equalToConstant: 100).isActive = true
                    tv.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10).isActive = true
                    tv.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10).isActive = true
                    tv.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10).isActive = true
                    tv.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10).isActive = true

                    self.textView = tv
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Generate") {
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "Generate")
                    let btn = UIButton(type: .custom)
                    btn.setTitle("Generate", for: .normal)
                    btn.setTitleColor(.systemGray, for: .disabled)
                    btn.setTitleColor(.systemBlue, for: .normal)
                    btn.addTarget(self, action: #selector(generate), for: .touchUpInside)
                    cell.accessoryView = btn

                    btn.sizeToFit()
                    btn.isEnabled = false

                    self.generateBtn = btn
                    return cell
                }
            }
        } else {
            if indexPath.item == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Output") {
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "Output")
                    let iv = UIImageView(image: nil)
                    iv.contentMode = .scaleAspectFit
                    cell.contentView.addSubview(iv)

                    iv.translatesAutoresizingMaskIntoConstraints = false
                    iv.widthAnchor.constraint(equalTo: iv.heightAnchor).isActive = true
                    iv.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20).isActive = true
                    iv.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20).isActive = true
                    iv.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20).isActive = true
                    iv.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20).isActive = true

                    self.imageView = iv
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Save") {
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "Save")
                    let btn = UIButton(type: .custom)
                    btn.setTitle("Save To Album", for: .normal)
                    btn.setTitleColor(.systemGray, for: .disabled)
                    btn.setTitleColor(.systemBlue, for: .normal)
                    btn.addTarget(self, action: #selector(save), for: .touchUpInside)
                    cell.accessoryView = btn

                    btn.sizeToFit()
                    btn.isEnabled = false

                    self.saveBtn = btn
                    return cell
                }
            }
        }
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Input Qrcode Content" : "Qrcode"
    }

    //MARK: UITextViewDelegate

    public func textViewDidChange(_ textView: UITextView) {
        self.generateBtn?.isEnabled = textView.text.count > 0
    }
}
