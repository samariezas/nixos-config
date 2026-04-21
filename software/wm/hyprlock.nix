{
  general = {
    hide_cursor = false;
    grace = 0;
    ignore_empty_input = true;
    fractional_scaling = 0;
    no_fade_in = true;
  };
  background = {
    color = "rgba(25, 20, 20, 1.0)";
  };
  input-field = [
    {
      size = "200, 50";
      position = "0, -80";
      monitor = "";
      dots_center = true;
      fade_on_empty = false;
      font_color = "rgb(202, 211, 245)";
      inner_color = "rgb(91, 96, 120)";
      outer_color = "rgb(24, 25, 38)";
      outline_thickness = 5;
      placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
      shadow_passes = 2;
    }
  ];
  label = [
    {
      text = "$TIME";
      position = "0, 60";
      font_size = 46;
      color = "rgb(202, 211, 245)";
    }
    {
      text = "$USER";
      position = "0, -10";
      font_size = 16;
      color = "rgb(150, 160, 180)";
    }
    {
      text = "$LAYOUT";
      position = "-10, 10";
      font_size = 12;
      valign = "bottom";
      halign = "right";
      color = "rgb(150, 160, 180)";
    }
  ];
}
