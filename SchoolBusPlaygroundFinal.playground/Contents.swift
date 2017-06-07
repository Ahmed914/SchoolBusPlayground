/*: 
⬇️ *Vous pouvez ignorez le code ci-dessous, il nous permet juste d'initialiser et de visualiser le canva à droite.*
 */
import PlaygroundSupport
let canva = Canva()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = canva

/*:
 - - -
 # Découverte du canva
 Le canva, c'est l'étendue de pelouse verte qui se trouve sur la droite 🌿.
 Sur ce canva, nous allons pouvoir dessiner notre route. Et nous allons faire cela en utilisant les fonctions proposées par le canva :
 ## Route

 `canva.createRoadSection()`
 - 🛣 Cette fonction permet de **créer une section de route**. A chaque appel de cette fonction, une nouvelle section de route est crée.

 `canva.createHomeRoadSection()`
 - 🛣🏠 Similaire à la précédente, cette fonction permet de créer une section de route **qui contient une maison**.
 
 `canva.createSchoolRoadSection()`
 - 🛣🏫 Similaire à la précédente, cette fonction permet de créer une section de route **qui contient une école**.
 
 ## Bus
 `canva.moveBusForward()`

 - 🚌➡️ Cette fonction permet d'avancer le bus jusqu'à la section de route suivante. Attention, le bus ne peut pas avancer si il n'y a plus de route devant lui.
 
 `canva.stopBus()`
 - 🚌🛑 Cette fonction permet de faire marquer à un arrêt au bus.
 
 ## A vous de jouer !
 */
class Bus {
    var driverName: String
    var seats = 20

    var occupiedSeats = 0 {
        willSet {
            print("Il y a du mouvement dans le bus...")
        }
        didSet {
            if oldValue < occupiedSeats {
                print("\(occupiedSeats - oldValue) personnes viennent de monter !")
            } else {
                print("\(oldValue - occupiedSeats) personnes viennent de descendre !")
            }
        }
    }

    var description: String {
        return "Je suis un bus conduit par \(driverName) avec \(occupiedSeats) personnes dedans."
    }

    let numberOfWheel = 4

    init(driverName: String) {
        self.driverName = driverName
    }

    func moveForward() {
    	canva.moveBusForward()
    }

    func stop() {
        canva.stopBus()
    }

    func drive(road: Road) {
        for _ in road.sections {
            moveForward()
        }
    }
}

class SchoolBus: Bus {
    var schoolName = ""

    override func drive(road: Road) {
        for section in road.sections {
            switch section.type {
            case .plain:
                moveForward()
            case .home:
                if shouldPickChildren() {
                    pickChildren(from: section)
                    stop()
                }
                moveForward()
            case .school:
                dropChildren()
                stop()
            }
        }
    }

    private func shouldPickChildren() -> Bool {
        return occupiedSeats < seats
    }

    private func pickChildren(from roadSection: RoadSection) {
        if let section = roadSection as? HomeRoadSection {
            occupiedSeats += section.children
        }
    }

    private func dropChildren() {
        occupiedSeats = 0
    }
}

class Road {
    static let maxLength = 77

    static func createStraightRoad() -> Road {
        return Road(length: 11)
    }

    static func createRoadToSchool() -> Road {
        let road = Road()
        for i in 0..<30 {
            if i%7 == 1 {
                road.sections.append(HomeRoadSection(children: 2))
            } else {
                road.sections.append(RoadSection(type: .plain))
            }
        }
        road.sections.append(SchoolRoadSection())
        return road
    }


    var sections = [RoadSection]()

    init() {}

    init(length: Int) {
        var length = length
        if length > Road.maxLength {
            length = Road.maxLength
        }
        for _ in 0..<length {
            self.sections.append(RoadSection(type: .plain))
        }
    }
}

enum RoadSectionType {
    case plain
    case home
    case school
}

class RoadSection {
    var type: RoadSectionType

    convenience init() {
        self.init(type: .plain)
    }

    init(type: RoadSectionType) {
        self.type = type
        switch type {
        case .plain:
            canva.createRoadSection()
        case .home:
            canva.createHomeRoadSection()
        case .school:
            canva.createSchoolRoadSection()
        }
    }
}

class HomeRoadSection: RoadSection {
    var children: Int

    convenience init() {
        self.init(children: 2)
    }

    init(children: Int) {
        self.children = children
        super.init(type: .home)
    }
}

class SchoolRoadSection: RoadSection {
    init() {
        super.init(type: .school)
    }
}

var road = Road.createRoadToSchool()
var unBusScolaire = SchoolBus(driverName: "Joe")
unBusScolaire.seats = 50
unBusScolaire.description
unBusScolaire.drive(road: road)
