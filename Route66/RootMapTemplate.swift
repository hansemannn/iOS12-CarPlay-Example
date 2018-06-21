//
//  RootMapTemplate.swift
//  Route66
//
//  Created by Hans Knöchel on 21.06.18.
//  Copyright © 2018 Hans Knöchel. All rights reserved.
//

import UIKit
import CarPlay

class RootMapTemplate: CPMapTemplate, CPMapTemplateDelegate {

  override init(configuration: CPMapTemplateConfiguration?) {
    super.init(configuration: configuration)
    self.mapDelegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
