{
  type               = "internal/battery";
  poll-interval      = 60;
  battery            = "BAT0";
  format-charging    = "<animation-charging>   <label-charging>";
  format-discharging = "<ramp-capacity>   <label-discharging>";
  label-charging     = "Charging %percentage%%";
  label-discharging  = "Discharging %percentage%%";
  label-full         = "Fully charged";
  label-low          = "BATTERY LOW";
  bar-capacity-width = 50;

  ramp-capacity-0 = "";
  ramp-capacity-1 = "";
  ramp-capacity-2 = "";
  ramp-capacity-3 = "";
  ramp-capacity-4 = "";

  animation-charging-0 = "";
  animation-charging-1 = "";
  animation-charging-2 = "";
  animation-charging-3 = "";
  animation-charging-4 = "";
  animation-charging-framerate = 750;

  animation-discharging-0 = "";
  animation-discharging-1 = "";
  animation-discharging-2 = "";
  animation-discharging-3 = "";
  animation-discharging-4 = ";";
  animation-discharging-framerate = 500;

  animation-low-0 = "!";
  animation-low-1 = "";
  animation-low-framerate = 200;
}
