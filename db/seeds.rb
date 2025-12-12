# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

def assign_if(record, attr, value)
  setter = "#{attr}="
  record.public_send(setter, value) if record.respond_to?(setter)
end

def seed_demo!
  # Only seed demo data when explicitly requested
  return unless ENV["SEED_DEMO"] == "true"

  demo_email = ENV.fetch("DEMO_EMAIL", "demo@pmcopilot.app")
  demo_password = ENV.fetch("DEMO_PASSWORD", "ChangeMe123!ChangeMe123!")

  user = User.find_or_create_by!(email: demo_email) do |u|
    u.password = demo_password
    u.password_confirmation = demo_password
  end

  program = user.programs.find_or_create_by!(name: "Aeronose") do |p|
    p.customer = "Gulfstream"
    p.description = "Demo program seeded for capstone walkthrough."
  end

  c1 = program.contracts.find_or_create_by!(contract_code: "GA-276") do |c|
    c.fiscal_year = 2025
    c.start_date = Date.new(2025, 1, 1)
    c.end_date = Date.new(2025, 12, 31)
    c.planned_quantity = 24
    c.sell_price_per_unit = 52030
    c.notes = "Demo contract"
  end

  c2 = program.contracts.find_or_create_by!(contract_code: "GA-3059") do |c|
    c.fiscal_year = 2026
    c.start_date = Date.new(2026, 1, 1)
    c.end_date = Date.new(2026, 12, 31)
    c.planned_quantity = 30
    c.sell_price_per_unit = 52120
    c.notes = "Demo contract"
  end

  # Costs (ContractPeriods): 3 months of sample data for each contract
  [
    [c1, Date.new(2025, 1, 1), "month"],
    [c1, Date.new(2025, 2, 1), "month"],
    [c1, Date.new(2025, 3, 1), "month"],
    [c2, Date.new(2026, 1, 1), "month"],
    [c2, Date.new(2026, 2, 1), "month"],
    [c2, Date.new(2026, 3, 1), "month"]
  ].each do |contract, d, period_type|
    period = contract.contract_periods.find_or_initialize_by(period_start_date: d, period_type: period_type)
    period.units_delivered ||= 0
    period.revenue_per_unit ||= contract.sell_price_per_unit

    period.hours_bam ||= 120
    period.hours_eng ||= 24
    period.hours_mfg_soft ||= 80
    period.hours_mfg_hard ||= 40
    period.hours_touch ||= 16

    period.rate_bam ||= 125
    period.rate_eng ||= 155
    period.rate_mfg_soft ||= 110
    period.rate_mfg_hard ||= 140
    period.rate_touch ||= 95

    period.material_cost ||= 25000
    period.other_costs ||= 1500

    period.save!
  end

  # Delivery Milestones (promise dates + quantities)
  [
    [c1, "FY25-JAN", Date.new(2025, 1, 12), 2],
    [c1, "FY25-FEB", Date.new(2025, 2, 28), 3],
    [c1, "FY25-MAR", Date.new(2025, 3, 31), 2],
    [c2, "FY26-JAN", Date.new(2026, 1, 15), 3],
    [c2, "FY26-FEB", Date.new(2026, 2, 28), 2]
  ].each do |contract, ref, due_date, qty|
    m = contract.delivery_milestones.find_or_initialize_by(due_date: due_date)
    assign_if(m, :milestone_ref, ref)
    m.quantity_due = qty
    m.notes = "Seeded milestone #{ref}"
    m.save!
  end

  # Delivered units (unit-level shipments)
  [
    [c1, "RN-0001", Date.new(2025, 1, 10), "Shipped early"],
    [c1, "RN-0002", Date.new(2025, 1, 12), "Shipped on time"],
    [c1, "RN-0003", Date.new(2025, 2, 27), "Shipped on time"],
    [c2, "RN-1001", Date.new(2026, 1, 16), "One day late"]
  ].each do |contract, serial, ship_date, notes|
    u = contract.delivery_units.find_or_initialize_by(unit_serial: serial)
    u.ship_date = ship_date
    u.notes = notes
    u.save!
  end

  puts "Seeded demo user: #{demo_email}"
  puts "Seeded demo program: #{program.name} with contracts #{[c1.contract_code, c2.contract_code].join(', ')}"
end

seed_demo!
