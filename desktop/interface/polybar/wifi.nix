{
  type = "internal/network";
  interface = "wlp7s0";
  interval  = 3600;

  format-connected    = "<label-connected>";
  label-connected     = "%essid%";
  format-disconnected = "<label-disconnected>";
  label-disconnected  = "%ifname% disconnected";
}
