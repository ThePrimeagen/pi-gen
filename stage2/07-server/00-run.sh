#!/bin/bash -e
# Add Cloudflare repo key and list to target rootfs, then install inside chroot
install -d -m 0755 "${ROOTFS_DIR}/usr/share/keyrings"
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
  | tee "${ROOTFS_DIR}/usr/share/keyrings/cloudflare-main.gpg" >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bookworm main" \
  | tee "${ROOTFS_DIR}/etc/apt/sources.list.d/cloudflared.list"

on_chroot << 'EOF'
apt-get update
apt-get install -y cloudflared
# enable ssh at boot (if present)
systemctl enable ssh || systemctl enable ssh.service || true
EOF
