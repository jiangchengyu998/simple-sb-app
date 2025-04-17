# simple-sb-app

```shell
resource "google_network_security_trust_config" "client_trust_config" {
  name     = "client-trust-config"
  location = "global"

  trust_stores {
    trust_anchors {
      pem_certificate = file("client-root-ca.pem")
    }
  }
}

resource "google_network_security_client_tls_policy" "client_tls_policy" {
  name         = "client-tls-policy"
  location     = "global"
  description  = "Require client certs"
  mtls_policy {
    client_validation_mode = "REQUIRE"
    client_validation_trust_config = google_network_security_trust_config.client_trust_config.id
  }
}


resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "my-https-proxy"
  ssl_certificates = [google_compute_managed_ssl_certificate.lb_cert.id]
  url_map          = google_compute_url_map.url_map.id

  client_tls_policy = google_network_security_client_tls_policy.client_tls_policy.id
}

```
