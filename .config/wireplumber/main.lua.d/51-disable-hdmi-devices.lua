rule = {
  matches = {
    {
      { "device.name", "equals", "alsa_card.usb-046d_Logitech_StreamCam_4FE49355-02" },
    }, {
      { "device.name", "equals", "alsa_card.pci-0000_08_00.1" },
    }
  },
  apply_properties = {
    ["device.disabled"] = true,
  },
}

table.insert(alsa_monitor.rules, rule)
