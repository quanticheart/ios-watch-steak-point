//
//  InterfaceController.swift
//  PontoDaCarne WatchKit Extension
//
//  Created by Jonatas Alves santos on 14/05/22.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var Timer: WKInterfaceTimer!
    
    @IBOutlet weak var BtnTimer: WKInterfaceButton!
    @IBOutlet weak var labelKG: WKInterfaceLabel!
    
    @IBOutlet weak var labelKGText: WKInterfaceLabel!
    @IBOutlet weak var pickerHeight: WKInterfacePicker!
    @IBOutlet weak var pickerTemperature: WKInterfacePicker!
    @IBOutlet weak var Group1: WKInterfaceGroup!
    @IBOutlet weak var GroupTexts: WKInterfaceGroup!
    @IBOutlet weak var GroupImage: WKInterfaceGroup!
    
    @IBOutlet weak var labelMeatPoint: WKInterfaceLabel!
    @IBOutlet weak var labelMeatPointImg: WKInterfaceLabel!
    @IBOutlet weak var brnMinus: WKInterfaceButton!
    
    @IBOutlet weak var sliderMeat: WKInterfaceSlider!
    var kg = 0.1
    var increment = 0.1
    var maxKG = 2.0
    var isTimeIsRunning = false
    var meatTemperature:MeatTemperature = .rare
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        modeChange(true)
        setupPickers()
        update()
    }
    
    private func setupPickers(){
        var weightItems: [WKPickerItem] = []
        for weigth in stride(from: 0.1, through: maxKG, by: increment){
            let item = WKPickerItem()
            item.title = String(format: "%.1f", weigth)
            weightItems.append(item)
        }
        pickerHeight.setItems(weightItems)
        pickerHeight.setSelectedItemIndex(0)
    
        var temperatureItems: [WKPickerItem] = []
        for imageIndex in 1...4 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "temp-\(imageIndex)")
            temperatureItems.append(item)
            
        }
        
        pickerTemperature.setItems(temperatureItems)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        
        // This method is called when watch view controller is no longer visible
    }
    
    private func update(){
        labelKGText.setText("Total: \(String(format: "%.1f", kg)) Kg")
        let index = Int(kg * 10) - 1
        pickerHeight.setSelectedItemIndex(index)
        
        labelMeatPoint.setText(meatTemperature.stringValue)
        
        labelMeatPointImg.setText(meatTemperature.stringValue)
        
        sliderMeat.setValue(Float(meatTemperature.rawValue))
        
        pickerTemperature.setSelectedItemIndex(meatTemperature.rawValue)
        
    }

    @IBAction func btnMinus() {
        if kg > 0.19 {
            kg -= increment
            update()
        }
    }
    
    @IBAction func btnPlus() {
        if kg < maxKG {
            kg += increment
            update()
        }
    }
    
    @IBAction func startTimer() {
        if isTimeIsRunning {
            Timer.setDate(Date())
            Timer.stop()
            BtnTimer.setTitle("Iniciar Timer")
        } else {
            let timeInSecinds = meatTemperature.cookTimeForKg(kg)
            Timer.setDate(Date(timeIntervalSinceNow: timeInSecinds))
            Timer.start()
            BtnTimer.setTitle("Parar Timer")
        }
        isTimeIsRunning.toggle()
    }
    
    @IBAction func pickerQuntity(_ value: Int) {
        kg = Double(value+1) * increment
        update()
    }
    
    @IBAction func pickerMeatPoint(_ value: Int) {
       updateMeatTemperature(value: value)
    }
    
    @IBAction func slider(_ value: Float) {
    updateMeatTemperature(value: Int(value))
    }
    
    private func updateMeatTemperature(value:Int){
        meatTemperature = MeatTemperature(rawValue: value)!
            update()
    }
        
    @IBAction func modeChange(_ value: Bool) {
        GroupImage.setHidden(!value)
        GroupTexts.setHidden(value)
    }
}
