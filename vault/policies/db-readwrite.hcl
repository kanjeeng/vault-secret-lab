# Hanya boleh meminta kredensial dinamis read-write dan me-renew lease miliknya
path "database/creds/app-readwrite" {
  capabilities = ["read"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}
