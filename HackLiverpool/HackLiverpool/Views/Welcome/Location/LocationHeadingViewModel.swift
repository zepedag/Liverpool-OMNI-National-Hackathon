// File: LocationHeadingViewModel.swift
import SwiftUI
import CoreLocation

class LocationHeadingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentHeading: Double = 0.0 // Grados desde el Norte Magnético/Verdadero
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // Aunque no usaremos updates de locación
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingHeading() {
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 5 // Actualizar si el heading cambia por 5 grados (ajustable)
            locationManager.startUpdatingHeading()
            print("LocationManager: Iniciando actualizaciones de heading.")
        } else {
            print("LocationManager: Heading no disponible en este dispositivo.")
            // Podrías querer mostrar un mensaje al usuario
        }
    }

    func stopUpdatingHeading() {
        locationManager.stopUpdatingHeading()
        print("LocationManager: Deteniendo actualizaciones de heading.")
    }

    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            if self.authorizationStatus == .authorizedWhenInUse || self.authorizationStatus == .authorizedAlways {
                print("LocationManager: Permiso concedido.")
                self.startUpdatingHeading()
            } else {
                print("LocationManager: Permiso denegado o restringido: \(self.authorizationStatus)")
                // Podrías querer mostrar un mensaje al usuario
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            // trueHeading es relativo al norte geográfico (si hay info de GPS)
            // magneticHeading es relativo al norte magnético.
            // Para interiores, magneticHeading suele ser más consistente si no hay buena señal GPS.
            // Si newHeading.trueHeading es negativo, significa que no es válido.
            self.currentHeading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
            // print("LocationManager: Nuevo heading: \(self.currentHeading)°")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager: Error al obtener heading: \(error.localizedDescription)")
    }
}
