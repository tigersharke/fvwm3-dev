PORTNAME=	fvwm3-dev
DISTVERSION=	g20210914
CATEGORIES=	x11-wm
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}

MAINTAINER=	nope@nothere
COMMENT=        F? Virtual Window Manager

LICENSE=        GPLv2

LIB_DEPENDS=    libbson-1.0.so:devel/libbson \
		libevent.so:devel/libevent

USES=           compiler:c11 cpe pkgconfig python:3.7+ readline xorg

USE_GITHUB=	nodefault
GH_ACCOUNT=	minetest
GH_PROJECT=	irrlicht
GH_TAGNAME=	594de9915346a87f67cd94e28c7933993efb5d3b

USE_GL=		gl glu
USE_XORG=       ice x11 xext xrandr xrender xt
USE_LDCONFIG=	yes

CONFLICTS_INSTALL=      fvwm-2.* fvwm3

CPE_VENDOR=     fvwm
CPE_PRODUCT=    fvwm

GNU_CONFIGURE=  yes
CONFIGURE_ARGS= ac_cv_path_PYTHON=${PYTHON_CMD} \
		--disable-golang

#WRKSRC=		${WRKDIR}/irrlicht-${GH_TAGNAME}

OPTIONS_DEFINE= FRIBIDI ICONS ICONV MANPAGES NLS PERL PNG SVG \
		XCURSOR XFT XPM XSM
OPTIONS_DEFAULT=FRIBIDI ICONV MANPAGES PERL PNG XCURSOR XFT XSM
OPTIONS_SUB=	yes

FRIBIDI_LIB_DEPENDS=	libfribidi.so:converters/fribidi
FRIBIDI_CONFIGURE_ENABLE=	bidi

FVWM_ICONS=	fvwm_icons-20070101
ICONS_DISTFILES=	${DISTNAME}${EXTRACT_SUFX} ${FVWM_ICONS}.tar.bz2:icons
ICONS_IMPLIES=	XPM

ICONV_USES=	iconv:translit
ICONV_CONFIGURE_ENABLE=	iconv

MANPAGES_BUILD_DEPENDS= rubygem-asciidoctor>0:textproc/rubygem-asciidoctor
MANPAGES_USES=	gmake
MANPAGES_CONFIGURE_ENABLE=	mandoc
MANPAGES_IMPLIES=	PERL

NLS_CONFIGURE_ENABLE=	nls
NLS_USES=	gettext-runtime

PERL_USES=	perl5
PERL_CONFIGURE_ENABLE=	perllib

PNG_LIB_DEPENDS=	libpng.so:graphics/png
PNG_CONFIGURE_ENABLE=	png

SVG_LIB_DEPENDS=	librsvg-2.so:graphics/librsvg2-rust
SVG_USES=	gnome
SVG_USE=	gnome=cairo,glib20,gdkpixbuf2
SVG_CONFIGURE_ENABLE=   rsvg

XCURSOR_USE=	xorg=xcursor
XCURSOR_CONFIGURE_ENABLE=	xcursor

XFT_LIB_DEPENDS=	libfreetype.so:print/freetype2 \
			libfontconfig.so:x11-fonts/fontconfig
XFT_USE=        xorg=xft
XFT_CONFIGURE_ENABLE=   xft

XPM_USE=        xorg=xpm
XPM_CONFIGURE_OFF=      --with-xpm-library=no

XSM_DESC=       X11 session management support
XSM_USE=        xorg=sm
XSM_CONFIGURE_ENABLE=   sm

post-patch:
	@${REINPLACE_CMD} -e 's,/etc/,${LOCALBASE}/etc/,g' \
	${WRKSRC}/bin/fvwm-menu-desktop.in

post-install-ICONS-on:
	${MKDIR} ${STAGEDIR}${PREFIX}/share/fvwm3/pixmaps
	${INSTALL_DATA} ${WRKDIR}/${FVWM_ICONS}/*.xpm \
	${STAGEDIR}${PREFIX}/share/fvwm3/pixmaps

post-install-PERL-off:
.for script in fvwm-convert-2.6 fvwm-menu-directory fvwm-menu-xlock fvwm-perllib
	${RM} ${STAGEDIR}${PREFIX}/bin/${script}
.endfor
.for script in FvwmConsoleC.pl FvwmPerl
	${RM} ${STAGEDIR}${PREFIX}/libexec/fvwm3/${PORTVERSION}/${script}
.endfor

.include <bsd.port.mk>
