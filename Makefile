PORTNAME=					fvwm3
DISTVERSION=				g20251031
CATEGORIES=					x11-wm
MASTER_SITES=				GH
PKGNAMESUFFIX=  			-dev
DISTNAME=					${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=				${PORTNAME}

MAINTAINER=					nope@nothere
COMMENT=        			F? Virtual Window Manager
WWW=						https://www.fvwm.org/

LICENSE=        			GPLv2

LIB_DEPENDS=				libevent.so:devel/libevent \
							libfreetype.so:print/freetype2 \
							libfontconfig.so:x11-fonts/fontconfig

USES=						meson compiler:c11 cpe \
							pkgconfig python xorg gl readline \
							localbase:ldflags

CPE_VENDOR=     			fvwm
CPE_PRODUCT=    			fvwm
USE_GITHUB=					nodefault
GH_ACCOUNT=					fvwmorg
GH_PROJECT=					fvwm3
GH_TAGNAME=					6a9b86f20bcc9f36a3e52273ed79b23fc8177528

USE_GL=						gl glu
USE_LDCONFIG=				yes
USE_XORG=       			ice x11 xext xrandr xt xft xtrans

#MESON_ARGS= 				--buildtype debug
MESON_ARGS=					--auto-features=disabled

CONFLICTS_INSTALL=			fvwm fvwm-2.* fvwm3

WRKSRC=						${WRKDIR}/fvwm3-${GH_TAGNAME}
MESON_BUILD_DIR=			_build

OPTIONS_DEFINE=				FONTCONF FRIBIDI GOLANG ICONV MANPAGES NLS \
							PERL PNG SHAPED SHAREDMEM SVG XRENDER XCURSOR XDG \
							XFTTEST XI XPM XSM
OPTIONS_DEFAULT=			FONTCONF ICONV MANPAGES PNG SHAPED SHAREDMEM SVG \
							XCURSOR XDG XFTTEST XI XRENDER XSM
OPTIONS_SUB=				yes

FONTCONF_DESC=				Try to compile and run a test fontconfig program
#FRIBIDI_DESC=
GOLANG_DESC=				Compilation of modules written in Go (FvwmPrompt)
MANPAGES_DESC=				Generation of man pages (via mandoc)
SHAPED_DESC=				shaped window support
SHAREDMEM_DESC=				MIT Shared Memory Extension
SVG_DESC=					Scalable vector graphics (SVG images) support
XCURSOR_DESC=				Alpha-blend rendering via xrender
XDG_DESC=					Add py-xdg dependency for menu generator
XFTTEST_DESC=				Try to compile and run a test Xft program
XI_DESC=					X Input extension library support
XRENDER_DESC=				Alpha-blend rendering
XSM_DESC=					X11 session management support

FONTCONF_MESON_ENABLE=		fontconfigtest

FRIBIDI_LIB_DEPENDS=		libfribidi.so:converters/fribidi
FRIBIDI_MESON_ENABLE=		bidi

# Does this need something more for it to build the module FvwmPrompt properly?
GOLANG_USES=				go:no_targets
GOLANG_MESON_ENABLE=		golang

ICONV_USES=					iconv
ICONV_MESON_ENABLE=			iconv

MANPAGES_BUILD_DEPENDS=		asciidoctor:textproc/rubygem-asciidoctor
MANPAGES_MESON_TRUE=		mandoc

NLS_USES=					gettext-runtime
NLS_MESON_ENABLE=			nls

PERL_USES=					perl5
PERL_MESON_ENABLE=			perllib

PNG_LIB_DEPENDS=			libpng.so:graphics/png
PNG_MESON_ENABLE=			png

#SHAPED_DEPENDS=			#
SHAPED_MESON_ENABLE=		shape

SHAREDMEM_MESON_ENABLE=		shm

SVG_LIB_DEPENDS=			librsvg-2.so:graphics/librsvg2-rust
SVG_USES=					gnome
SVG_USE=					gnome=cairo,glib20,gdkpixbufextra
SVG_MESON_ENABLE=  			cairo-svg

XCURSOR_USE=				xorg=xrender,xcursor
XCURSOR_MESON_ENABLE=		xrender

# py-xdg fails with python3.9 which is why python 3.7-3.8 was in Uses
XDG_RUN_DEPENDS=			${PYTHON_SITELIBDIR}/xdg/__init__.py:devel/py-xdg@${PY_FLAVOR}

XFTTEST_MESON_ENABLE=		xfttest

XI_USE=						xorg=xi xext
XI_MESON_ENABLE=			xi

XPM_USE=					xorg=xpm
#XPM_MESON_OFF=				xpm

XRENDER_USE=				xorg=xrender
XRENDER_MESON_ENABLE=		xrender

XSM_USE=					xorg=sm
XSM_MESON_ENABLE=			sm

.include <bsd.port.options.mk>

# Is this needed?
#
# package fvwm3: no Go files in
# /usr/home/tigersharke/Ported_Software/x11-wm/fvwm3-dev/work/src/fvwm3
# go/x11-wm_fvwm3-dev/fvwm3-4f1dced4820c670fb3a8f2c4a836159be97f8e0b/
#	g20220919.mod
#.if ${PORT_OPTIONS:MGOLANG}
#	GO_MODULE golang.org/x/tools
#	GO_MODULE github.com/fvwmorg/FvwmPrompt
#	GO_TARGET ${WRKSRC}/bin/FvwmPrompt/go.mod
#.endif

# This needs a better method if available.
#post-patch:
#	@${REINPLACE_CMD} -e 's,/etc/,${LOCALBASE}/etc/,g' \
#	${WRKSRC}/bin/fvwm-menu-desktop.in

post-install-PERL-off:
.for script in fvwm-convert-2.6 fvwm-menu-directory fvwm-menu-xlock fvwm-perllib
	${RM} ${STAGEDIR}${PREFIX}/bin/${script}
.endfor
.for script in FvwmConsoleC.pl FvwmPerl
	${RM} ${STAGEDIR}${PREFIX}/libexec/fvwm3/${PORTVERSION}/${script}
.endfor

# This detail has been annoying, why are some manpages all lowercase and some
# have an initial capital? Whether there was a purpose, the vast majority of
# man1 manpages are all lowercase. Cure this here. Also fix the recent change
# from /usr/local/man to /usr/local/share/man  It is a mistake to change all
# these manpages to lowercase only because fvwm scripts use those camelcased,
# instead, for convenience create symbolic links.

# This rename worked previously but now does not, redundant I suppose.
#	@${MV} ${STAGEDIR}${LOCALBASE}/man/man1/* \
#		${STAGEDIR}${LOCALBASE}/share/man/man1/
post-stage:
.if ${PORT_OPTIONS:MMANPAGES}
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
.endif

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
