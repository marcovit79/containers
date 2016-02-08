#!/bin/sh
set -e

[ -d /dev/net ] ||
    mkdir -p /dev/net
[ -c /dev/net/tun ] ||
    mknod /dev/net/tun c 10 200

cd /etc/openvpn
# This file tells `serveconfig` that there is a config there
touch placeholder
[ -f dh.pem ] ||
    openssl dhparam -out dh.pem 1024
[ -f key.pem ] ||
    openssl genrsa -out key.pem 2048
chmod 600 key.pem
[ -f csr.pem ] ||
    openssl req -new -key key.pem -out csr.pem -subj /CN=OpenVPN/
[ -f cert.pem ] ||
    openssl x509 -req -in csr.pem -out cert.pem -signkey key.pem -days 24855

[ -f tcp443.conf ] || cat >tcp443.conf <<EOF
server 192.168.255.0 255.255.255.128
verb 3
duplicate-cn
key /etc/openvpn/key.pem
ca /etc/openvpn/cert.pem
cert /etc/openvpn/cert.pem
dh /etc/openvpn/dh.pem
keepalive 10 60
persist-key
persist-tun

push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 192.168.255.1"
push "route 10.32.0.0 255.240.0.0"

proto tcp-server
port 443
dev tun443
status openvpn-status-443.log
EOF

#MY_IP_ADDR=$(curl -s http://myip.enix.org/REMOTE_ADDR)
MY_IP_ADDR=$1
[ "$MY_IP_ADDR" ] || {
    echo "Sorry, I could not figure out my public IP address."
    echo "(I use http://myip.enix.org/REMOTE_ADDR/ for that purpose.)"
    exit 1
}

[ -f client.ovpn ] || cat >client.ovpn <<EOF
client
nobind
dev tun
#redirect-gateway def1

<key>
`cat key.pem`
</key>
<cert>
`cat cert.pem`
</cert>
<ca>
`cat cert.pem`
</ca>
<dh>
`cat dh.pem`
</dh>

<connection>
remote $MY_IP_ADDR 443 tcp-client
</connection>
EOF

[ -f client.http ] || cat >client.http <<EOF
HTTP/1.0 200 OK
Content-Type: application/x-openvpn-profile
Content-Length: `wc -c client.ovpn`

`cat client.ovpn`
EOF

# - Routing for expose weave DNS to VPN clients
to_remove=$( iptables -t nat -L PREROUTING \
	           | tail -n +3 | grep -n -E ".*" | grep -E ":53$" \
	           | sed -e 's/:.*//' | sort -n -r )

for num in $to_remove ; do
	iptables -t nat -D PREROUTING $num
done

ip=$( ip -f inet -o addr show docker0 | awk ' {print $4}' | sed -e 's/\/.*//' )
iptables -t nat -A PREROUTING -p udp -i tun443 --dport 53  -j DNAT --to-destination $ip:53
iptables -t nat -A PREROUTING -p tcp -i tun443 --dport 53  -j DNAT --to-destination $ip:53


