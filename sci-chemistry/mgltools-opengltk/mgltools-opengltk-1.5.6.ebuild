# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 eutils prefix

MY_PN="opengltk"
MY_P="${MY_PN}-${PV/_rc3/}"

PYTHON_MODNAME="${MY_PN}"

DESCRIPTION="MGLTools Plugin -- opengltk"
HOMEPAGE="http://mgltools.scripps.edu"
SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/tk
	dev-python/numpy
	dev-tcltk/tkdnd
	dev-tcltk/togl
	media-libs/glew
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV/_/}/MGLPACKS/${MY_P}.tar.gz
}

python_prepare_all() {
	local tcl_ver="$(best_version dev-lang/tcl | cut -d- -f3 | cut -d. -f1,2)"

	local PATCHES=( "${FILESDIR}"/${PN}-1.5.6_rc2-unbundle.patch )

	eprefixify setup.py

	ecvs_clean
	find "${S}" -name LICENSE -type f -delete || die
	find Togl2.0 tkdnd2.0 include/tcltk84 -delete || die

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in || die

	sed \
		-e "s:8.4:${tcl_ver}:g" \
		-e "s:8.5:${tcl_ver}:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
