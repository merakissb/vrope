puts "🧼 Limpiando la base de datos..."
DailyTask.delete_all
ServiceParticipant.delete_all
Service.delete_all
Building.delete_all
PropertyManager.delete_all
User.delete_all

puts "👤 Creando usuarios..."

admin_user = User.create!(
  email: 'matias.quiroz@verticalspa.cl',
  password: '123456',
  first_name: 'Matías',
  last_name: 'Quiroz',
  second_last_name: 'Bustos',
  rut: '19.572.933-6',
  role: :admin
)

supervisor = User.create!(
  email: "francisco.parra@verticalspa.cl",
  password: "123456",
  first_name: "Francisco",
  last_name: "Parra",
  second_last_name: 'Tapia',
  rut: '14.022.838-9',
  role: :basic
)

# Crear operadores dinámicamente
operators = 3.times.map do |i|
  User.create!(
    email: "operador#{i+1}@verticalspa.cl",
    password: "123456",
    first_name: "Operador#{i+1}",
    last_name: "Apellido#{i+1}",
    role: :basic
  )
end

puts "🏢 Creando edificio y gestor..."
property_manager = PropertyManager.create!(name: 'CBRE')

building = Building.create!(
  name: 'Golf 2001',
  rut: '76.123.456-7',
  address_reference: 'Av. Libertador 1234, Santiago',
  floors: 10,
  year_built: 2010,
  property_manager: property_manager
)

puts "🔧 Creando servicio..."
service1 = Service.create!(
  name: 'Limpieza de Fachada',
  status: :in_progress,
  building: building,
  start_date: '2025-04-15',
  end_date: '2025-04-22'
)

puts "👷 Asignando participantes..."
ServiceParticipant.create!(service: service1, user: supervisor, role: :supervisor)

operators.each do |op|
  ServiceParticipant.create!(service: service1, user: op, role: :operator)
end

puts "📝 Creando Daily Tasks..."
[
  '2025-04-15',
  '2025-04-16',
  '2025-04-17'
].each do |day|
  DailyTask.create!(
    service: service1,
    date: day,
    name: 'Charla Diaria / Art',
    description: 'Verificar los riesgos críticos antes de ejecutar las labores',
    completed: false
  )
end

# daily tasks debe tener una opcion para agregar adjunto.

puts "✅ Seed completado con éxito"
