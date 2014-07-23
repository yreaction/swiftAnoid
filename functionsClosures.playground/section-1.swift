


func jediGreet(name: String, ability: String) -> (farewell: String, mayTheForceBeWithYou: String) {
    return ("Good bye, \(name).", " May the \(ability) be with you.")
}

let retValue = jediGreet("old friend", "Force")
println(retValue)
println(retValue.farewell)
println(retValue.mayTheForceBeWithYou)

func jediTrainer () -> ((String,Int) -> String) {
    func train (name:String, times:Int) -> String {
        return "\(name) ha sido entrenado en la fuerza \(times) veces"
    }
    return train
}

let train = jediTrainer()
train("obiwan",3)
train("omg",55)


func jediBladeColor (colors: String...) -> () {
    for color in colors {
        println("\(color)")
    }
}
jediBladeColor("red","green")


let padawans = ["Knox", "Avitla", "Mennaus"]
padawans.map({
    (padawan: String) -> String in
    "\(padawan) has been trained!"
    })
