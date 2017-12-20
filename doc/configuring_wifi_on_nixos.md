# Configuring Wifi on NixOS

## Add a new network (needs root)

    wpa_passphrase SSID PASSPHRASE >> /etc/wpa_supplicant.conf
    systemctl restart wpa_supplicant.service

## Scan for nearby networks (needs root)

    wpa_cli
    > scan
    # Wait for CTRL-EVENT-SCAN-RESULTS
    > scan_results
