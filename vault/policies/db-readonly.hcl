# Hanya boleh meminta kredensial dinamis read-only dan me-renew lease miliknya
path "database/creds/app-readonly" {
  capabilities = ["read"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}
