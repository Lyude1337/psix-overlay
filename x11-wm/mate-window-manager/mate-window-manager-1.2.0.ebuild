# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
# Debug only changes CFLAGS
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="MATE default window manager"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3 startup-notification test xinerama"

# XXX: libgtop is automagic, hard-enabled instead
RDEPEND=" >=x11-libs/pango-1.2[X]
	>=dev-libs/glib-2.25.10:2
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	>=mate-base/mate-conf-1.2.1
	>=gnome-base/gsettings-desktop-schemas-3.3
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXcursor
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libSM
	x11-libs/libICE
	media-libs/libcanberra[gtk]
	gnome-base/libgtop
	>=mate-extra/mate-dialogs-1.2.0
	xinerama? ( x11-libs/libXinerama )
	!x11-misc/expocity"
DEPEND="${RDEPEND}
	>=app-text/mate-doc-utils-1.2.1
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/xproto"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-canberra
		--enable-compositor
		--enable-render
		--enable-shape
		--enable-sm
		--enable-xsync
		$(use_enable startup-notification)
		$(use_enable xinerama)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README *.txt doc/*.txt"
}
