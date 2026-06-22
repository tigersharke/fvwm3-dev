################################################################################
PORTNAME=					fvwm3
DISTVERSION=				g20260528
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
GH_TAGNAME=					20c5d6d3f3f44769705ebe2844c1f2a62a3bd769

USE_LDCONFIG=				yes
USE_XORG=       			ice x11 xext xft xrandr

MESON_ARGS=					-Dpython=${PYTHON_CMD} \
							--auto-features=disabled \
							--buildtype=minsize
MESON_BUILD_DIR=			_build
#meson setup: error: The argument for option '-D' must be in OPTION=VALUE format.
CONFLICTS_INSTALL=			fvwm fvwm-2.* fvwm3

# DEVELOPER="YES" has schizophrenic suggestions:
#
# With no libevent.so:devel/libevent it tells me:
#   Warning: you need LIB_DEPENDS+=libevent-2.1.so:devel/libevent
#
# Or, if libevent.so:devel/libevent is added since libevent-2.1.so isn't found:
#   Warning: you might not need LIB_DEPENDS on libevent.so
################################################################################
OPTIONS_DEFINE=				CAIRO CAIROSVG FREETYPE FRIBIDI GOLANG ICONV \
							LIBSVG MANPAGES NLS PNG SVG SYSTRAY XCURSOR XDG \
							XFIXES XPM XRENDER XSM
OPTIONS_DEFAULT=			MANPAGES PNG SVG XCURSOR XDG XFTTEST XRENDER XSM
OPTIONS_SUB=				yes

CAIROSVG_DESC=				Use CairoSVG as a librsvg backend (cairo-svg)
CAIRO_DESC=					Use Cairo as a librsvg backend (cairo)
FREETYPE_DESC=				Enable freetype support (freetype)
FRIBIDI_DESC=				Enable fribidi support (bidi)
GOLANG_DESC=				Build Golang modules: FvwmPrompt (golang)
ICONV_DESC=					Enable iconv support (iconv)
LIBSVG_DESC=				Use librsvg as a librsvg backend (librsvg-cairo)
MANPAGES_DESC=				Enable generation of man pages via mandoc (mandoc)
NLS_DESC=					Enable NLS (nls)
PNG_DESC=					Enable png support (png)
SVG_DESC=					Enable SVG support (svg)
SYSTRAY_DESC=				Add support for system tray via stalonetray
XCURSOR_DESC=				Enable Xcursor support (xcursor)
XDG_DESC=					Add py-pyxdg dependency for menu generator
XFIXES_DESC=				Enable XFixes support (xfixes)
XPM_DESC=					Enable X PixMap support (xpm)
XRENDER_DESC=				Enable XRender support (xrender)
XSM_DESC=					Enable session management support (sm)

#
################################################################################
#  GOLANG option seems to need x11-wm/fvwm3-dev to be accessible to git

CAIROSVG_LIB_DEPENDS=		libcairo.so:graphics/cairo
CAIROSVG_MESON_ENABLED=		cairo-svg

CAIRO_LIB_DEPENDS+=			libcairo.so:graphics/cairo
CAIRO_MESON_ENABLED=		cairo

FREETYPE_LIB_DEPENDS=		libXft.so:x11-fonts/libXft
FREETYPE_MESON_ENABLED=		freetype

FRIBIDI_LIB_DEPENDS=		libfribidi.so:converters/fribidi
FRIBIDI_MESON_ENABLED=		bidi

GOLANG_USES=				go:no_targets
GOLANG_MESON_ENABLED=		golang

ICONV_RUN_DEPENDS=			${LOCALBASE}/lib/libiconv.so:converters/libiconv
ICONV_MESON_ENABLED=		iconv

LIBSVG_USE=					GNOME=librsvg2
LIBSVG_MESON_ENABLED=		libsvg-cairo

MANPAGES_BUILD_DEPENDS=		asciidoctor:textproc/rubygem-asciidoctor
MANPAGES_MESON_TRUE=		mandoc

NLS_USES=					gettext-runtime
NLS_MESON_ENABLED=			nls

PNG_LIB_DEPENDS=			libpng16.so:graphics/png
PNG_MESON_ENABLED=			png

SVG_USES=					gnome
SVG_MESON_ENABLED=  		cairo-svg

SYSTRAY_RUN_DEPENDS=		stalonetray:x11/stalonetray

XCURSOR_USE=				XORG=xcursor
XCURSOR_MESON_ENABLED=		xcursor

# py-xdg fails with python3.9 which is why python 3.7-3.8 was in Uses
XDG_RUN_DEPENDS=			${PYTHON_SITELIBDIR}/xdg/__init__.py:devel/py-pyxdg@${PY_FLAVOR}

XFIXES_USE=					XORG=xfixes
XFIXES_MESON_ENABLED=		xfixes

XPM_USE=					XORG=xpm
XPM_MESON_ENABLED=			xpm

XRENDER_USE=				XORG=xrender
XRENDER_MESON_ENABLED=		xrender

XSM_USE=					XORG=sm
XSM_MESON_ENABLED=			sm

.include <bsd.port.options.mk>

################################################################################

post-stage-NLS-on:
	@${MKDIR} ${STAGEDIR}${LOCALBASE}/share/fvwm3
	@${MV} ${STAGEDIR}${LOCALBASE}/share/locale/ \
	${STAGEDIR}${LOCALBASE}/share/fvwm3/

.include <bsd.port.mk>
