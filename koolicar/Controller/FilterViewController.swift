//
//  FilterViewController.swift
//  koolicar
//
//  Created by frederick sauvage on 17-10-03.
//  Copyright © 2017 frederick sauvage. All rights reserved.
//

import UIKit

typealias Selection = (city: Bool, hatchback: Bool, van: Bool, fun: Bool, electric: Bool, utility: Bool, delivery: Bool, gearAuto: Bool, seat5: Bool, seat6: Bool)

protocol Selectionnable: NSObjectProtocol {
    func didSelection(selection: Selection)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var seat6Switch: UISwitch!
    @IBOutlet weak var seat5Switch: UISwitch!
    @IBOutlet weak var gearAutoSwitch: UISwitch!
    @IBOutlet weak var deliveryCategoryButton: UIButton!
    @IBOutlet weak var utilityCategoryButton: UIButton!
    @IBOutlet weak var electricCategoryButton: UIButton!
    @IBOutlet weak var funCategoryButton: UIButton!
    @IBOutlet weak var vanCategoryButton: UIButton!
    @IBOutlet weak var hatchbackCategoryButton: UIButton!
    @IBOutlet weak var cityCategoryButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate: Selectionnable?
    
    var selection: Selection? {
        didSet {
            guard let selection = selection else { return }
            if cityCategoryButton == nil { initialize() }
            cityCategoryButton.backgroundColor = Style.selectadColorButton(isSelected: selection.city)
            hatchbackCategoryButton.backgroundColor = Style.selectadColorButton(isSelected: selection.hatchback)
            vanCategoryButton.backgroundColor = Style.selectadColorButton(isSelected: selection.van)
            funCategoryButton.backgroundColor = Style.selectadColorButton(isSelected: selection.fun)
            electricCategoryButton.backgroundColor = Style.selectadColorButton(isSelected: selection.electric)
            utilityCategoryButton.backgroundColor = Style.selectadColorButton(isSelected: selection.utility)
            deliveryCategoryButton.backgroundColor = Style.selectadColorButton(isSelected: selection.delivery)
            
            gearAutoSwitch.isOn = selection.gearAuto
            seat5Switch.isOn = selection.seat5
            seat6Switch.isOn = selection.seat6
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @IBAction func toggleButton(_ sender: Any) {
        guard let button = sender as? UIButton, let _ = selection else { return }
        var newSelection = self.selection!
        
        switch button.tag  {
        case 1: newSelection.city = !newSelection.city
        case 2: newSelection.hatchback = !newSelection.hatchback
        case 3: newSelection.van = !newSelection.van
        case 4: newSelection.fun = !newSelection.fun
        case 5: newSelection.electric = !newSelection.electric
        case 6: newSelection.utility = !newSelection.utility
        case 7: newSelection.delivery = !newSelection.delivery
        default:
            break
        }
        self.selection = newSelection
    }
    
    func initialize() {
        view.backgroundColor = .white
        gearAutoSwitch.onTintColor = Style.greenKoolicar()
        seat5Switch.onTintColor = Style.greenKoolicar()
        seat6Switch.onTintColor = Style.greenKoolicar()
        validateButton.backgroundColor = Style.purpleKoolicar()
        validateButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = Style.greenKoolicar()
        closeButton.setTitleColor(Style.grayDarkKoolicar(), for: .normal)
    }
    
    @IBAction func toggleSwitch(_ sender: Any) {
        guard let switchItem = sender as? UISwitch, let _ = selection else { return }
        var newSelection = self.selection!
        
        switch switchItem.tag  {
        case 1: newSelection.gearAuto = switchItem.isOn
        case 2: newSelection.seat5 = switchItem.isOn
        case 3: newSelection.seat6 = switchItem.isOn
        default:
            break
        }
        self.selection = newSelection
    }
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func validate(_ sender: Any) {
        if let selection = selection {
            delegate?.didSelection(selection: selection)
        }
        dismiss(animated: true)
    }
}
