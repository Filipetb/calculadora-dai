//
//  ViewController.swift
//  Calculadora
//
//  Created by Filipe Bezerra on 29/11/16.
//  Copyright © 2016 Filipe Torres Bezerra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    var estaNoMeioDoNumero : Bool = false
    
    @IBAction private func tocouDigito(_ sender: UIButton) {
        
        let numero = sender.titleLabel!.text!
        
        print("Tocou no botão \(numero)!")
        
        
        if estaNoMeioDoNumero {
        
            display.text = display.text! + numero
        
        }else{
            
            display.text = numero
            
        }
        
        estaNoMeioDoNumero = true
        
        
    }
    
    
    private var valorDisplay : Double {
        get {
            return Double(self.display.text!)!
        }
        set{
            self.display.text = String(newValue)
        }
    }
    
    var core = CalculadoraCore()
    
    
    @IBAction private func performaOperacao(_ sender: UIButton) {
        
        if estaNoMeioDoNumero {
            core.setOperando(operando: valorDisplay)
            
            estaNoMeioDoNumero = false
        }
        
        core.performaOperacao(simbolo: sender.currentTitle!)
        
        valorDisplay = core.resultado
    }
    
}

