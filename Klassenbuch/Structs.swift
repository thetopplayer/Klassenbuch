//
//  Structs.swift
//  Klassenbuch
//
//  Created by Developing on 17.11.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import Foundation

//MARK: Absenzen Overview Structs
struct AbsenzenStruct4 {
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AAbgabe : String
    var AAnzahlStunden : Int
    var AUid: String
    var ReminderStatus: Bool
}
struct ReminderStruct{
    
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AUid: String
    
}


//MARK: Absenzen Statistiken Structs
struct AbsenzenStatistiken{
    
    var APerson: String
    var AAnzahlStunden: Int
    var AAbsenzenOffen: Int
    var AAbsenzenentschuldigt: Int
    var AAbsenzenunentschuldigt: Int
    var AUid: String
    
}

//MARK: Lehrer New Absenz Struct
struct UIDStruct{
    
    var myUID : String
    
}

//MARK: Student Absenz Struct

struct AbsenzenStruct16 {
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AAbgabe : String
    var AAnzahlStunden : Int
    var AUid: String
    
}

//MARK: LehrerAuswahl

struct Teacher2 {
    var name = String()
    
    
}

//MARK: Hausaufgaben Structs

struct Homework {
    var HDatum: Int
    var HFach: String
    var HText: String
    var HUid: String
}


struct Homework2 {
    var HDatum: Int
    var HFach: String
    var HText: String
    var HUid: String
}

//MARK: Test Structs

struct TestsStruct {
    var TDatum: Int
    var TFach: String
    var TText: String
    var TUid: String
}


struct TestsStruct2 {
    var TDatum: Int
    var TFach: String
    var TText: String
    var TUid: String
}

//MARK: Absenzen Structs

struct AbsenzenStruct3 {
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AAbgabe : String
    var AAnzahlStunden : Int
    var AUid: String
    var ReminderStatus : Bool
}

struct ReminderStructSchüler{
    
    var ADatum: Int
    var AStatus: String
    var APerson: String
    var AUid: String
    
}

//MARK: LehrerAuswahl

struct Teacher {
    var name = String()
    
}


