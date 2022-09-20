PORTNAME=	fvwm3
DISTVERSION=	g20220919
CATEGORIES=	x11-wm
PKGNAMESUFFIX=  -dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}

MAINTAINER=	nope@nothere
COMMENT=        F? Virtual Window Manager

LICENSE=        GPLv2

LIB_DEPENDS=    libbson-1.0.so:devel/libbson \
		libevent.so:devel/libevent \
		libfreetype.so:print/freetype2 \
		libfontconfig.so:x11-fonts/fontconfig

USES=		autoreconf compiler:c11 cpe pkgconfig python:3.7+ readline xorg gl

USE_GITHUB=	nodefault
GH_ACCOUNT=	fvwmorg
GH_PROJECT=	fvwm3
GH_TAGNAME=	4f1dced4820c670fb3a8f2c4a836159be97f8e0b

USE_GL=		gl glu
USE_XORG=       ice x11 xext xrandr xt xft
USE_LDCONFIG=	yes

CONFLICTS_INSTALL=      fvwm-2.* fvwm3

CPE_VENDOR=     fvwm
CPE_PRODUCT=    fvwm

GNU_CONFIGURE=  yes
CONFIGURE_ARGS= ac_cv_path_PYTHON=${PYTHON_CMD} \
		--disable-golang

WRKSRC=		${WRKDIR}/fvwm3-${GH_TAGNAME}

OPTIONS_DEFINE=			FRIBIDI ICONV MANPAGES NCURSES NLS PERL PNG SHAPED \
				SHARUTILS SVG XRENDER XCURSOR XI XPM XSM #GOLANG
OPTIONS_DEFAULT=		ICONV MANPAGES PNG SHAPED XCURSOR XRENDER XSM
OPTIONS_SUB=			yes

OPTIONS_RADIO=          	CLI
OPTIONS_RADIO_CLI=      	LIBEDIT READLINE

FRIBIDI_LIB_DEPENDS=		libfribidi.so:converters/fribidi
FRIBIDI_CONFIGURE_ENABLE=	bidi

# This may take a little more to do properly.
#GOLANG_DESC=			enable compilation of modules written in Go (FvwmPrompt)
#GOLANG_USES=			go:modules
#GOLANG_USES=			go
#GOLANG_CONFIGURE_ENABLE=	golang

ICONV_USES=			iconv:translit
ICONV_CONFIGURE_ENABLE=		iconv

LIBEDIT_USES=                   libedit
LIBEDIT_CONFIGURE_ENABLE=       libedit

READLINE_USES=                  readline
READLINE_CONFIGURE_ENABLE=      libreadline

MANPAGES_BUILD_DEPENDS=		rubygem-asciidoctor>0:textproc/rubygem-asciidoctor
MANPAGES_USES=			gmake
MANPAGES_CONFIGURE_ENABLE=	mandoc
MANPAGES_IMPLIES=		PERL

NCURSES_USES=                   ncurses
NCURSES_CONFIGURE_ENV=          NCURSES_CFLAGS="-I${NCURSESINC}" \
                                NCURSES_LIBS="-L${NCURSESLIB} -lncursesw"
NCURSES_CONFIGURE_ENABLE=       ncurses

NLS_CONFIGURE_ENABLE=		nls
NLS_USES=			gettext-runtime

PERL_USES=			perl5
PERL_CONFIGURE_ENABLE=		perllib

PNG_LIB_DEPENDS=		libpng.so:graphics/png
PNG_CONFIGURE_ENABLE=		png

SHARUTILS_DESC=			Shell Archive Utils support
SHARUTILS_DEPENDS=		gunshar:archivers/sharutils
SHARUTILS_ENABLE=		sharutils

SHAPED_DESC=			Shaped window support
SHAPED_DEPENDS=			gunshar:archivers/sharutils
SHAPED_ENABLE=			sharutils

SVG_LIB_DEPENDS=		librsvg-2.so:graphics/librsvg2-rust
SVG_USES=			gnome
SVG_USE=			gnome=cairo,glib20,gdkpixbuf2
SVG_CONFIGURE_ENABLE=  		rsvg

XRENDER_DESC=			Alpha-blend rendering
XCURSOR_USE=			xorg=xrender
XCURSOR_CONFIGURE_ENABLE=	xrender

XRENDER_DESC=			Alpha-blend rendering via xrender
XRENDER_USE=			xorg=xrender
XRENDER_CONFIGURE_ENABLE=	xrender

XI_DESC=			X Input extension library support
XI_USE=				xorg=xi xext
XSM_CONFIGURE_ENABLE=		xi

XPM_USE=			xorg=xpm
XPM_CONFIGURE_OFF=		--with-xpm-library=no

XSM_DESC=			X11 session management support
XSM_USE=			xorg=sm
XSM_CONFIGURE_ENABLE=		sm

.include <bsd.port.options.mk>

# Is this needed?
# 
# package fvwm3: no Go files in /usr/home/tigersharke/Ported_Software/x11-wm/fvwm3-dev/work/src/fvwm3
# go/x11-wm_fvwm3-dev/fvwm3-4f1dced4820c670fb3a8f2c4a836159be97f8e0b/g20220919.mod
#.if ${PORT_OPTIONS:MGOLANG}
#GO_MODULE=      golang.org/x/tools
#GO_MODULE=	github.com/fvwmorg/FvwmPrompt
#GO_TARGET=      ${WRKSRC}/bin/FvwmPrompt/go.mod
#.endif


post-patch:
	@${REINPLACE_CMD} -e 's,/etc/,${LOCALBASE}/etc/,g' \
	${WRKSRC}/bin/fvwm-menu-desktop.in

post-install-PERL-off:
.for script in fvwm-convert-2.6 fvwm-menu-directory fvwm-menu-xlock fvwm-perllib
	${RM} ${STAGEDIR}${PREFIX}/bin/${script}
.endfor
.for script in FvwmConsoleC.pl FvwmPerl
	${RM} ${STAGEDIR}${PREFIX}/libexec/fvwm3/${PORTVERSION}/${script}
.endfor

.include <bsd.port.mk>
