{
  type     = "custom/script";
  exec     = "docker ps -q | wc -l";
  interval = 600;
  label    = " %output%";
}
