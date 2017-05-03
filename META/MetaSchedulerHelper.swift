//
//  MetaSchedulerHelper.swift
//  META
//
//  Created by Pascal Schönthier on 13.04.17.
//  Copyright © 2017 Pascal Schönthier. All rights reserved.
//

import Foundation


typealias Percentage = Double


struct SchedulingResult {
    let cpuFaktor: CpuUsage
    let energyFaktor: EnergyConsumtion
    let latencyFaktor: Latency
}


protocol Individual {
    var strategyResult: SchedulingResult? { get set }
    
    var localCompFaktor: Double { get set }
    var remoteCompFaktor: Double { get set }
    
    var fitness:Int { get set }
}


class MetaSchedulerStrategy: Individual {
    
    var strategyResult: SchedulingResult?
    
    var localCompFaktor: Double
    var remoteCompFaktor: Double
    
    var fitness:Int = 0
    
    init(localComputationFaktor: Percentage) {
        guard localComputationFaktor <= 1.0 else { // TODO: find better way for this
            let convertedFaktor = localComputationFaktor / 100
            localCompFaktor = convertedFaktor
            remoteCompFaktor = 1.0 - localComputationFaktor
            return 
        }
        localCompFaktor = localComputationFaktor
        remoteCompFaktor = 1.0 - localComputationFaktor
    }
}


class Population {
    
    var population:[Individual]!
    
    init(size:Int) {
        (0..<size).forEach {_ in 
            let rand = Double(arc4random())/Double(UInt32.max) // should compute rand number between 0 and 1
            self.population.append(MetaSchedulerStrategy(localComputationFaktor: rand))
        }
    }
    
    /*
     * default helper methods
     */
    
    /// returns individual at given index
    func getIndividual(atIndex index:Int) -> Individual? {
        guard population.count >= index else { return nil }
        return population[index]
    }
    
    /// returns fittest individual in population
    func getFittest() -> Individual? {
        guard var fittest = population.first else { return nil }
        population.forEach { individual in
            if fittest.fitness >= individual.fitness {
                fittest = individual
            }
        }
        return fittest
    }
    
    /// returns the fittest half of all individuals (half the size of population)
    func getElites() -> [Individual] {
        guard (population.first != nil) else { return [] }
        let tmpPopultation = population.sorted { $0.fitness < $1.fitness }
        let half = population.count / 2
        return tmpPopultation[0..<half].map { $0 }
    }
    
    /// stores given individual at given position
    func saveIndividual(atIndex index: Int, individual: Individual) {
        guard population.count >= index else { return }
        population[index] = individual
    }
    
    /*
     * default genetic methods
     */
    
    /// evaluates fitness of individuals
    func evaluate(WithFunc fitnessFunc: @escaping (Individual) -> Int) {
        population = population.map { individual in
            var newIndividual = individual
            newIndividual.fitness = fitnessFunc(individual) // TODO: find better way for this one
            return newIndividual
        }
    }
    
    /// sets population to elites (best performing half of population)
    func selection() {
        let elites = getElites()
        guard elites.isEmpty  else { return }
        self.population = elites
    }
    
//    ///
//    func crossover() {
//        
//    }
//    
//    /// 
//    func mutate() {
//        
//    }
    
}
