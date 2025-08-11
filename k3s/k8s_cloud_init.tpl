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

write_files:
  - path: /usr/local/bin/create-k8s-user-config.sh
    permissions: '0755'
    owner: 'root:root'
    content: |
      #!/usr/bin/env bash
      if [[ $EUID -ne 0 ]]; then
         echo "This script must be run as root" 
         exit 1
      fi
      if [ $# -eq 0 ]; then
          echo "No user name arguments supplied"
          exit 1
      fi
      USER=$1
      CAROOTDIR=/var/lib/rancher/k3s/server/tls
      
      CLIENTCA=$CAROOTDIR/client-ca
      SERVERCA=$CAROOTDIR/server-ca
      
      CURDIR=$PWD
      WORKDIR=client_cert/$USER
      
      mkdir -p $WORKDIR
      cd $WORKDIR
      
      #
      # Set up temporary openssl configuration
      #
      mkdir -p ".ca/certs"
      trap "rm -rf .ca" EXIT
      touch .ca/index
      openssl rand -hex 8 > .ca/serial
      cat >.ca/config <<'EOF'
      [ca]
      default_ca = ca_default
      [ca_default]
      dir = ./.ca
      database = $dir/index
      serial = $dir/serial
      new_certs_dir = $dir/certs
      default_md = sha256
      policy = policy_anything
      [policy_anything]
      commonName = supplied
      organizationName = supplied
      [req]
      distinguished_name = req_distinguished_name
      [req_distinguished_name]
      [v3_ca]
      authorityKeyIdentifier = keyid:always
      keyUsage = critical, digitalSignature, keyEncipherment
      extendedKeyUsage = clientAuth
      EOF
      
      #
      #Create Key
      #
      openssl ecparam -name prime256v1 -genkey -noout -out $USER.key
      
      #
      #Create CSR and Certificate
      #
      openssl req -new -nodes \
                       -subj "/O=system:masters/CN=extuser:$USER" \
                       -key $USER.key |
           openssl ca  -batch -notext -days 365 \
                       -in /dev/stdin \
                       -out $USER-cert.pem \
                       -keyfile $CLIENTCA.key \
                       -cert $CLIENTCA.nochain.crt \
                       -config .ca/config \
                       -extensions v3_ca
      #
      #View Certificate
      #
      #openssl x509 -in $USER-cert.pem -noout -text
      
      cd $CURDIR
      cat << EOF > $USER.kubeconfig.yaml
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: $(cat $SERVERCA.nochain.crt | base64 -w 0)
          server: https://127.0.0.1:6443
        name: default
      contexts:
      - context:
          cluster: default
          user: $USER
        name: default
      current-context: default
      kind: Config
      preferences: {}
      users:
      - name: $USER
        user:
          client-certificate-data: $(cat $WORKDIR/$USER-cert.pem $CLIENTCA.nochain.crt | base64  -w 0)
          client-key-data: $(cat $WORKDIR/$USER.key | base64  -w 0)
      EOF

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
  - sed -i -E 's/#?PubkeyAuthentication (yes|no)/PubkeyAuthentication yes/' /etc/ssh/sshd_config
  - echo "Match Group nologin-ssh-users" >> /etc/ssh/sshd_config
  - echo "    ChrootDirectory %h" >> /etc/ssh/sshd_config
  - echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config
  - systemctl enable ssh
  - systemctl restart sshd
  - ufw allow 22/tcp
  - curl -sfL https://get.k3s.io | sh -

power_state:
  delay: "now"
  mode: reboot
  message: Cloud-init, rebooting ...
  timeout: 30
  condition: True

final_message: "Cloud-init finished!"