# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.11"
AT_M4DIR=./config  # for aclocal called by eautoreconf
inherit git linux-info eutils autotools

DESCRIPTION="Solaris Porting Layer - a Linux kernel module providing some Solaris kernel APIs"
HOMEPAGE="http://wiki.github.com/behlendorf/spl/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/behlendorf/spl.git"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
		>=virtual/linux-sources-2.6.32
		"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.0-includedir.patch
	eautoreconf
}

src_configure() {
	set_arch_to_kernel
	econf \
		--prefix="${EPREFIX}" \
		--with-config=all \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-obj="${KERNEL_DIR}"
}

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
}