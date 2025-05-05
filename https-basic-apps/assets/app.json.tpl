{
  "$schema": "https://raw.githubusercontent.com/F5Networks/f5-appsvcs-extension/master/schema/latest/as3-schema.json",
  "class": "AS3",
  "action": "deploy",
  "persist": true,
  "declaration": {
    "class": "ADC",
    "schemaVersion": "3.45.0",
    "id": "ce99e96e-2927-11ed-a261-0242ac120002",
    "label": "as3-terraform-labs",
    "${name}": {
      "class": "Tenant",
      "${name}": {
        "class": "Application",
        "vs_${name}": {
          "class": "Service_HTTPS",
          "remark": "${fqdn}",
          "virtualAddresses": [
            "${virtual_address}"
          ],
          "virtualPort": ${virtual_port},
          "redirect80": false,
          "serverTLS": "clientssl_${name}",
          %{ if tls_termination == "reencrypt" }
          "clientTLS": {
            "bigip": "/Common/serverssl"
          },
          %{ endif }
          "pool": "pool_${name}"
        },
        "pool_${name}": {
          "class": "Pool",
          "monitors": [
            {
              "use": "mon_${name}"
            }
          ],
          "members": [
            {
              "servicePort": ${service_port},
              "serverAddresses": [
                "10.16.200.101",
                "10.16.200.102",
                "10.16.200.103"
              ],
              "shareNodes": true
            }
          ]
        },
        "mon_${name}": {
          "class": "Monitor",
          %{ if tls_termination == "reencrypt" }
          "monitorType": "https",
          %{ else }
          "monitorType": "http",
          %{ endif }
          "send": "GET / HTTP/1.1\\r\\nHost: ${fqdn}\\r\\n\\r\\n",
          "receive": "HTTP/1.1 200 OK"
        },
        "clientssl_${name}": {
          "class": "TLS_Server",
          "certificates": [
            {
              "certificate": "certificate_${name}"
            }
          ]
        },
        "certificate_${name}": {
          "class": "Certificate",
          "certificate": {
            "bigip": "/Common/default.crt"
          },
          "privateKey": {
            "bigip": "/Common/default.key"
          }
        }
      }
    }
  }
}