# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"

inherit mate

DESCRIPTION="Applets for the MATE Desktop and Panel"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+gstreamer ipv6 networkmanager policykit"

RDEPEND=">=x11-libs/gtk+-2.20:2
	>=dev-libs/glib-2.22:2
	>=mate-base/mate-conf-1.4.0
	>=mate-base/mate-panel-1.4.0
	>=x11-libs/libxklavier-4.0
	>=x11-libs/libwnck-2.9.3:1
	>=mate-base/mate-desktop-1.4.0
	>=x11-libs/libmatenotify-1.4.0
	>=sys-apps/dbus-1.1.2
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/libxml2-2.5.0:2
	>=x11-themes/mate-icon-theme-1.4.0
	dev-libs/libmateweather
	x11-libs/libX11
	>=mate-base/mate-settings-daemon-1.4.0
	mate-base/libmate
	gnome-base/libgtop:2
	sys-power/cpufrequtils
	>=gnome-extra/gucharmap-2.23:0
	gstreamer?	(
		>=media-libs/gstreamer-0.10.2:0.10
		>=media-libs/gst-plugins-base-0.10.14:0.10
		|| (
			>=media-plugins/gst-plugins-alsa-0.10.14:0.10
			>=media-plugins/gst-plugins-oss-0.10.14:0.10 ) )
	networkmanager? ( >=net-misc/networkmanager-0.7.0 )
	policykit? ( >=sys-auth/polkit-0.92 )"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.1.4
	>=app-text/mate-doc-utils-1.4.0
	virtual/pkgconfig
	dev-util/gtk-doc
	>=dev-util/intltool-0.35
	dev-libs/libxslt
	~app-text/docbook-xml-dtd-4.3
	>=mate-base/mate-common-1.4.0"

pkg_setup() {
	G2CONF="${G2CONF}
		--libexecdir=/usr/libexec/mate-applets
		--without-hal
		$(use_enable gstreamer mixer-applet)
		$(use_enable ipv6)
		$(use_enable networkmanager)
		$(use_enable policykit polkit)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed"
}

src_install() {
	mate_src_install

	local APPLETS="accessx-status battstat charpick cpufreq drivemount geyes
			invest-applet mateweather mini-commander mixer
			modemlights multiload null_applet stickynotes trashapplet"

	for applet in ${APPLETS}; do
		docinto ${applet}

		for d in AUTHORS ChangeLog NEWS README README.themes TODO; do
			[ -s ${applet}/${d} ] && dodoc ${applet}/${d}
		done
	done
}
