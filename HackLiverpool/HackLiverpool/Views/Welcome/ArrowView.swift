// File: ArrowView.swift
import SwiftUI

struct ArrowView: View {
    @Environment(\.dismiss) var dismissArrowViewPresentation
    @State private var showExperienceSelector = true
    @State private var showExpertSheet = false
    @Binding var navigateToHomeViewRoot: Bool

    @State private var arrowRotationDegrees: Double = 0.0
    @State private var guidanceMessage: String = "Selecciona una opción para iniciar la guía."
    
    let finalTargetCoordinates: CGPoint = CGPoint(x: 20, y: 45) // No se usa directamente si pathWaypoints es la guía
    @State private var pathWaypoints: [CGPoint] = [
        CGPoint(x: 0, y: 20),
        CGPoint(x: 20, y: 20),
        CGPoint(x: 20, y: 45) // Destino final implícito
    ]
    @State private var currentWaypointIndex: Int = 0
    @State private var currentUserCoordinates: CGPoint = CGPoint(x: 0, y: 0)
    @State private var simulatedDeviceHeading: Double = 0.0

    @State private var isDeviceTurnDelayed: Bool = false
    let deviceTurnHoldDuration: TimeInterval = 2.5

    let simulationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let movementSpeed: CGFloat = 0.15
    let rotationSpeedFactor: Double = 0.07

    @State private var guidanceActive: Bool = false
    @State private var pulseAnimationAmount: CGFloat = 1.0
    @State private var bobAnimationAmount: CGFloat = 0.0

    // --- Estados para la Barra de Progreso ---
    @State private var totalPathDistance: CGFloat = 1.0 // Evitar división por cero
    @State private var currentProgress: Double = 0.0   // De 0.0 a 1.0
    // --- Fin Estados Barra de Progreso ---

    // Helper para calcular distancia
    func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }

    func handleExperienceAction(_ action: ExperienceAction) {
        if showExperienceSelector {
            showExperienceSelector = false
        }
        switch action {
        case .findProduct:
            print("Usuario permanece en ArrowView. Iniciando guía simulada...")
            guidanceActive = true // El resto se maneja en .onChange(of: guidanceActive)
            break
        case .requestExpert, .exploreOnMyOwn, .close:
            guidanceActive = false
            if action == .requestExpert {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { self.showExpertSheet = true }
            } else if action == .exploreOnMyOwn {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.navigateToHomeViewRoot = true
                    self.dismissArrowViewPresentation()
                }
            } else if action == .close {
                 guidanceMessage = "Guía detenida."
                 currentProgress = 0.0 // Resetear progreso si se cierra manualmente
            }
            break
        }
    }
    
    func resetSimulationAndPrepareGuidance() {
        currentUserCoordinates = CGPoint(x: 0, y: 0) // Punto de inicio de la simulación
        currentWaypointIndex = 0
        simulatedDeviceHeading = 0.0
        arrowRotationDegrees = 0.0
        isDeviceTurnDelayed = false
        currentProgress = 0.0 // Progreso inicial

        // Calcular la distancia total del camino
        self.totalPathDistance = 0
        var previousPointForSegment = self.currentUserCoordinates // Inicia desde la posición actual del usuario
        if !pathWaypoints.isEmpty {
            for i in 0..<pathWaypoints.count {
                self.totalPathDistance += distanceBetween(previousPointForSegment, pathWaypoints[i])
                previousPointForSegment = pathWaypoints[i]
            }
        }
        if self.totalPathDistance == 0 { self.totalPathDistance = 1.0 } // Evitar división por cero

        // Orientar el heading simulado inicial hacia el primer waypoint
        if !pathWaypoints.isEmpty {
            let firstWaypoint = pathWaypoints[0]
            let deltaX = firstWaypoint.x - currentUserCoordinates.x
            let deltaY = firstWaypoint.y - currentUserCoordinates.y
            if deltaX != 0 || deltaY != 0 {
                 simulatedDeviceHeading = atan2(deltaX, deltaY) * 180 / .pi
            }
        }
        guidanceMessage = "Calculando ruta simulada..."
        updateGuidanceArrow()
        updateProgressIndicator() // Calcular progreso inicial
    }

    func updateGuidanceArrow() {
        guard guidanceActive, currentWaypointIndex < pathWaypoints.count else { return }

        let currentTargetWaypoint = pathWaypoints[currentWaypointIndex]
        let deltaX = currentTargetWaypoint.x - currentUserCoordinates.x
        let deltaY = currentTargetWaypoint.y - currentUserCoordinates.y
        
        if abs(deltaX) > 0.01 || abs(deltaY) > 0.01 {
            let angleToTargetFromNorthRad = atan2(deltaX, deltaY)
            let angleToTargetFromNorthDeg = angleToTargetFromNorthRad * 180 / Double.pi
            arrowRotationDegrees = normalizeAngle(angleToTargetFromNorthDeg - simulatedDeviceHeading)
        }
    }

    func updateProgressIndicator() {
        guard totalPathDistance > 0 else {
            currentProgress = guidanceActive ? 0.0 : 1.0 // Si no hay distancia, 0 si activo, 1 si inactivo (llegó)
            return
        }

        var distanceTraveled: CGFloat = 0.0
        var lastPointForTraveled = CGPoint(x: 0, y: 0) // Punto de inicio original de la simulación

        // Distancia de segmentos completados
        for i in 0..<currentWaypointIndex {
            distanceTraveled += distanceBetween(lastPointForTraveled, pathWaypoints[i])
            lastPointForTraveled = pathWaypoints[i]
        }

        // Distancia en el segmento actual (desde el inicio del segmento hasta la pos actual del usuario)
        if currentWaypointIndex < pathWaypoints.count {
             distanceTraveled += distanceBetween(lastPointForTraveled, currentUserCoordinates)
        } else { // Si ya superó el último waypoint, se considera que ha recorrido todo
            distanceTraveled = totalPathDistance
        }
        
        currentProgress = max(0.0, min(1.0, Double(distanceTraveled / totalPathDistance)))

        if !guidanceActive && distanceBetween(currentUserCoordinates, pathWaypoints.last ?? currentUserCoordinates) < 0.1 {
             currentProgress = 1.0 // Asegurar 100% al llegar y desactivar guía
        }
    }

    func normalizeAngle(_ angle: Double) -> Double {
        var a = angle.truncatingRemainder(dividingBy: 360)
        if a > 180 { a -= 360 }
        if a < -180 { a += 360 }
        return a
    }
    
    func simulateFrameUpdate() {
        guard guidanceActive, currentWaypointIndex < pathWaypoints.count else { return }

        let targetWaypoint = pathWaypoints[currentWaypointIndex]
        var dxToWaypoint = targetWaypoint.x - currentUserCoordinates.x
        var dyToWaypoint = targetWaypoint.y - currentUserCoordinates.y
        var distanceToWaypoint = distanceBetween(currentUserCoordinates, targetWaypoint)

        // 1. Mover al usuario
        if distanceToWaypoint > movementSpeed {
            let moveFactor = movementSpeed / distanceToWaypoint
            currentUserCoordinates.x += dxToWaypoint * moveFactor
            currentUserCoordinates.y += dyToWaypoint * moveFactor
            dxToWaypoint = targetWaypoint.x - currentUserCoordinates.x // Recalcular para la lógica de llegada
            dyToWaypoint = targetWaypoint.y - currentUserCoordinates.y
            distanceToWaypoint = distanceBetween(currentUserCoordinates, targetWaypoint)
        } else if distanceToWaypoint > 0.01 {
            currentUserCoordinates = targetWaypoint
            distanceToWaypoint = 0
        }

        // 2. Verificar si se llegó al waypoint actual
        if distanceToWaypoint < 0.1 {
            if currentWaypointIndex < pathWaypoints.count - 1 {
                currentWaypointIndex += 1
                isDeviceTurnDelayed = true
                guidanceMessage = "¡Gira como indica la flecha!"
                DispatchQueue.main.asyncAfter(deadline: .now() + deviceTurnHoldDuration) {
                    if guidanceActive && self.currentWaypointIndex < self.pathWaypoints.count {
                        isDeviceTurnDelayed = false
                    }
                }
            } else {
                guidanceMessage = "¡Has llegado a Electrónica!"
                guidanceActive = false // Detener simulación
                currentProgress = 1.0 // Asegurar que el progreso sea 100%
                return
            }
        }

        // 3. Simular orientación del dispositivo (SI NO ESTÁ RETRASADO)
        if !isDeviceTurnDelayed {
            let currentTargetForHeading = pathWaypoints[currentWaypointIndex] // Usar el waypoint actual para el heading
            let dxForHeading = currentTargetForHeading.x - currentUserCoordinates.x
            let dyForHeading = currentTargetForHeading.y - currentUserCoordinates.y

            if dxForHeading != 0 || dyForHeading != 0 {
                let targetHeadingDeg = atan2(dxForHeading, dyForHeading) * 180 / .pi
                let turnDifference = normalizeAngle(targetHeadingDeg - simulatedDeviceHeading)
                if abs(turnDifference) > 0.5 {
                    simulatedDeviceHeading += turnDifference * rotationSpeedFactor
                } else if abs(turnDifference) > 0 {
                    simulatedDeviceHeading = targetHeadingDeg
                }
                simulatedDeviceHeading = normalizeAngle(simulatedDeviceHeading)
            }
            // Actualizar mensaje de distancia si no estamos en un "Gira!" o ya llegamos
            if guidanceActive { // Verificar de nuevo por si se desactivó al llegar
                 let finalDest = pathWaypoints.last!
                 let overallDistanceRemaining = distanceBetween(currentUserCoordinates, finalDest) // Podría ser más complejo
                 // Mejor usar la distancia al waypoint actual para el mensaje
                 let distToCurrentWptMsg = distanceBetween(currentUserCoordinates, pathWaypoints[currentWaypointIndex])
                 guidanceMessage = "Camina \(String(format: "%.0f", distToCurrentWptMsg))m en la dirección de la flecha."
            }
        }
        
        updateGuidanceArrow()
        updateProgressIndicator() // Actualizar la barra de progreso
    }

    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 15) { // Ajustar spacing general si es necesario
                Spacer()
                
                if guidanceActive {
                    Text("Guía a Electrónica")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.liverpoolPink)

                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color.liverpoolPink)
                        .scaleEffect(pulseAnimationAmount)
                        .offset(y: bobAnimationAmount)
                        .rotationEffect(.degrees(arrowRotationDegrees))
                        .animation(.easeInOut(duration: 0.35), value: arrowRotationDegrees)

                    Text(guidanceMessage)
                        .font(.title3)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .frame(minHeight: 60)
                    
                    // --- Barra de Progreso ---
                    VStack {
                        ProgressView(value: currentProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.liverpoolPink))
                            // La animación del progreso es importante para suavizarla
                            .animation(.linear(duration: 0.1), value: currentProgress)
                            .padding(.vertical, 5)
                        
                        HStack {
                            Text("Inicio")
                            Spacer()
                            Image(systemName: "flag.fill") // Icono de meta
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 40) // Padding para la barra de progreso
                    // --- Fin Barra de Progreso ---
                    
                    Text("Posición Sim: (\(String(format: "%.1f", currentUserCoordinates.x)), \(String(format: "%.1f", currentUserCoordinates.y)))")
                        .font(.caption)
                        .padding(.top, 5)
                    Text("Heading Sim: \(String(format: "%.1f", simulatedDeviceHeading))° (\(String(format: "%.1f", arrowRotationDegrees))° flecha)")
                        .font(.caption)

                } else if !showExperienceSelector {
                    Text(guidanceMessage)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                    // Mostrar progreso final si se llegó
                    if currentProgress >= 1.0 {
                         ProgressView(value: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.liverpoolPink))
                            .padding(.vertical, 5)
                         HStack {
                            Text("Inicio")
                            Spacer()
                            Image(systemName: "flag.fill")

                         }
                         .font(.caption)
                         .foregroundColor(.gray)
                         .padding(.horizontal, 40)
                    }
                } else {
                    Text("ArrowView")
                        .font(.largeTitle)
                    Text("Esperando selección...")
                        .padding()
                }
                
                Spacer()
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.orange.opacity(0.1).ignoresSafeArea())
            .animation(.easeInOut(duration: 0.4), value: guidanceActive)


            if showExperienceSelector {
                SelectExperienceOverlayView(onAction: handleExperienceAction)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showExperienceSelector)
        .sheet(isPresented: $showExpertSheet) {
            ExpertView()
        }
        .onReceive(simulationTimer) { _ in
            if guidanceActive {
                simulateFrameUpdate()
            }
        }
        .onChange(of: guidanceActive) { wasActive, isActive in
             if isActive {
                resetSimulationAndPrepareGuidance()
                
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    pulseAnimationAmount = 1.15
                }
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    bobAnimationAmount = -10
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    pulseAnimationAmount = 1.0
                    bobAnimationAmount = 0.0
                }
                // Si la guía se detiene porque se llegó al final, asegurar que el progreso sea 1.0
                if distanceBetween(currentUserCoordinates, pathWaypoints.last ?? currentUserCoordinates) < 0.1 {
                    currentProgress = 1.0
                }
            }
        }
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView(navigateToHomeViewRoot: .constant(false))
    }
}
