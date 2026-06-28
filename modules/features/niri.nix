{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
    #services.displayManager.enable = lib.mkForce false;
    #services.xserver.displayManager.lightdm.enable = false;
  };

  perSystem = { pkgs, lib, self', ... }: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [ (lib.getExe pkgs.waybar) ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        window-rules = [
          {
            #geometry-corner-radius = 8;
            clip-to-geometry = true;
            draw-border-with-background = false;

            #focus-ring.off = true;

            border = {
              #off = "";
              width = 0;
              #active-color = "#ffffff30";
              #inactive-color = "#ffffff15";
            };
          }
          {
            matches = [{ app-id = "org.vinegarhq.Sober"; }];
            open-fullscreen = true;
          }
          {
            matches = [{ app-id = "Waydroid"; }];
            open-fullscreen = true;
          }
        ];

        outputs."eDP-1" = {
          mode = "2256x1504@59.999";
          scale = 1.5;
        };

        input = {
          keyboard = { xkb.layout = "fr"; };
          touchpad = {
            tap = null;
            natural-scroll = null;
          };
        };

        layout.gaps = 15;

        binds = {
          "Mod+Space".spawn-sh = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
          "Mod+Return".spawn-sh = "foot";
          "Mod+Q".close-window = null;

          "Mod+F".maximize-column = null;
          "Mod+G".fullscreen-window = null;
          "Mod+Shift+F".toggle-window-floating = null;
          "Mod+C".center-column = null;

          "Mod+H".focus-column-left = null;
          "Mod+L".focus-column-right = null;
          "Mod+K".focus-window-up = null;
          "Mod+J".focus-window-down = null;

          "Mod+Left".focus-column-left = null;
          "Mod+Right".focus-column-right = null;
          "Mod+Up".focus-window-up = null;
          "Mod+Down".focus-window-down = null;

          "Mod+Shift+H".move-column-left = null;
          "Mod+Shift+L".move-column-right = null;
          "Mod+Shift+K".move-window-up = null;
          "Mod+Shift+J".move-window-down = null;

          "Mod+Ampersand".focus-workspace = "w0";
          "Mod+Eacute".focus-workspace = "w1";
          "Mod+Quotedbl".focus-workspace = "w2";
          "Mod+Apostrophe".focus-workspace = "w3";
          "Mod+Parenleft".focus-workspace = "w4";
          "Mod+Minus".focus-workspace = "w5";
          "Mod+Egrave".focus-workspace = "w6";
          "Mod+Underscore".focus-workspace = "w7";
          "Mod+Ccedilla".focus-workspace = "w8";
          "Mod+Agrave".focus-workspace = "w9";

          "Mod+Shift+Ampersand".move-column-to-workspace = "w0";
          "Mod+Shift+Eacute".move-column-to-workspace = "w1";
          "Mod+Shift+Quotedbl".move-column-to-workspace = "w2";
          "Mod+Shift+Apostrophe".move-column-to-workspace = "w3";
          "Mod+Shift+Parenleft".move-column-to-workspace = "w4";
          "Mod+Shift+Minus".move-column-to-workspace = "w5";
          "Mod+Shift+Egrave".move-column-to-workspace = "w6";
          "Mod+Shift+Underscore".move-column-to-workspace = "w7";
          "Mod+Shift+Ccedilla".move-column-to-workspace = "w8";
          "Mod+Shift+Agrave".move-column-to-workspace = "w9";

          #"Mod+V".spawn-sh = ''${config.pkgs.alsa-utils}/bin/amixer sset Capture toggle'';

          "XF86AudioRaiseVolume".spawn-sh =
            "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh =
            "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

          "Mod+Ctrl+H".set-column-width = "-5%";
          "Mod+Ctrl+L".set-column-width = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";

          "Mod+WheelScrollDown".focus-column-left = null;
          "Mod+WheelScrollUp".focus-column-right = null;
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down = null;
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up = null;

          #"Mod+Ctrl+S".spawn-sh = ''${lib.getExe config.pkgs.grim} -l 0 - | ${config.pkgs.wl-clipboard}/bin/wl-copy'';

          #"Mod+Shift+E".spawn-sh = ''${config.pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe config.pkgs.swappy} -f -'';

          "Mod+Shift+S".spawn-sh = "dms screenshot";
          #  name = "screenshot";
          #  text = ''
          #    ${lib.getExe config.pkgs.grim} -g "$(${lib.getExe config.pkgs.slurp} -w 0)" - \
          #    | ${config.pkgs.wl-clipboard}/bin/wl-copy
          #  '';
          #});
        };

        workspaces = let settings = { layout.gaps = 5; };
        in {
          "w0" = settings;
          "w1" = settings;
          "w2" = settings;
          "w3" = settings;
          "w4" = settings;
          "w5" = settings;
          "w6" = settings;
          "w7" = settings;
          "w8" = settings;
          "w9" = settings;
        };
      };
    };
  };
}
