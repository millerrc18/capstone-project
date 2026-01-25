# frozen_string_literal: true

require "base64"
require "fileutils"

require_relative "../../lib/import_template_assets"

templates = {
  "costs.xlsx" => ImportTemplateAssets::COSTS_XLSX_BASE64,
  "contract_workbook.xlsx" => ImportTemplateAssets::CONTRACT_WORKBOOK_XLSX_BASE64
}

templates_dir = Rails.root.join("public", "templates")
FileUtils.mkdir_p(templates_dir)

templates.each do |filename, base64_contents|
  path = templates_dir.join(filename)
  next if path.exist?

  path.binwrite(Base64.decode64(base64_contents))
end
