
#!/usr/bin/env bash

get_headphones_index () {
  echo $(pacmd list-cards | grep bluez_card -B1 | grep index | awk '{print $2}')
}

get_headphones_mac_address () {
  local temp=$(pacmd list-cards | grep bluez_card -C20 | grep 'device.string' | cut -d' ' -f 3)
  temp="${temp%\"}"
  temp="${temp#\"}"
  echo "${temp}"
}

_control_bluethoot_headphones () {
  local op=${1}
  local hp_mac=${2}
  echo -e "${op} ${hp_mac}\n quit" | bluetoothctl
}

disconnect_bluetooth_headphones () {
  local hp_mac=${1}
  _control_bluethoot_headphones "disconnect" ${hp_mac}
}

connect_bluetooth_headphones () {
  local hp_mac=${1}
  _control_bluethoot_headphones "connect" ${hp_mac}
}

_set_headphones_profile () {
  local profile=${1}
  pacmd set-card-profile $(get_headphones_index) ${profile}
}

set_headphones_profile_a2dp_sink () {
  _set_headphones_profile "a2dp_sink"
  echo "Bluethoot headphones a2dp_sink"
}

set_headphones_profile_off () {
  _set_headphones_profile "off"
  echo "Bluethoot headphones profile off"
}

main () {
  local hp_mac=$(get_headphones_mac_address)
  set_headphones_profile_off
  sleep 2s
  disconnect_bluetooth_headphones ${hp_mac}
  sleep 6s
  connect_bluetooth_headphones ${hp_mac}
  sleep 3s
  set_headphones_profile_a2dp_sink
}

main
