//
//  Constans.swift
//  PolkarIOS
//
//  Created by Jakub Slusarski on 29/10/2021.
//

struct K {
    
    struct Segue {
        static let registerToWelcome = "RegisterToWelcome"
        static let welcomeToAddCar = "WelcomeToAddCar"
        static let loginToWelcome = "LoginToWelcome"
    }
    
    struct Cars {
        static let colection = "cars"
        static let brand = "carBrand"
        static let model = "carModel"
        static let mileage = "carMileageID"
        static let fuelType = "carFuelType"
        static let fuelTankCapacity = "carFuelTankCapacity"
        static let engine = "carEngine"
        static let body = "carBody"
        static let insurance = "carInsurance"
        static let service = "carService"
        static let emial = "email"
        static let time = "time"
        static let UID = "UID"
        static let userUID = "userUID"
        static let averageFuelUsage = "carAverageFuelUsage"
    }
    
    struct Users {
        static let colection = "users"
        static let email = "userEmail"
        static let cars = "userCars"
        static let name = "userName"
        static let UID = "UID"
    }
    
    struct Fuel {
        static let colection = "fuel"
        static let amount = "fuelAmount"
        static let mileage = "fuelMileage"
        static let price = "fuelPrice"
        static let sum = "fuelSum"
        static let average = "fuelAverage"
        static let fuelCarUID = "fuelCarUID"
        static let fullTank = "fuelFullTank"
        static let UID = "UID"
        static let station = "fuelStation"
    }
    
}
