#cloud-config
package_update: true
package_upgrade: true

users:
  - name: ${admin_user}
    ssh-authorized-keys:
      - ${pub_ssh_key}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    lock_passwd: true
    shell: /bin/bash

groups:
  - nologin-ssh-users

packages:
  - wireguard
  - qrencode
  - dbus-x11
  - xfce4 
  - xorg 
  - policykit-1
  - xfce4-power-manager
  - xfce4-terminal

write_files:
  - path: /usr/local/bin/create-wireguard.sh
    permissions: '0755'
    owner: 'root:root'
    content: |
      #!/bin/bash
      
      # Enable IP forwarding for IPv4 and IPv6
      echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
      echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
      sysctl -p
      
      # Generate server keys
      cd /etc/wireguard
      umask 077
      wg genkey | tee privatekey | wg pubkey > publickey
      
      # Create server configuration
      cat > /etc/wireguard/wg0.conf << EOF
      [Interface]
      PrivateKey = $(cat privatekey)
      Address = 10.0.0.1/24, fd86:ea04:1115::1/64
      ListenPort = 51820
      SaveConfig = true
      
      PostUp = ufw route allow in on wg0 out on eth0
      PostDown = ufw route delete allow in on wg0 out on eth0
      
      # IPv4
      PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
      PostUp = iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
      PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
      PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
      
      # IPv6
      PostUp = ip6tables -A FORWARD -i wg0 -j ACCEPT
      PostUp = ip6tables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
      PostDown = ip6tables -D FORWARD -i wg0 -j ACCEPT
      PostDown = ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
      EOF
      
      # Configure firewall
      ufw allow 51820/udp
      ufw allow in on wg0 to 10.0.0.1
      ufw allow out on wg0 from 10.0.0.1
      ufw route allow in on wg0 out on eth0
      
      # Start WireGuard
      systemctl enable wg-quick@wg0
      systemctl start wg-quick@wg0
      
      # Create client directory
      mkdir -p /etc/wireguard/clients
      
      # Generate client keys
      cd /etc/wireguard/clients
      wg genkey | tee client1_private.key | wg pubkey > client1_public.key
      
      # Get server IPv6 address
      SERVER_IPV6=$(ip -6 addr show dev eth0 | grep -oP '(?<=inet6 )([0-9a-f:]+)' | head -1)
      
      # Create client configuration
      cat > client1.conf << EOF
      [Interface]
      PrivateKey = $(cat client1_private.key)
      Address = 10.0.0.2/32, fd86:ea04:1115::2/128
      DNS = 1.1.1.1, 2606:4700:4700::1111
      
      [Peer]
      PublicKey = $(cat ../publickey)
      Endpoint = [$SERVER_IPV6]:51820
      AllowedIPs = 0.0.0.0/0, ::/0
      PersistentKeepalive = 25
      EOF
      
      # Add client to server configuration
      wg set wg0 peer $(cat client1_public.key) allowed-ips 10.0.0.2/32,fd86:ea04:1115::2/128
      # Show QR-Code for client setup
      qrencode -t ansiutf8 < /etc/wireguard/clients/client1.conf

  - path: /etc/systemd/system/ttyd.service
    permissions: '0644'
    owner: 'root:root'
    content: |
      [Unit]
      Description=Remote ttyd service (xtermjs)
      After=syslog.target network.target wg-quick@wg0.service
      
      [Service]
      Type=simple
      User=admuser
      Restart=always
      ExecStart=/snap/bin/ttyd -i wg0 -p 8000 -w /home/admuser -W /bin/bash
      
      [Install]
      WantedBy=multi-user.target

  - path: /home/${admin_user}/.config/helix/config.toml
    permissions: '0644'
    owner: ${admin_user}:${admin_user}'
    content: |
       theme = "everforest_dark"
       
       [keys.insert]
       j = { k = "normal_mode"}
       [keys.normal]
       "ret" = "goto_word"
       [keys.normal."space"]
       o = "file_picker_in_current_buffer_directory"
       
       [editor]
       cursorline = true
       lsp.display-inlay-hints = true
       [editor.inline-diagnostics]
       cursor-line = "hint"
       [editor.auto-save]
       after-delay.enable=true
       after-delay.timeout=3000
  - path: /usr/local/bin/create-rust.sh
    permissions: '0755'
    owner: 'root:root'
    content: |
      #!/bin/bash
      curl -sL https://github.com/helix-editor/helix/releases/download/25.07.1/helix_25.7.1-1_amd64.deb > helix.deb
      dpkg -i helix.deb
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      rustup component add rust-src
      rustup component add rust-analyzer


runcmd:
  - passwd -l root
  - ufw enable
  - ufw default deny incoming
  - ufw default allow outgoing
  - ufw default deny routed
  - sed -i -E 's/#?PasswordAuthentication (yes|no)/PasswordAuthentication no/' /etc/ssh/sshd_config
  - sed -i -E 's/#?PermitRootLogin (yes|no)/PermitRootLogin no/' /etc/ssh/sshd_config
  - sed -i -E 's/#?X11Forwarding (yes|no)/X11Forwarding no/' /etc/ssh/sshd_config
  - sed -i -E 's/#?PermitEmptyPasswords (yes|no)/PermitEmptyPasswords no/' /etc/ssh/sshd_config
  - sed -i -E 's/#?IgnoreRhosts (yes|no)/IgnoreRhosts yes/' /etc/ssh/sshd_config
  - sed -i -E 's/#?HostbasedAuthentication (yes|no)/HostbasedAuthentication no/' /etc/ssh/sshd_config
  - sed -i -E 's/#?GSSAPIAuthentication (yes|no)/GSSAPIAuthentication no/' /etc/ssh/sshd_config
  - sed -i -E 's/#?KerberosAuthentication (yes|no)/KerberosAuthentication no/' /etc/ssh/sshd_config
  - sed -i -E 's/#?PubkeyAuthentication (yes|no)/PubkeyAuthentication yes/' /etc/ssh/sshd_config
  - echo "Match Group nologin-ssh-users" >> /etc/ssh/sshd_config
  - echo "    ChrootDirectory %h" >> /etc/ssh/sshd_config
  - echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config
  - systemctl enable ssh
  - systemctl restart sshd
  - ufw allow 22/tcp
  - snap install ttyd --classic

power_state:
  delay: "now"
  mode: reboot
  message: Cloud-init, rebooting ...
  timeout: 30
  condition: True

final_message: "Cloud-init finished!"