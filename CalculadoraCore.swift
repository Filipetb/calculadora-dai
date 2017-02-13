//
//  CalculadoraCore.swift
//  Calculadora
//
//  Created by Filipe Bezerra on 17/01/17.
//  Copyright © 2017 Filipe Torres Bezerra. All rights reserved.
//

import Foundation


class CalculadoraCore {
    
    private var acumulador = 0.0
    
    private var pendente : OperacaoBinariaPendente?
    
    var resultado : Double {
        get{
            return acumulador
        }
    }
    
    func setOperando(operando : Double) {
        acumulador = operando
    }
    
    var operacoes : Dictionary<String,Operacao> = [
        "π" : Operacao.Constante(M_PI),
        "e" : Operacao.Constante(M_E),
        "√" : Operacao.OperacaoUnaria(sqrt),
        "cos" : Operacao.OperacaoUnaria(cos),
        //"!" : Operacao.OperacaoUnariaCore(fatorial),
        "!" : Operacao.OperacaoUnaria() {
            if $0 == 0 { return 1.0 }
            
            var resultado = 1.0
            
            for i in (1...Int($0)).reversed() {
                resultado = Double(i) * resultado
            }
            
            return resultado
        },
        "+" : Operacao.OperacaoBinaria() {$0 + $1},
        "-" : Operacao.OperacaoBinaria() {$0 - $1},
        "*" : Operacao.OperacaoBinaria() {$0 * $1},
        "/" : Operacao.OperacaoBinaria() {$0 / $1},
        
        "=" : Operacao.Igual
    ]
    
    enum Operacao {
        case Constante(Double)
        case OperacaoUnaria((Double) -> Double)
        case OperacaoUnariaCore((CalculadoraCore) -> (Double) -> Double)
        case OperacaoBinaria((Double,Double) -> Double)
        case Igual
    }
    
    struct OperacaoBinariaPendente {
        var operacaoBinaria : (Double,Double) -> Double
        var primeiroOperando : Double
    }
    
    func performaOperacao(simbolo : String) {
        
        if let operacao = operacoes[simbolo] {
        
            switch operacao {
                
            case .Constante(let valor) :  acumulador = valor
                
            case .OperacaoUnaria(let funcao) : acumulador = funcao(acumulador)
                
            case .OperacaoUnariaCore(let classe) :
                
                let funcao = classe(self)
                acumulador = funcao(acumulador)
                
                
            case .OperacaoBinaria(let funcao) :
                
                executaOperacaoBinariaPendente()
                pendente = OperacaoBinariaPendente(operacaoBinaria: funcao, primeiroOperando: acumulador)
                
                
            case .Igual : executaOperacaoBinariaPendente()

            }
            
        }
        
    }
    
    private func executaOperacaoBinariaPendente() {
        if pendente != nil {
            acumulador = pendente!.operacaoBinaria(pendente!.primeiroOperando, acumulador)
            pendente = nil
        }
    }
    
    
    private func fatorial(numero : Double) -> Double {
        
        if numero == 0 {
            return 1
        }
        
        var resultado = 1.0
        
        for i in (1...Int(numero)).reversed() {
            resultado = Double(i) * resultado
        }
        
        return resultado
        
    }
    
    
}
