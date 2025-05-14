// File: ArrowView.swift
import SwiftUI

struct ArrowView: View {
    @Environment(\.dismiss) var dismissArrowViewPresentation
    @Binding var navigateToHomeViewRoot: Bool

    @State private var arrowRotationDegrees: Double = 0.0
    @State private var guidanceMessage: String = "Selecciona una opción para iniciar la guía."
    
    let finalTargetCoordinates: CGPoint = CGPoint(x: 20, y: 45)
    @State private var pathWaypoints: [CGPoint] = [
        CGPoint(x: 0, y: 20),
        CGPoint(x: 20, y: 20),
        CGPoint(x: 20, y: 45)
    ]
    @State private var currentWaypointIndex: Int = 0
    @State private var currentUserCoordinates: CGPoint = CGPoint(x: 0, y: 0)
    @State private var simulatedDeviceHeading: Double = 0.0

    @State private var isDeviceTurnDelayed: Bool = false
    let deviceTurnHoldDuration: TimeInterval = 2.5

    let simulationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let movementSpeed: CGFloat = 0.15
    let rotationSpeedFactor: Double = 0.07

    @State private var guidanceActive: Bool = true
    @State private var pulseAnimationAmount: CGFloat = 1.0
    @State private var bobAnimationAmount: CGFloat = 0.0

    @State private var totalPathDistance: CGFloat = 1.0
    @State private var currentProgress: Double = 0.0
    
    // Helper function for distance calculation
    func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }

    func resetSimulationAndPrepareGuidance() {
        currentUserCoordinates = CGPoint(x: 0, y: 0)
        currentWaypointIndex = 0
        simulatedDeviceHeading = 0.0
        arrowRotationDegrees = 0.0
        isDeviceTurnDelayed = false
        currentProgress = 0.0

        // Calculate total path distance
        self.totalPathDistance = 0
        var previousPointForSegment = self.currentUserCoordinates
        if !pathWaypoints.isEmpty {
            for i in 0..<pathWaypoints.count {
                self.totalPathDistance += distanceBetween(previousPointForSegment, pathWaypoints[i])
                previousPointForSegment = pathWaypoints[i]
            }
        }
        if self.totalPathDistance == 0 { self.totalPathDistance = 1.0 }

        // Orient initial simulated heading toward first waypoint
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
        updateProgressIndicator()
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
            currentProgress = guidanceActive ? 0.0 : 1.0
            return
        }

        var distanceTraveled: CGFloat = 0.0
        var lastPointForTraveled = CGPoint(x: 0, y: 0)

        // Distance of completed segments
        for i in 0..<currentWaypointIndex {
            distanceTraveled += distanceBetween(lastPointForTraveled, pathWaypoints[i])
            lastPointForTraveled = pathWaypoints[i]
        }

        // Distance in current segment
        if currentWaypointIndex < pathWaypoints.count {
             distanceTraveled += distanceBetween(lastPointForTraveled, currentUserCoordinates)
        } else {
            distanceTraveled = totalPathDistance
        }
        
        currentProgress = max(0.0, min(1.0, Double(distanceTraveled / totalPathDistance)))

        if !guidanceActive && distanceBetween(currentUserCoordinates, pathWaypoints.last ?? currentUserCoordinates) < 0.1 {
             currentProgress = 1.0
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

        // Move user
        if distanceToWaypoint > movementSpeed {
            let moveFactor = movementSpeed / distanceToWaypoint
            currentUserCoordinates.x += dxToWaypoint * moveFactor
            currentUserCoordinates.y += dyToWaypoint * moveFactor
            dxToWaypoint = targetWaypoint.x - currentUserCoordinates.x
            dyToWaypoint = targetWaypoint.y - currentUserCoordinates.y
            distanceToWaypoint = distanceBetween(currentUserCoordinates, targetWaypoint)
        } else if distanceToWaypoint > 0.01 {
            currentUserCoordinates = targetWaypoint
            distanceToWaypoint = 0
        }

        // Check if reached current waypoint
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
                guidanceMessage = "¡Has llegado a perfumeria!"
                guidanceActive = false
                currentProgress = 1.0
                return
            }
        }

        // Simulate device orientation
        if !isDeviceTurnDelayed {
            let currentTargetForHeading = pathWaypoints[currentWaypointIndex]
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
            
            if guidanceActive {
                 let distToCurrentWptMsg = distanceBetween(currentUserCoordinates, pathWaypoints[currentWaypointIndex])
                 guidanceMessage = "Camina \(String(format: "%.0f", distToCurrentWptMsg))m en la dirección de la flecha."
            }
        }
        
        updateGuidanceArrow()
        updateProgressIndicator()
    }

    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 100) {
                Spacer()
                
                if guidanceActive {
                    Text("Caminando a Perfumería")
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
                    
                    VStack {
                        ProgressView(value: currentProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.liverpoolPink))
                            .animation(.linear(duration: 0.1), value: currentProgress)
                            .padding(.vertical, 5)
                        
                        HStack {
                            Text("Inicio")
                            Spacer()
                            Image(systemName: "flag.fill")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                        VStack {
                            Button(action: {
                                navigateToHomeViewRoot = true
                                dismissArrowViewPresentation()
                            }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                    Text("Terminar")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.liverpoolPink)
                                .cornerRadius(10)
                            }
                            .padding(.bottom, 60)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                } else {
                    Text(guidanceMessage)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                    
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
                        
                        Button(action: {
                            navigateToHomeViewRoot = true
                            dismissArrowViewPresentation()
                        }) {
                            Text("Salir")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.liverpoolPink)
                                .cornerRadius(10)
                        }
                        .padding(.top, 30)
                    }
                }
                
                Spacer()
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.1).ignoresSafeArea())
            .animation(.easeInOut(duration: 0.4), value: guidanceActive)
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
                if distanceBetween(currentUserCoordinates, pathWaypoints.last ?? currentUserCoordinates) < 0.1 {
                    currentProgress = 1.0
                }
            }
        }
        .onAppear {
            resetSimulationAndPrepareGuidance()
        }
        .navigationBarBackButtonHidden(true)
    }
}
struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView(navigateToHomeViewRoot: .constant(false))
    }
}
