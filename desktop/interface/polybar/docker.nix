{
  type     = "custom/script";
  exec     = "docker images -q | wc -l";
  interval = 600;
  label    = " %output%";
}
