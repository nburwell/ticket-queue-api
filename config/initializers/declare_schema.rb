DeclareSchema.default_schema do
  timestamps
  optimistic_lock
end

DeclareSchema.default_charset = "utf8"
DeclareSchema.default_string_limit = 255
