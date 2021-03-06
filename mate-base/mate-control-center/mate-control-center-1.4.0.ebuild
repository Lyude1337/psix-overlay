# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"

inherit mate

DESCRIPTION="The MATE Desktop configuration tool"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="eds gtk3"

# TODO: appindicator
# libgnomekbd-2.91 breaks API/ABI
RDEPEND="x11-libs/libXft
	>=x11-libs/libXi-1.2
	>=x11-libs/gtk+-2.20:2
	>=dev-libs/glib-2.28:2
	>=mate-base/mate-conf-1.4.0
	>=gnome-base/librsvg-2.0:2
	>=mate-base/mate-file-manager-1.4.0
	>=media-libs/fontconfig-1
	>=dev-libs/dbus-glib-0.73
	>=x11-libs/libxklavier-4.0
	>=x11-wm/mate-window-manager-1.4.0
	>=mate-base/libmatekbd-1.4.0
	>=mate-base/mate-desktop-1.4.0
	>=mate-base/mate-menus-1.4.0
	>=mate-base/mate-settings-daemon-1.4.0

	dev-libs/libunique:1
	x11-libs/pango
	dev-libs/libxml2
	media-libs/freetype
	media-libs/libcanberra[gtk]

	eds? ( >=gnome-extra/evolution-data-server-1.7.90 )

	x11-apps/xmodmap
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXxf86misc
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXcursor"

DEPEND="${RDEPEND}
	x11-proto/scrnsaverproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto
	x11-proto/randrproto
	x11-proto/renderproto

	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	dev-util/desktop-file-utils

	app-text/scrollkeeper
	>=app-text/mate-doc-utils-1.4.0
	>=mate-base/mate-common-1.4.0"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-update-mimedb
		--disable-appindicator
		$(use_enable eds aboutme)"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
}
