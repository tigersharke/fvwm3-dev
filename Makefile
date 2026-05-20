PORTNAME=					fvwm3
DISTVERSION=				g20260518
CATEGORIES=					x11-wm
MASTER_SITES=				GH
PKGNAMESUFFIX=  			-dev
DISTNAME=					${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=				${PORTNAME}

MAINTAINER=					nope@nothere
COMMENT=        			F? Virtual Window Manager
WWW=						https://www.fvwm.org/

LICENSE=        			GPLv2

LIB_DEPENDS=				libfontconfig.so:x11-fonts/fontconfig \
			                libevent.so:devel/libevent

USES=						pkgconfig python xorg perl5 \
							meson compiler:c11 cpe localbase:ldflags \
							shebangfix

CPE_VENDOR=     			fvwm
CPE_PRODUCT=    			fvwm
USE_GITHUB=					yes
GH_ACCOUNT=					fvwmorg
GH_PROJECT=					fvwm3
GH_TAGNAME=					73f2c245b0a3a27cf7879887f92c0e63d8e2f6b5

USE_LDCONFIG=				yes
USE_XORG=       			ice sm x11 xext xft xrandr xrender xt xtrans xfixes

MESON_ARGS=					\
							-Dpython=${PYTHON_CMD} \
							--auto-features=disabled \
							--buildtype=minsize

CONFLICTS_INSTALL=			fvwm fvwm-2.* fvwm3

MESON_BUILD_DIR=			_build

# Removed XI option from both
OPTIONS_DEFINE=				FRIBIDI GOLANG MANPAGES NLS \
							PNG SVG XCURSOR XDG \
							XPM XSM
OPTIONS_DEFAULT=			MANPAGES PNG SVG \
							XCURSOR XDG XFTTEST XRENDER XSM
OPTIONS_SUB=				yes

#CAIRO_DESC=				Use Cairo as a librsvg backend
#FRIBIDI_DESC=
GOLANG_DESC=				Compilation of modules written in Go (FvwmPrompt) -broken here-
MANPAGES_DESC=				Generation of man pages (via mandoc)
#CAIROSVG_DESC=				Use CairoSVG as a librsvg backend
SHAREDMEM_DESC=				MIT Shared Memory Extension
SVG_DESC=					Scalable vector graphics (SVG images) support
XCURSOR_DESC=				Alpha-blend rendering via xrender
XDG_DESC=					Add py-pyxdg dependency for menu generator
XFTTEST_DESC=				Try to compile and run a test Xft program
XI_DESC=					X Input extension library support
#XRENDER_DESC=				Alpha-blend rendering
XSM_DESC=					X11 session management support
# MESON_ENABLED (port) vs MESON_ENABLE (mine)

FONTCONF_MESON_ENABLED=		fontconfigtest

FRIBIDI_LIB_DEPENDS=		libfribidi.so:converters/fribidi
FRIBIDI_MESON_ENABLED=		bidi

# Does this need something more for it to build the module FvwmPrompt properly?
# >> Needs another git repo drawn in I believe
GOLANG_USES=				go:no_targets
GOLANG_MESON_ENABLED=		golang

MANPAGES_BUILD_DEPENDS=		asciidoctor:textproc/rubygem-asciidoctor
MANPAGES_MESON_TRUE=		mandoc

NLS_USES=					gettext-runtime
NLS_MESON_ENABLED=			nls

PNG_LIB_DEPENDS=			libpng16.so:graphics/png
PNG_MESON_ENABLED=			png

#SVG_LIB_DEPENDS=			librsvg-2.so:graphics/librsvg2-rust
SVG_USES=					gnome
#SVG_USE=					gnome=cairo
#,glib20,gdkpixbufextra
SVG_MESON_ENABLED=  			cairo-svg

XCURSOR_USE=				XORG=xrender,xcursor
XCURSOR_MESON_ENABLED=		xrender xcursor xfixes

# py-xdg fails with python3.9 which is why python 3.7-3.8 was in Uses
XDG_RUN_DEPENDS=			${PYTHON_SITELIBDIR}/xdg/__init__.py:devel/py-pyxdg@${PY_FLAVOR}

#XI_USE=						xorg=xi xext
#XI_MESON_ENABLED=			xi

XPM_USE=					XORG=xpm
XPM_MESON_ENABLED=			xpm
#XPM_MESON_OFF=				xpm

#XRENDER_USE=				xorg=xrender
#XRENDER_MESON_ENABLE=		xrender

XSM_USE=					XORG=sm
XSM_MESON_ENABLED=			sm

.include <bsd.port.options.mk>

# This needs a better method if available.
#post-patch:
#	@${REINPLACE_CMD} -e 's,/etc/,${LOCALBASE}/etc/,g' \
#	${WRKSRC}/bin/fvwm-menu-desktop.in

# This detail has been annoying, why are some manpages all lowercase and some
# have an initial capital? Whether there was a purpose, the vast majority of
# man1 manpages are all lowercase. Cure this here. Also fix the recent change
# from /usr/local/man to /usr/local/share/man  It is a mistake to change all
# these manpages to lowercase only because fvwm scripts use those camelcased,
# instead, for convenience create symbolic links.

# This rename worked previously but now does not, redundant I suppose.
#	@${MV} ${STAGEDIR}${LOCALBASE}/man/man1/* \
#		${STAGEDIR}${LOCALBASE}/share/man/man1/
#.if ${PORT_OPTIONS:MNLS}

post-stage-NLS-on:
	@${MKDIR} ${STAGEDIR}${LOCALBASE}/share/fvwm3
	@${MV} ${STAGEDIR}${LOCALBASE}/share/locale/ \
	${STAGEDIR}${LOCALBASE}/share/fvwm3/

post-stage-MMANPAGES-on:
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmAnimate.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmanimate.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmAuto.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmauto.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmBacker.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmbacker.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmButtons.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmbuttons.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmCommand.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmcommand.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmEvent.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmevent.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmForm.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmform.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmIconMan.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmiconMan.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmIdent.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmident.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmMFL.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmmfl.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmPager.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmpager.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmPerl.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmperl.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmRearrange.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmrearrange.1
	@${LN} ${STAGEDIR}${LOCALBASE}/share/man/man1/FvwmScript.1 \
		${STAGEDIR}${LOCALBASE}/share/man/man1/fvwmscript.1

# --disable-perllib       disable installing fvwm perl library
# --infodir=DIR           info documentation [DATAROOTDIR/info]
# --mandir=DIR            man documentation [DATAROOTDIR/man]
# --docdir=DIR            documentation root [DATAROOTDIR/doc/fvwm3]
# --htmldir=DIR           html documentation [DOCDIR]
# --dvidir=DIR            dvi documentation [DOCDIR]
# --pdfdir=DIR            pdf documentation [DOCDIR]
# --psdir=DIR             ps documentation [DOCDIR]
# --enable-mandoc         enable generation of man pages

.include <bsd.port.mk>
