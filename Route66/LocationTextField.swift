//
//  LocationTextField.swift
//  Route66
//
//  Created by Hans Knöchel on 21.06.18.
//  Copyright © 2018 Hans Knöchel. All rights reserved.
//

import UIKit

class LocationTextField: UITextField {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.delegate = self
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y + 8, width: bounds.size.width - 20, height: bounds.size.height - 16);
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return self.textRect(forBounds:bounds)
  }
}

extension LocationTextField : UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
