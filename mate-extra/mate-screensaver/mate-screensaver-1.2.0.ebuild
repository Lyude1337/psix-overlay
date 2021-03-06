# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"

inherit eutils mate multilib

DESCRIPTION="Replaces xscreensaver, integrating with the MATE desktop."
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
KERNEL_IUSE="kernel_linux"
IUSE="doc libnotify opengl pam $KERNEL_IUSE"

RDEPEND=">=mate-base/mate-conf-1.2.1
	>=x11-libs/gtk+-2.14.0:2
	>=mate-base/mate-desktop-1.2.0
	>=mate-base/mate-menus-1.2.0
	>=dev-libs/glib-2.15:2
	>=mate-base/libmatekbd-1.2.0
	>=dev-libs/dbus-glib-0.71
	libnotify? ( >=x11-libs/libmatenotify-1.2.0 )
	opengl? ( virtual/opengl )
	pam? ( virtual/pam )
	!pam? ( kernel_linux? ( sys-apps/shadow ) )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	doc? (
		app-text/xmlto
		~app-text/docbook-xml-dtd-4.1.2
		~app-text/docbook-xml-dtd-4.4 )
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto
	>=mate-base/mate-common-1.2.2"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable doc docbook-docs)
		$(use_enable debug)
		$(use_with libnotify libmatenotify)
		$(use_with opengl gl)
		$(use_enable pam)
		--enable-locking
		--with-xf86gamma-ext
		--with-kbd-layout-indicator
		--with-xscreensaverdir=/usr/share/xscreensaver/config
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver"

	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	# Prevent multiple screensaver instances due to race conditions
	epatch "${FILESDIR}/${P}-prevent-multiple-instances.patch"
	# Fix QA warnings due to missing includes in popsquares
	epatch "${FILESDIR}/${P}-fix-popsquares-includes.patch"
	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in \
		|| die "sed failed"

	mate_src_prepare
}

src_install() {
	mate_src_install

	# Install the conversion script in the documentation
	dodoc "${S}/data/migrate-xscreensaver-config.sh"
	dodoc "${S}/data/xscreensaver-config.xsl"

	# Non PAM users will need this suid to read the password hashes.
	# OpenPAM users will probably need this too when
	# http://bugzilla.gnome.org/show_bug.cgi?id=370847
	# is fixed.
	if ! use pam ; then
		fperms u+s /usr/libexec/gnome-screensaver-dialog
	fi
}

pkg_postinst() {
	mate_pkg_postinst

	if has_version "<x11-base/xorg-server-1.5.3-r4" ; then
		ewarn "You have a too old xorg-server installation. This will cause"
		ewarn "gnome-screensaver to eat up your CPU. Please consider upgrading."
		echo
	fi

	if has_version "<x11-misc/xscreensaver-4.22-r2" ; then
		ewarn "You have xscreensaver installed, you probably want to disable it."
		ewarn "To prevent a duplicate screensaver entry in the menu, you need to"
		ewarn "build xscreensaver with -gnome in the USE flags."
		ewarn "echo \"x11-misc/xscreensaver -gnome\" >> /etc/portage/package.use"
		echo
	fi

	elog "Information for converting screensavers is located in "
	elog "/usr/share/doc/${PF}/xss-conversion.txt.${PORTAGE_COMPRESS}"
}
