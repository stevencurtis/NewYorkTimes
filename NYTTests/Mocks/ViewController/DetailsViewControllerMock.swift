//
//  DetailsViewControllerMock.swift
//  NYTTests
//
//  Created by Steven Curtis on 08/05/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
@testable import NYT


class DetailsViewControllerMock: DetailsViewControllerProtocol {
    var contents : DisplayContent?
    var leftContents : DisplayContent?
    var rightContents : DisplayContent?
}
