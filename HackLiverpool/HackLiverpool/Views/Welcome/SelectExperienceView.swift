
import SwiftUI

struct OptionButtonView: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(Color.liverpoolPink) // Usará la extensión definida en WelcomeLiverpoolView.swift
                    .frame(width: 35, alignment: .center)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

struct SelectExperienceView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("¿Cómo podemos ayudarte?")
                    .font(.title.bold())
                    .padding(.top, 50)
                    .padding(.bottom, 20)

                OptionButtonView(
                    iconName: "compass.drawing",
                    title: "Encuentra lo que buscas",
                    action: {
                        print("Acción: Guiar al producto.")
                    }
                )

                OptionButtonView(
                    iconName: "person.fill.questionmark",
                    title: "Asistencia de un experto Liverpool",
                    action: {
                        print("Acción: Solicitar asistencia de vendedor.")
                    }
                )

                OptionButtonView(
                    iconName: "moon.zzz.fill",
                    title: "Explorar por mi cuenta",
                    action: {
                        print("Acción: No molestar.")
                        dismiss()
                    }
                )

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Volver")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct SelectExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        
        SelectExperienceView()
    }
}
