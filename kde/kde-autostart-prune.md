mkdir -p ~/.config/autostart

for f in \
org.kde.discover.notifier.desktop \
org.kde.kalendarac.desktop \
org.freedesktop.problems.applet.desktop \
geoclue-demo-agent.desktop \
org.kde.kgpg.desktop \
org.kde.xwaylandvideobridge.desktop \
vboxclient.desktop \
vmware-user.desktop \
liveinst-setup.desktop \
sealertauto.desktop \
orca-autostart.desktop \
spice-vdagent.desktop \
baloo_file.desktop \
localsearch-3.desktop
do
  cp /etc/xdg/autostart/$f ~/.config/autostart/ 2>/dev/null
  echo "Hidden=true" >> ~/.config/autostart/$f
done
