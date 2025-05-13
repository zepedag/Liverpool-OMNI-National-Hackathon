import Foundation
import CoreLocation
import SceneKit

func directionVector(from origin: CLLocation, to destination: CLLocation) -> SCNVector3 {
    let deltaLat = destination.coordinate.latitude - origin.coordinate.latitude
    let deltaLon = destination.coordinate.longitude - origin.coordinate.longitude

    let latMeters = deltaLat * 111_000
    let lonMeters = deltaLon * 111_000 * cos(origin.coordinate.latitude * .pi / 180)

    return SCNVector3(Float(lonMeters), 0, -Float(latMeters))
}

