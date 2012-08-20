# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="A session daemon for MATE that makes it easy to manage your laptop or desktop system"
HOMEPAGE="http://mate-desktop.org"
# SRC_URI="${SRC_URI} http://dev.gentoo.org/~pacho/gnome/${PN}-2.32.0-keyboard-backlight.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+applet doc policykit test"

# FIXME: Interactive testsuite (upstream ? I'm so...pessimistic)
RESTRICT="test"

COMMON_DEPEND=">=dev-libs/glib-2.13.0:2
	>=x11-libs/gtk+-2.17.7:2
	mate-base/mate-keyring
	>=dev-libs/dbus-glib-0.71
	>=x11-libs/libmatenotify-1.4.0
	>=x11-libs/libwnck-2.10.0:1
	>=x11-libs/cairo-1
	mate-base/mate-conf[policykit?]
	>=media-libs/libcanberra-0.10[gtk]
	>=sys-power/upower-0.9.1
	>=dev-libs/libunique-1.1:1
	>=x11-apps/xrandr-1.3
	>=x11-proto/xproto-7.0.15
	x11-libs/libX11
	x11-libs/libXext
	applet? ( mate-base/mate-panel )"

RDEPEND="${COMMON_DEPEND}
	>=sys-auth/consolekit-0.4[policykit?]
	policykit? ( mate-extra/mate-polkit )"

DEPEND="${COMMON_DEPEND}
	x11-proto/randrproto

	sys-devel/gettext
	app-text/scrollkeeper
	app-text/docbook-xml-dtd:4.3
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	app-text/mate-doc-utils
	doc? (
		app-text/xmlto
		app-text/docbook-sgml-utils
		app-text/docbook-xml-dtd:4.4
		app-text/docbook-sgml-dtd:4.1
		app-text/docbook-xml-dtd:4.1.2 )"

# docbook-sgml-utils and docbook-sgml-dtd-4.1 used for creating man pages
# (files under ${S}/man).
# docbook-xml-dtd-4.4 and -4.1.2 are used by the xml files under ${S}/docs.

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-unique
		$(use_enable applet applets)
		$(use_enable doc docbook-docs)
		$(use_enable policykit mateconf-defaults)
		$(use_enable test tests)
		--enable-compile-warnings=minimum"
	DOCS="AUTHORS HACKING NEWS README TODO"
}

src_prepare() {
	mate_src_prepare

	# This needs to be after eautoreconf to prevent problems like bug #356277
	if ! use doc; then
		# Remove the docbook2man rules here since it's not handled by a proper
		# parameter in configure.in.
		sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' -i man/Makefile.in \
			|| die "docbook sed failed"
	fi
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-launch Xemake check || die "Test phase failed"
}
