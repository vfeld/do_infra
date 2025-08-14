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

apt:
  preserve_sources_list: true
  sources:
    caddy:
      source: 'deb [signed-by=$KEY_FILE] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main'
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v2
        
        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
        A5zVwuXbvH6GHaZJVHUrII6w8rjimo5r
        =e4lF
        -----END PGP PUBLIC KEY BLOCK-----

packages:
  - caddy

write_files:
  - path: /etc/caddy/Caddyfile
    permissions: '0600'
    owner: 'root:root'
    content: |
      ${droplet_name}.${domain_name} {
        reverse_proxy localhost:3000
      }

  - path: /etc/systemd/system/gitea.service
    permissions: '0755'
    owner: 'root:root'
    content: |
      [Unit]
      Description=Gitea (Git with a cup of tea)
      After=network.target
      
      [Service]
      # Uncomment the next line if you have repos with lots of files and get a HTTP 500 error because of that
      # LimitNOFILE=524288:524288
      RestartSec=2s
      Type=simple
      User=git
      Group=git
      WorkingDirectory=/mnt/${volume_name}/gitea/
      # If using Unix socket: tells systemd to create the /run/gitea folder, which will contain the gitea.sock file
      # (manually creating /run/gitea doesn't work, because it would not persist across reboots)
      #RuntimeDirectory=gitea
      Restart=always
      Environment="HTTP_ADDR=127.0.0.1"
      Environment="HTTP_PORT=3000"
      Environment="DOMAIN=${droplet_name}.${domain_name}"
      Environment="ROOT_URL=https://${droplet_name}.${domain_name}/"
      Environment="USER=git"
      Environment="HOME=/mnt/${volume_name}/git"
      Environment="GITEA_WORK_DIR=/mnt/${volume_name}/gitea"
      Environment="DISABLE_REGISTRATION=true"
      Environment="ENABLE_OPENID_SIGNIN=false"
      Environment="ENABLE_OPENID_SIGNUP=false"
      Environment="REQUIRE_SIGNIN_VIEW=true"
      Environment="ENABLE_TIMETRACKING=false"
      Environment="DEFAULT_ENABLE_TIMETRACKING=false"
      ExecStart=/usr/local/bin/gitea web 
      # If you want to bind Gitea to a port below 1024, uncomment
      # the two values below, or use socket activation to pass Gitea its ports as above
      ###
      #CapabilityBoundingSet=CAP_NET_BIND_SERVICE
      #AmbientCapabilities=CAP_NET_BIND_SERVICE
      ###
      # In some cases, when using CapabilityBoundingSet and AmbientCapabilities option, you may want to
      # set the following value to false to allow capabilities to be applied on gitea process. The following
      # value if set to true sandboxes gitea service and prevent any processes from running with privileges
      # in the host user namespace.
      ###
      #PrivateUsers=false
      ###
      
      [Install]
      WantedBy=multi-user.target
  - path: /usr/local/bin/setup_gitea.sh
    permissions: '0755'
    owner: 'root:root'
    content: |
      #!/bin/bash
      if [[ $EUID -ne 0 ]]; then
         echo "This script must be run as root" 
         exit 1
      fi
      get_gitea_domain() {
          echo "${domain_name}"
      }
      
      get_gitea_volume_name() {
          echo "${volume_name}"
      }
      
      get_gitea_base_url() {
          echo "https://dl.gitea.com/gitea"
      }
      
      get_gitea_mount_point() {
      	echo "/mnt/$(get_gitea_volume_name)"
      }
      
      get_gitea_device() {
          echo "/dev/disk/by-id/scsi-0DO_Volume_$(get_gitea_volume_name)"
      }
      
      is_gitea_in_fstab() {
          local mount_point
          mount_point=$(get_gitea_mount_point)
      
          if grep -qE "[[:space:]]$mount_point[[:space:]]" /etc/fstab; then
              #logger -t setup_gitea "fstab check succeeded: $mount_point is listed in /etc/fstab."
              return 0
          else
              #logger -t setup_gitea "fstab check failed: $mount_point is not listed in /etc/fstab."
              return 1
          fi
      }
      
      is_gitea_mounted() {
          local mount_point
          mount_point=$(get_gitea_mount_point)
      
          if mountpoint -q "$mount_point"; then
              #logger -t setup_gitea "Mount check succeeded: $mount_point is mounted."
              return 0
          else
              #logger -t setup_gitea "Mount check failed: $mount_point is not mounted."
              return 1
          fi
      }
      
      add_gitea_to_fstab() {
          local mount_point device fstab_entry
          device="$(get_gitea_device)"
          mount_point=$(get_gitea_mount_point)
          fstab_entry="$device $mount_point ext4 defaults,nofail,discard,noatime 0 2"
          echo "$fstab_entry" >> /etc/fstab
          return 0
      }
      
      remount_gitea_volume() {
          local mount_point device fstab_entry
          mount_point=$(get_gitea_mount_point)
          if ! is_gitea_mounted; then
              mkdir -p $mount_point
              systemctl daemon-reload || return $?
            mount $mount_point || return$?
          fi
          return 0
      }
      
      ensure_gitea_volume_is_mounted() {
          if ! is_gitea_in_fstab; then
              if ! add_gitea_to_fstab; then
                  logger -t setup_gitea "Failed to add Gitea mount to fstab."
                  exit 1
              fi
          fi
      
          if ! remount_gitea_volume; then
              logger -t setup_gitea "Failed to mount Gitea volume"
              exit 2
          fi
      }
      
      
      get_gittea_latest_version() {
          local version base_url
          base_url=$(get_gitea_base_url)
          version=$(curl -s "$base_url/version.json" | jq -r '.latest.version')
          if [[ ! "$version" =~ ^1\.[0-9]+\.[0-9]+$ ]]; then
              logger -t setup_gitea "Invalid version format for latest gitea version: '$version'"
              exit 3
          fi
          echo "$version"
      }
      
      install_latest_gitea() {
          local version bin_name bin_url sig_url tmpdir gpg_key_id gpg_key_server
      
          version=$(get_gittea_latest_version)
          bin_name="gitea-$version-linux-amd64"
          bin_url="https://dl.gitea.com/gitea/$version/$bin_name"
          sig_url="$bin_url.asc"
          gpg_key_id="7C9E68152594688862D62AF62D9AE806EC1592E2"
          gpg_key_server="keys.openpgp.org"
      
          tmpdir=$(mktemp -d)
          cd "$tmpdir" || exit 4
      
          # Download binary and signature
          logger -t setup_gitea "Download latest gitea version from $bin_url"
          wget -q -O gitea "$bin_url" || { logger -t install_gitea "Failed to download binary"; exit 5; }
          wget -q -O gitea.asc "$sig_url" || { logger -t install_gitea "Failed to download signature"; exit 6; }
      
          chmod +x gitea
      
          # Verify signature
          if gpg --verify gitea.asc gitea 2>&1 | grep -q 'Good signature'; then
              logger -t setup_gitea "Gitea GPG signature verified successfully"
          else
              logger -t setup_gitea "Gitea GPG signature verification failed"
              exit 7
          fi
      
          # Move binary to /usr/local/bin
          mv gitea /usr/local/bin/gitea || {
              logger -t setup_gitea "Failed to move Gitea to /usr/local/bin"
              exit 8
          }
      
          logger -t setup_gitea "Gitea $version installed successfully at /usr/local/bin/gitea"
          rm -rf "$tmpdir"
          return 0
      }
      
      import_gitea_public_key() {
         gpg --import >/dev/null 2>&1 <<EOF 
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      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
      =tFwr
      -----END PGP PUBLIC KEY BLOCK-----
      EOF
      }
      
      ensure_git_user() {
          local username="git"
          local home_dir="$(get_gitea_mount_point)/git"
      
          if [[ ! -d "$home_dir" ]]; then
      	      if ! id "$username" &>/dev/null; then
      	          adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home $home_dir git
              fi
          else
              if ! id "$username" &>/dev/null; then
                  adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --no-create-home --home $home_dir git
              fi
              chown -R git:git $home_dir
          fi
      }
      
      ensure_gitea_dirs() {
          local username="git"
          local work_dir="$(get_gitea_mount_point)/gitea"
      
          if [[ ! -d "$work_dir" ]]; then
      	      mkdir -p $work_dir/{custom,data,log}
      	      mkdir -p $work_dir/custom/conf
              chown -R git:git $work_dir
          else
              chown -R git:git $work_dir
          fi
      }
      
      start_gitea() {
          systemctl daemon-reload
          systemctl enable gitea
          systemctl start gitea
          #ufw allow 80/tcp
          #ufw allow 443/tcp
          logger -t setup_gitea "Gitea was setup successfully"
      }
      
      main() {
          ensure_gitea_volume_is_mounted
          import_gitea_public_key
          install_latest_gitea
          ensure_git_user
          ensure_gitea_dirs
          start_gitea
      }
      
      main
      
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
  - systemctl enable ssh
  - systemctl restart sshd
  - ufw allow 22/tcp
  - systemctl stop caddy
  - chmod 644 /etc/caddy/Caddyfile

power_state:
  delay: "now"
  mode: reboot
  message: Cloud init, rebooting ...
  timeout: 30
  condition: True

final_message: "Cloud-init finished!"