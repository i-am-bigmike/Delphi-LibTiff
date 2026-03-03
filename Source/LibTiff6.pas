unit LibTiff6;

{
  LibTiff6 Wrapper for Delphi - Version 1.0.0 - 2026.03.01
  Updated and maintained by bigmike & Gemini (Google AI)

  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
  If a copy of the MPL was not distributed with this file, You can obtain one at
  http://mozilla.org/MPL/2.0/.

  Based on:
    * Vampyre Imaging Library (v0.26.4 - 2009.10.11)
      http://imaginglib.sourceforge.net

    * LibTiffDelphi (v3.9.4.00)
      Originally implemented by Do-wan Kim
}

{$ALIGN 8}
{$MINENUMSIZE 1}

interface

uses
  Windows, SysUtils, Classes;

const
{$IFDEF WIN32}
  libtiff6dll = 'libtiff-6.dll';
{$ENDIF}
{$IFDEF WIN64}
  libtiff6dll = 'libtiff-6-x64.dll';
{$ENDIF}

  LibTiffDelphiVersionString = 'LibTiff6 1.0.0 - Delphi implementation by bigmike'#13#10'Based on Do-wan Kim implementation';

  TIFF_NOTYPE                           = 0;
  TIFF_BYTE                             = 1;       { 8-bit unsigned integer }
  TIFF_ASCII                            = 2;       { 8-bit bytes w/ last byte null }
  TIFF_SHORT                            = 3;       { 16-bit unsigned integer }
  TIFF_LONG                             = 4;       { 32-bit unsigned integer }
  TIFF_RATIONAL                         = 5;       { 64-bit unsigned fraction }
  TIFF_SBYTE                            = 6;       { !8-bit signed integer }
  TIFF_UNDEFINED                        = 7;       { !8-bit untyped data }
  TIFF_SSHORT                           = 8;       { !16-bit signed integer }
  TIFF_SLONG                            = 9;       { !32-bit signed integer }
  TIFF_SRATIONAL                        = 10;      { !64-bit signed fraction }
  TIFF_FLOAT                            = 11;      { !32-bit IEEE floating point }
  TIFF_DOUBLE                           = 12;      { !64-bit IEEE floating point }
  TIFF_IFD                              = 13;      { %32-bit unsigned integer (offset) }
  TIFF_UNICODE                          = 14;
  TIFF_COMPLEX                          = 15;
  TIFF_LONG8                            = 16;
  TIFF_SLONG8                           = 17;
  TIFF_IFD8                             = 18;


  TIFFTAG_SUBFILETYPE                   = 254;     { subfile data descriptor }
    FILETYPE_REDUCEDIMAGE               = $1;      { reduced resolution version }
    FILETYPE_PAGE                       = $2;      { one page of many }
    FILETYPE_MASK                       = $4;      { transparency mask }
  TIFFTAG_OSUBFILETYPE                  = 255;     { kind of data in subfile }
    OFILETYPE_IMAGE                     = 1;       { full resolution image data }
    OFILETYPE_REDUCEDIMAGE              = 2;       { reduced size image data }
    OFILETYPE_PAGE                      = 3;       { one page of many }
  TIFFTAG_IMAGEWIDTH                    = 256;     { image width in pixels }
  TIFFTAG_IMAGELENGTH                   = 257;     { image height in pixels }
  TIFFTAG_BITSPERSAMPLE                 = 258;     { bits per channel (sample) }
  TIFFTAG_COMPRESSION                   = 259;     { data compression technique }
    COMPRESSION_NONE                    = 1;       { dump mode }
    COMPRESSION_CCITTRLE                = 2;       { CCITT modified Huffman RLE }
    COMPRESSION_CCITTFAX3               = 3;       { CCITT Group 3 fax encoding }
    COMPRESSION_CCITT_T4                = 3;       { CCITT T.4 (TIFF 6 name) }
    COMPRESSION_CCITTFAX4               = 4;       { CCITT Group 4 fax encoding }
    COMPRESSION_CCITT_T6                = 4;       { CCITT T.6 (TIFF 6 name) }
    COMPRESSION_LZW                     = 5;       { Lempel-Ziv  & Welch }
    COMPRESSION_OJPEG                   = 6;       { !6.0 JPEG }
    COMPRESSION_JPEG                    = 7;       { %JPEG DCT compression }
    COMPRESSION_T85                     = 9;       { !TIFF/FX T.85 JBIG compression }
    COMPRESSION_T43                     = 10;      { !TIFF/FX T.43 colour by layered JBIG compression }
    COMPRESSION_NEXT                    = 32766;   { NeXT 2-bit RLE }
    COMPRESSION_CCITTRLEW               = 32771;   { #1 w/ word alignment }
    COMPRESSION_PACKBITS                = 32773;   { Macintosh RLE }
    COMPRESSION_THUNDERSCAN             = 32809;   { ThunderScan RLE }
    { codes 32895-32898 are reserved for ANSI IT8 TIFF/IT <dkelly@apago.com) }
    COMPRESSION_IT8CTPAD                = 32895;   { IT8 CT w/padding }
    COMPRESSION_IT8LW                   = 32896;   { IT8 Linework RLE }
    COMPRESSION_IT8MP                   = 32897;   { IT8 Monochrome picture }
    COMPRESSION_IT8BL                   = 32898;   { IT8 Binary line art }
    { compression codes 32908-32911 are reserved for Pixar }
    COMPRESSION_PIXARFILM               = 32908;   { Pixar companded 10bit LZW }
    COMPRESSION_PIXARLOG                = 32909;   { Pixar companded 11bit ZIP }
    COMPRESSION_DEFLATE                 = 32946;   { Deflate compression }
    COMPRESSION_ADOBE_DEFLATE           = 8;       { Deflate compression, as recognized by Adobe }
    { compression code 32947 is reserved for Oceana Matrix <dev@oceana.com> }
    COMPRESSION_DCS                     = 32947;   { Kodak DCS encoding }
    COMPRESSION_JBIG                    = 34661;   { ISO JBIG }
    COMPRESSION_SGILOG                  = 34676;   { SGI Log Luminance RLE }
    COMPRESSION_SGILOG24                = 34677;   { SGI Log 24-bit packed }
    COMPRESSION_JP2000                  = 34712;   { Leadtools JPEG2000 }
    COMPRESSION_LERC                    = 34887;   { ESRI Lerc codec: https://github.com/Esri/lerc }
    { Compression codes 34887-34889 are reserved for ESRI }
    COMPRESSION_LZMA                    = 34925;   { LZMA2 }
    COMPRESSION_ZSTD                    = 50000;   { ZSTD: WARNING not registered in Adobe-maintained registry }
    COMPRESSION_WEBP                    = 50001;   { WEBP: WARNING not registered in Adobe-maintained registry }
    COMPRESSION_JXL                     = 50002;   { JPEGXL: WARNING not registered in Adobe-maintained registry }
    COMPRESSION_JXL_DNG_1_7             = 52546;   { JPEGXL from DNG 1.7 specification }
  TIFFTAG_PHOTOMETRIC                   = 262;     { photometric interpretation }
    PHOTOMETRIC_MINISWHITE              = 0;       { min value is white }
    PHOTOMETRIC_MINISBLACK              = 1;       { min value is black }
    PHOTOMETRIC_RGB                     = 2;       { RGB color model }
    PHOTOMETRIC_PALETTE                 = 3;       { color map indexed }
    PHOTOMETRIC_MASK                    = 4;       { $holdout mask }
    PHOTOMETRIC_SEPARATED               = 5;       { !color separations }
    PHOTOMETRIC_YCBCR                   = 6;       { !CCIR 601 }
    PHOTOMETRIC_CIELAB                  = 8;       { !1976 CIE L*a*b* }
    PHOTOMETRIC_ICCLAB                  = 9;       { ICC L*a*b* [Adobe TIFF Technote 4] }
    PHOTOMETRIC_ITULAB                  = 10;      { ITU L*a*b* }
    PHOTOMETRIC_CFA                     = 32803;
    PHOTOMETRIC_LOGL                    = 32844;   { CIE Log2(L) }
    PHOTOMETRIC_LOGLUV                  = 32845;   { CIE Log2(L) (u',v') }
  TIFFTAG_THRESHHOLDING                 = 263;     { thresholding used on data }
    THRESHHOLD_BILEVEL                  = 1;       { b&w art scan }
    THRESHHOLD_HALFTONE                 = 2;       { or dithered scan }
    THRESHHOLD_ERRORDIFFUSE             = 3;       { usually floyd-steinberg }
  TIFFTAG_CELLWIDTH                     = 264;     { +dithering matrix width }
  TIFFTAG_CELLLENGTH                    = 265;     { +dithering matrix height }
  TIFFTAG_FILLORDER                     = 266;     { data order within a byte }
    FILLORDER_MSB2LSB                   = 1;       { most significant -> least }
    FILLORDER_LSB2MSB                   = 2;       { least significant -> most }
  TIFFTAG_DOCUMENTNAME                  = 269;     { name of doc. image is from }
  TIFFTAG_IMAGEDESCRIPTION              = 270;     { info about image }
  TIFFTAG_MAKE                          = 271;     { scanner manufacturer name }
  TIFFTAG_MODEL                         = 272;     { scanner model name/number }
  TIFFTAG_STRIPOFFSETS                  = 273;     { offsets to data strips }
  TIFFTAG_ORIENTATION                   = 274;     { +image orientation }
    ORIENTATION_TOPLEFT                 = 1;       { row 0 top, col 0 lhs }
    ORIENTATION_TOPRIGHT                = 2;       { row 0 top, col 0 rhs }
    ORIENTATION_BOTRIGHT                = 3;       { row 0 bottom, col 0 rhs }
    ORIENTATION_BOTLEFT                 = 4;       { row 0 bottom, col 0 lhs }
    ORIENTATION_LEFTTOP                 = 5;       { row 0 lhs, col 0 top }
    ORIENTATION_RIGHTTOP                = 6;       { row 0 rhs, col 0 top }
    ORIENTATION_RIGHTBOT                = 7;       { row 0 rhs, col 0 bottom }
    ORIENTATION_LEFTBOT                 = 8;       { row 0 lhs, col 0 bottom }
  TIFFTAG_SAMPLESPERPIXEL               = 277;     { samples per pixel }
  TIFFTAG_ROWSPERSTRIP                  = 278;     { rows per strip of data }
  TIFFTAG_STRIPBYTECOUNTS               = 279;     { bytes counts for strips }
  TIFFTAG_MINSAMPLEVALUE                = 280;     { +minimum sample value }
  TIFFTAG_MAXSAMPLEVALUE                = 281;     { +maximum sample value }
  TIFFTAG_XRESOLUTION                   = 282;     { pixels/resolution in x }
  TIFFTAG_YRESOLUTION                   = 283;     { pixels/resolution in y }
  TIFFTAG_PLANARCONFIG                  = 284;     { storage organization }
    PLANARCONFIG_CONTIG                 = 1;       { single image plane }
    PLANARCONFIG_SEPARATE               = 2;       { separate planes of data }
  TIFFTAG_PAGENAME                      = 285;     { page name image is from }
  TIFFTAG_XPOSITION                     = 286;     { x page offset of image lhs }
  TIFFTAG_YPOSITION                     = 287;     { y page offset of image lhs }
  TIFFTAG_FREEOFFSETS                   = 288;     { +byte offset to free block }
  TIFFTAG_FREEBYTECOUNTS                = 289;     { +sizes of free blocks }

  {matched with tag reference up to this point}

  TIFFTAG_GRAYRESPONSEUNIT              = 290;     { $gray scale curve accuracy }
    GRAYRESPONSEUNIT_10S                = 1;       { tenths of a unit }
    GRAYRESPONSEUNIT_100S               = 2;       { hundredths of a unit }
    GRAYRESPONSEUNIT_1000S              = 3;       { thousandths of a unit }
    GRAYRESPONSEUNIT_10000S             = 4;       { ten-thousandths of a unit }
    GRAYRESPONSEUNIT_100000S            = 5;       { hundred-thousandths }
  TIFFTAG_GRAYRESPONSECURVE             = 291;     { $gray scale response curve }
  TIFFTAG_GROUP3OPTIONS                 = 292;     { 32 flag bits }
  TIFFTAG_T4OPTIONS                     = 292;     { TIFF 6.0 proper name alias }
    GROUP3OPT_2DENCODING                = $1;      { 2-dimensional coding }
    GROUP3OPT_UNCOMPRESSED              = $2;      { data not compressed }
    GROUP3OPT_FILLBITS                  = $4;      { fill to byte boundary }
  TIFFTAG_GROUP4OPTIONS                 = 293;     { 32 flag bits }
  TIFFTAG_T6OPTIONS                     = 293;     { TIFF 6.0 proper name }
    GROUP4OPT_UNCOMPRESSED              = $2;      { data not compressed }
  TIFFTAG_RESOLUTIONUNIT                = 296;     { units of resolutions }
    RESUNIT_NONE                        = 1;       { no meaningful units }
    RESUNIT_INCH                        = 2;       { english }
    RESUNIT_CENTIMETER                  = 3;       { metric }
  TIFFTAG_PAGENUMBER                    = 297;     { page numbers of multi-page }
  TIFFTAG_COLORRESPONSEUNIT             = 300;     { $color curve accuracy }
    COLORRESPONSEUNIT_10S               = 1;       { tenths of a unit }
    COLORRESPONSEUNIT_100S              = 2;       { hundredths of a unit }
    COLORRESPONSEUNIT_1000S             = 3;       { thousandths of a unit }
    COLORRESPONSEUNIT_10000S            = 4;       { ten-thousandths of a unit }
    COLORRESPONSEUNIT_100000S           = 5;       { hundred-thousandths }
  TIFFTAG_TRANSFERFUNCTION              = 301;     { !colorimetry info }
  TIFFTAG_SOFTWARE                      = 305;     { name & release }
  TIFFTAG_DATETIME                      = 306;     { creation date and time }
  TIFFTAG_ARTIST                        = 315;     { creator of image }
  TIFFTAG_HOSTCOMPUTER                  = 316;     { machine where created }
  TIFFTAG_PREDICTOR                     = 317;     { prediction scheme w/ LZW }
  PREDICTOR_NONE                        = 1;       { no prediction scheme used }
  PREDICTOR_HORIZONTAL                  = 2;       { floating point predictor }
  PREDICTOR_FLOATINGPOINT               = 3;       { floating point predictor }
  TIFFTAG_WHITEPOINT                    = 318;     { image white point }
  TIFFTAG_PRIMARYCHROMATICITIES         = 319;     { !primary chromaticities }
  TIFFTAG_COLORMAP                      = 320;     { RGB map for pallette image }
  TIFFTAG_HALFTONEHINTS                 = 321;     { !highlight+shadow info }
  TIFFTAG_TILEWIDTH                     = 322;     { !rows/data tile }
  TIFFTAG_TILELENGTH                    = 323;     { !cols/data tile }
  TIFFTAG_TILEOFFSETS                   = 324;     { !offsets to data tiles }
  TIFFTAG_TILEBYTECOUNTS                = 325;     { !byte counts for tiles }
  TIFFTAG_BADFAXLINES                   = 326;     { lines w/ wrong pixel count }
  TIFFTAG_CLEANFAXDATA                  = 327;     { regenerated line info }
    CLEANFAXDATA_CLEAN                  = 0;       { no errors detected }
    CLEANFAXDATA_REGENERATED            = 1;       { receiver regenerated lines }
    CLEANFAXDATA_UNCLEAN                = 2;       { uncorrected errors exist }
  TIFFTAG_CONSECUTIVEBADFAXLINES        = 328;     { max consecutive bad lines }
  TIFFTAG_SUBIFD                        = 330;     { subimage descriptors }
  TIFFTAG_INKSET                        = 332;     { !inks in separated image }
    INKSET_CMYK                         = 1;       { !cyan-magenta-yellow-black color }
    INKSET_MULTIINK                     = 2;       { !multi-ink or hi-fi color }
  TIFFTAG_INKNAMES                      = 333;     { !ascii names of inks }
  TIFFTAG_NUMBEROFINKS                  = 334;     { !number of inks }
  TIFFTAG_DOTRANGE                      = 336;     { !0% and 100% dot codes }
  TIFFTAG_TARGETPRINTER                 = 337;     { !separation target }
  TIFFTAG_EXTRASAMPLES                  = 338;     { !info about extra samples }
    EXTRASAMPLE_UNSPECIFIED             = 0;       { !unspecified data }
    EXTRASAMPLE_ASSOCALPHA              = 1;       { !associated alpha data }
    EXTRASAMPLE_UNASSALPHA              = 2;       { !unassociated alpha data }
  TIFFTAG_SAMPLEFORMAT                  = 339;     { !data sample format }
    SAMPLEFORMAT_UINT                   = 1;       { !unsigned integer data }
    SAMPLEFORMAT_INT                    = 2;       { !signed integer data }
    SAMPLEFORMAT_IEEEFP                 = 3;       { !IEEE floating point data }
    SAMPLEFORMAT_VOID                   = 4;       { !untyped data }
    SAMPLEFORMAT_COMPLEXINT             = 5;       { !complex signed int }
    SAMPLEFORMAT_COMPLEXIEEEFP          = 6;       { !complex ieee floating }
  TIFFTAG_SMINSAMPLEVALUE               = 340;     { !variable MinSampleValue }
  TIFFTAG_SMAXSAMPLEVALUE               = 341;     { !variable MaxSampleValue }
  TIFFTAG_CLIPPATH                      = 343;     { %ClipPath [Adobe TIFF technote 2] }
  TIFFTAG_XCLIPPATHUNITS                = 344;     { %XClipPathUnits [Adobe TIFF technote 2] }
  TIFFTAG_YCLIPPATHUNITS                = 345;     { %YClipPathUnits [Adobe TIFF technote 2] }
  TIFFTAG_INDEXED                       = 346;     { %Indexed [Adobe TIFF Technote 3] }
  TIFFTAG_JPEGTABLES                    = 347;     { %JPEG table stream }
  TIFFTAG_OPIPROXY                      = 351;     { %OPI Proxy [Adobe TIFF technote] }
  { Tags 512-521 are obsoleted by Technical Note #2
  which specifies a revised JPEG-in-TIFF scheme. }
  TIFFTAG_JPEGPROC                      = 512;     { !JPEG processing algorithm }
    JPEGPROC_BASELINE                   = 1;       { !baseline sequential }
    JPEGPROC_LOSSLESS                   = 14;      { !Huffman coded lossless }
  TIFFTAG_JPEGIFOFFSET                  = 513;     { !pointer to SOI marker }
  TIFFTAG_JPEGIFBYTECOUNT               = 514;     { !JFIF stream length }
  TIFFTAG_JPEGRESTARTINTERVAL           = 515;     { !restart interval length }
  TIFFTAG_JPEGLOSSLESSPREDICTORS        = 517;     { !lossless proc predictor }
  TIFFTAG_JPEGPOINTTRANSFORM            = 518;     { !lossless point transform }
  TIFFTAG_JPEGQTABLES                   = 519;     { !Q matrice offsets }
  TIFFTAG_JPEGDCTABLES                  = 520;     { !DCT table offsets }
  TIFFTAG_JPEGACTABLES                  = 521;     { !AC coefficient offsets }
  TIFFTAG_YCBCRCOEFFICIENTS             = 529;     { !RGB -> YCbCr transform }
  TIFFTAG_YCBCRSUBSAMPLING              = 530;     { !YCbCr subsampling factors }
  TIFFTAG_YCBCRPOSITIONING              = 531;     { !subsample positioning }
    YCBCRPOSITION_CENTERED              = 1;       { !as in PostScript Level 2 }
    YCBCRPOSITION_COSITED               = 2;       { !as in CCIR 601-1 }
  TIFFTAG_REFERENCEBLACKWHITE           = 532;     { !colorimetry info }
  TIFFTAG_XMLPACKET                     = 700;     { %XML packet [Adobe XMP technote 9-14-02] (dkelly@apago.com) }
  TIFFTAG_OPIIMAGEID                    = 32781;   { %OPI ImageID [Adobe TIFF technote] }
  { tags 32952-32956 are private tags registered to Island Graphics }
  TIFFTAG_REFPTS                        = 32953;   { image reference points }
  TIFFTAG_REGIONTACKPOINT               = 32954;   { region-xform tack point }
  TIFFTAG_REGIONWARPCORNERS             = 32955;   { warp quadrilateral }
  TIFFTAG_REGIONAFFINE                  = 32956;   { affine transformation mat }
  { tags 32995-32999 are private tags registered to SGI }
  TIFFTAG_MATTEING                      = 32995;   { $use ExtraSamples }
  TIFFTAG_DATATYPE                      = 32996;   { $use SampleFormat }
  TIFFTAG_IMAGEDEPTH                    = 32997;   { z depth of image }
  TIFFTAG_TILEDEPTH                     = 32998;   { z depth/data tile }
  { tags 33300-33309 are private tags registered to Pixar }
  { TIFFTAG_PIXAR_IMAGEFULLWIDTH and TIFFTAG_PIXAR_IMAGEFULLLENGTH are set when an image has been cropped out of a larger image.
    They reflect the size of the original uncropped image. The TIFFTAG_XPOSITION and TIFFTAG_YPOSITION can be used to determine the
    position of the smaller image in the larger one. }
  TIFFTAG_PIXAR_IMAGEFULLWIDTH          = 33300;   { full image size in x }
  TIFFTAG_PIXAR_IMAGEFULLLENGTH         = 33301;   { full image size in y }
  { Tags 33302-33306 are used to identify special image modes and data used by Pixar's texture formats. }
  TIFFTAG_PIXAR_TEXTUREFORMAT           = 33302;   { texture map format }
  TIFFTAG_PIXAR_WRAPMODES               = 33303;   { s & t wrap modes }
  TIFFTAG_PIXAR_FOVCOT                  = 33304;   { cotan(fov) for env. maps }
  TIFFTAG_PIXAR_MATRIX_WORLDTOSCREEN    = 33305;
  TIFFTAG_PIXAR_MATRIX_WORLDTOCAMERA    = 33306;
  { tag 33405 is a private tag registered to Eastman Kodak }
  TIFFTAG_WRITERSERIALNUMBER            = 33405;   { device serial number }
  { tag 33432 is listed in the 6.0 spec w/ unknown ownership }
  TIFFTAG_COPYRIGHT                     = 33432;   { copyright string }
  { IPTC TAG from RichTIFF specifications }
  TIFFTAG_RICHTIFFIPTC                  = 33723;
  { 34016-34029 are reserved for ANSI IT8 TIFF/IT <dkelly@apago.com) }
  TIFFTAG_IT8SITE                       = 34016;   { site name }
  TIFFTAG_IT8COLORSEQUENCE              = 34017;   { color seq. [RGB,CMYK,etc] }
  TIFFTAG_IT8HEADER                     = 34018;   { DDES Header }
  TIFFTAG_IT8RASTERPADDING              = 34019;   { raster scanline padding }
  TIFFTAG_IT8BITSPERRUNLENGTH           = 34020;   { # of bits in short run }
  TIFFTAG_IT8BITSPEREXTENDEDRUNLENGTH   = 34021;   { # of bits in long run }
  TIFFTAG_IT8COLORTABLE                 = 34022;   { LW colortable }
  TIFFTAG_IT8IMAGECOLORINDICATOR        = 34023;   { BP/BL image color switch }
  TIFFTAG_IT8BKGCOLORINDICATOR          = 34024;   { BP/BL bg color switch }
  TIFFTAG_IT8IMAGECOLORVALUE            = 34025;   { BP/BL image color value }
  TIFFTAG_IT8BKGCOLORVALUE              = 34026;   { BP/BL bg color value }
  TIFFTAG_IT8PIXELINTENSITYRANGE        = 34027;   { MP pixel intensity value }
  TIFFTAG_IT8TRANSPARENCYINDICATOR      = 34028;   { HC transparency switch }
  TIFFTAG_IT8COLORCHARACTERIZATION      = 34029;   { color character. table }
  TIFFTAG_IT8HCUSAGE                    = 34030;   { HC usage indicator }
  TIFFTAG_IT8TRAPINDICATOR              = 34031;   { Trapping indicator (untrapped=0, trapped=1) }
  TIFFTAG_IT8CMYKEQUIVALENT             = 34032;   { CMYK color equivalents }
  { tags 34232-34236 are private tags registered to Texas Instruments }
  TIFFTAG_FRAMECOUNT                    = 34232;   { Sequence Frame Count }
  { tag 34750 is a private tag registered to Adobe? }
  TIFFTAG_ICCPROFILE                    = 34675;   { ICC profile data }
  { tag 34377 is private tag registered to Adobe for PhotoShop }
  TIFFTAG_PHOTOSHOP                     = 34377;
  { tag 34750 is a private tag registered to Pixel Magic }
  TIFFTAG_JBIGOPTIONS                   = 34750;   { JBIG options }
  { tags 34908-34914 are private tags registered to SGI }
  TIFFTAG_FAXRECVPARAMS                 = 34908;   { encoded Class 2 ses. parms }
  TIFFTAG_FAXSUBADDRESS                 = 34909;   { received SubAddr string }
  TIFFTAG_FAXRECVTIME                   = 34910;   { receive time (secs) }
  { tags 37439-37443 are registered to SGI <gregl@sgi.com> }
  TIFFTAG_STONITS                       = 37439;   { Sample value to Nits }
  { tag 34929 is a private tag registered to FedEx }
  TIFFTAG_FEDEX_EDR                     = 34929;   { unknown use }
  { tag 65535 is an undefined tag used by Eastman Kodak }
  TIFFTAG_DCSHUESHIFTVALUES             = 65535;   { hue shift correction data }
  { The following are ``pseudo tags'' that can be used to control codec-specific functionality. These tags are not written to file.
    Note that these values start at 0xffff+1 so that they'll never collide with Aldus-assigned tags. }
  TIFFTAG_FAXMODE                       = 65536;   { Group 3/4 format control }
    FAXMODE_CLASSIC                     = $0;      { default, include RTC }
    FAXMODE_NORTC                       = $1;      { no RTC at end of data }
    FAXMODE_NOEOL                       = $2;      { no EOL code at end of row }
    FAXMODE_BYTEALIGN                   = $4;      { byte align row }
    FAXMODE_WORDALIGN                   = $8;      { word align row }
    FAXMODE_CLASSF                      = FAXMODE_NORTC;        { TIFF Class F }
  TIFFTAG_JPEGQUALITY                   = 65537;   { Compression quality level }
  { Note: quality level is on the IJG 0-100 scale.  Default value is 75 }
  TIFFTAG_JPEGCOLORMODE                 = 65538;   { Auto RGB<=>YCbCr convert? }
    JPEGCOLORMODE_RAW                   = $0;      { no conversion (default) }
    JPEGCOLORMODE_RGB                   = $1;      { do auto conversion }
  TIFFTAG_JPEGTABLESMODE                = 65539;   { What to put in JPEGTables }
    JPEGTABLESMODE_QUANT                = $1;      { include quantization tbls }
    JPEGTABLESMODE_HUFF                 = $2;      { include Huffman tbls }
  { Note: default is JPEGTABLESMODE_QUANT | JPEGTABLESMODE_HUFF }
  TIFFTAG_FAXFILLFUNC                   = 65540;   { G3/G4 fill function }
  TIFFTAG_PIXARLOGDATAFMT               = 65549;   { PixarLogCodec I/O data sz }
    PIXARLOGDATAFMT_8BIT                = 0;       { regular u_char samples }
    PIXARLOGDATAFMT_8BITABGR            = 1;       { ABGR-order u_chars }
    PIXARLOGDATAFMT_11BITLOG            = 2;       { 11-bit log-encoded (raw) }
    PIXARLOGDATAFMT_12BITPICIO          = 3;       { as per PICIO (1.0==2048) }
    PIXARLOGDATAFMT_16BIT               = 4;       { signed short samples }
    PIXARLOGDATAFMT_FLOAT               = 5;       { IEEE float samples }
  { 65550-65556 are allocated to Oceana Matrix <dev@oceana.com> }
  TIFFTAG_DCSIMAGERTYPE                 = 65550;   { imager model & filter }
    DCSIMAGERMODEL_M3                   = 0;       { M3 chip (1280 x 1024) }
    DCSIMAGERMODEL_M5                   = 1;       { M5 chip (1536 x 1024) }
    DCSIMAGERMODEL_M6                   = 2;       { M6 chip (3072 x 2048) }
    DCSIMAGERFILTER_IR                  = 0;       { infrared filter }
    DCSIMAGERFILTER_MONO                = 1;       { monochrome filter }
    DCSIMAGERFILTER_CFA                 = 2;       { color filter array }
    DCSIMAGERFILTER_OTHER               = 3;       { other filter }
  TIFFTAG_DCSINTERPMODE                 = 65551;   { interpolation mode }
    DCSINTERPMODE_NORMAL                = 0;       { whole image, default }
    DCSINTERPMODE_PREVIEW               = 1;       { preview of image (384x256) }
  TIFFTAG_DCSBALANCEARRAY               = 65552;   { color balance values }
  TIFFTAG_DCSCORRECTMATRIX              = 65553;   { color correction values }
  TIFFTAG_DCSGAMMA                      = 65554;   { gamma value }
  TIFFTAG_DCSTOESHOULDERPTS             = 65555;   { toe & shoulder points }
  TIFFTAG_DCSCALIBRATIONFD              = 65556;   { calibration file desc }
  { Note: quality level is on the ZLIB 1-9 scale. Default value is -1 }
  TIFFTAG_ZIPQUALITY                    = 65557;   { compression quality level }
  TIFFTAG_PIXARLOGQUALITY               = 65558;   { PixarLog uses same scale }
  { 65559 is allocated to Oceana Matrix <dev@oceana.com> }
  TIFFTAG_DCSCLIPRECTANGLE              = 65559;   { area of image to acquire }
  TIFFTAG_SGILOGDATAFMT                 = 65560;   { SGILog user data format }
    SGILOGDATAFMT_FLOAT                 = 0;       { IEEE float samples }
    SGILOGDATAFMT_16BIT                 = 1;       { 16-bit samples }
    SGILOGDATAFMT_RAW                   = 2;       { uninterpreted data }
    SGILOGDATAFMT_8BIT                  = 3;       { 8-bit RGB monitor values }
  TIFFTAG_SGILOGENCODE                  = 65561;   { SGILog data encoding control }
    SGILOGENCODE_NODITHER               = 0;       { do not dither encoded values }
    SGILOGENCODE_RANDITHER              = 1;       { randomly dither encd values }
  TIFFTAG_LZMAPRESET                    = 65562;
  TIFFTAG_ZSTD_LEVEL                    = 65564;
  TIFFTAG_LERC_VERSION                  = 65565;
  TIFFTAG_LERC_ADD_COMPRESSION          = 65566;
  TIFFTAG_LERC_MAXZERROR                = 65567;
  TIFFTAG_WEBP_LEVEL                    = 65568;
  TIFFTAG_WEBP_LOSSLESS                 = 65569;
  TIFFTAG_DEFLATE_SUBCODEC              = 65570;

  { Flags to pass to TIFFPrintDirectory to control printing of data structures that are potentially very large. Bit-or these flags to
    enable printing multiple items. }
  TIFFPRINT_NONE                        = $0;      { no extra info }
  TIFFPRINT_STRIPS                      = $1;      { strips/tiles info }
  TIFFPRINT_CURVES                      = $2;      { color/gray response curves }
  TIFFPRINT_COLORMAP                    = $4;      { colormap }
  TIFFPRINT_JPEGQTABLES                 = $100;    { JPEG Q matrices }
  TIFFPRINT_JPEGACTABLES                = $200;    { JPEG AC tables }
  TIFFPRINT_JPEGDCTABLES                = $200;    { JPEG DC tables }


  TIFF_ANY                              = TIFF_NOTYPE;   { for field descriptor searching }
  TIFF_VARIABLE                         = -1;      { marker for variable length tags }
  TIFF_SPP                              = -2;      { marker for SamplesPerPixel tags }
  TIFF_VARIABLE2                        = -3;      { marker for uint32 var-length tags }

  FIELD_CUSTOM                          = 65;

 {added for LibTiff 3.9.4 by Alex (leontyyy@gmail.com) Dec.2011}
  TIFFTAG_EXIFIFD                       = 34665;   { pointer to the Exif IFD }
  EXIFTAG_FOCALLENGTH                   = 37386;   { focal length }
  EXIFTAG_FOCALLENGTHIN35MMFILM         = 41989;   { indicates the equivalent focal length assuming a 35mm film camera, in mm }
  EXIFTAG_EXIFVERSION                   = 36864;   { version of exif format }
  EXIFTAG_DATETIMEDIGITIZED             = 36868;   { date and time when the image was stored as digital data }
  EXIFTAG_DATETIMEORIGINAL              = 36867;   { date and time when the original image data was generated }
  EXIFTAG_EXPOSURETIME                  = 33434;   { exposure time, given in seconds }
  EXIFTAG_FNUMBER                       = 33437;   { F number }
  EXIFTAG_EXPOSUREPROGRAM               = 34850;   { class of the program used by the camera to set exposure }
  EXIFTAG_SPECTRALSENSITIVITY           = 34852;   { spectral sensitivity of each channel of the camera used }
  EXIFTAG_ISOSPEEDRATINGS               = 34855;   { ISO Speed and ISO Latitude }
  EXIFTAG_OECF                          = 34856;   { Opto-Electric Conversion Function }
  EXIFTAG_COMPONENTSCONFIGURATION       = 37121;   { meaning of each component }
  EXIFTAG_COMPRESSEDBITSPERPIXEL        = 37122;   { compression mode }
  EXIFTAG_SHUTTERSPEEDVALUE             = 37377;   { shutter speed }
  EXIFTAG_APERTUREVALUE                 = 37378;   { lens aperture }
  EXIFTAG_BRIGHTNESSVALUE               = 37379;   { brightness }
  EXIFTAG_EXPOSUREBIASVALUE             = 37380;   { exposure bias }
  EXIFTAG_MAXAPERTUREVALUE              = 37381;   { maximum lens aperture }
  EXIFTAG_SUBJECTDISTANCE               = 37382;   { distance to the subject in meters }
  EXIFTAG_METERINGMODE                  = 37383;   { metering mode }
  EXIFTAG_LIGHTSOURCE                   = 37384;   { light source }
  EXIFTAG_FLASH                         = 37385;   { flash }
  EXIFTAG_SUBJECTAREA                   = 37396;   { subject area (in exif ver.2.2) }
  EXIFTAG_MAKERNOTE                     = 37500;   { manufacturer notes }
  EXIFTAG_USERCOMMENT                   = 37510;   { user comments }
  EXIFTAG_SUBSECTIME                    = 37520;   { DateTime subseconds }
  EXIFTAG_SUBSECTIMEORIGINAL            = 37521;   { DateTimeOriginal subseconds }
  EXIFTAG_SUBSECTIMEDIGITIZED           = 37522;   { DateTimeDigitized subseconds }
  EXIFTAG_FLASHPIXVERSION               = 40960;   { FlashPix format version }
  EXIFTAG_COLORSPACE                    = 40961;   { color space information }
  EXIFTAG_PIXELXDIMENSION               = 40962;   { valid image width }
  EXIFTAG_PIXELYDIMENSION               = 40963;   { valid image height }
  EXIFTAG_RELATEDSOUNDFILE              = 40964;   { related audio file }
  EXIFTAG_FLASHENERGY                   = 41483;   { flash energy }
  EXIFTAG_SPATIALFREQUENCYRESPONSE      = 41484;   { spatial frequency response }
  EXIFTAG_FOCALPLANEXRESOLUTION         = 41486;   { focal plane X resolution }
  EXIFTAG_FOCALPLANEYRESOLUTION         = 41487;   { focal plane Y resolution }
  EXIFTAG_FOCALPLANERESOLUTIONUNIT      = 41488;   { focal plane resolution unit }
  EXIFTAG_SUBJECTLOCATION               = 41492;   { subject location }
  EXIFTAG_EXPOSUREINDEX                 = 41493;   { exposure index }
  EXIFTAG_SENSINGMETHOD                 = 41495;   { sensing method }
  EXIFTAG_FILESOURCE                    = 41728;   { file source }
  EXIFTAG_SCENETYPE                     = 41729;   { scene type }
  EXIFTAG_CFAPATTERN                    = 41730;   { CFA pattern }
  EXIFTAG_CUSTOMRENDERED                = 41985;   { custom image processing (in exif ver.2.2) }
  EXIFTAG_EXPOSUREMODE                  = 41986;   { exposure mode (in exif ver.2.2) }
  EXIFTAG_WHITEBALANCE                  = 41987;   { white balance (in exif ver.2.2) }
  EXIFTAG_DIGITALZOOMRATIO              = 41988;   { digital zoom ratio (in exif ver.2.2) }
  EXIFTAG_SCENECAPTURETYPE              = 41990;   { scene capture type (in exif ver.2.2) }
  EXIFTAG_GAINCONTROL                   = 41991;   { gain control (in exif ver.2.2) }
  EXIFTAG_CONTRAST                      = 41992;   { contrast (in exif ver.2.2) }
  EXIFTAG_SATURATION                    = 41993;   { saturation (in exif ver.2.2) }
  EXIFTAG_SHARPNESS                     = 41994;   { sharpness (in exif ver.2.2) }
  EXIFTAG_DEVICESETTINGDESCRIPTION      = 41995;   { device settings description (in exif ver.2.2) }
  EXIFTAG_SUBJECTDISTANCERANGE          = 41996;   { subject distance range (in exif ver.2.2) }
  EXIFTAG_IMAGEUNIQUEID                 = 42016;   { Unique image ID (in exif ver.2.2) }
  
  { New for EXIF-Version 2.32, May 2019 ... }
  EXIFTAG_SENSITIVITYTYPE               = 34864;   { The SensitivityType tag indicates which one of the parameters of ISO12232 is the PhotographicSensitivity tag. }
  EXIFTAG_STANDARDOUTPUTSENSITIVITY     = 34865;   { This tag indicates the standard output sensitivity value of a camera or input device defined in ISO 12232. }
  EXIFTAG_RECOMMENDEDEXPOSUREINDEX      = 34866;   { recommended exposure index   }
  EXIFTAG_ISOSPEED                      = 34867;   { ISO speed value }
  EXIFTAG_ISOSPEEDLATITUDEYYY           = 34868;   { ISO speed latitude yyy }
  EXIFTAG_ISOSPEEDLATITUDEZZZ           = 34869;   { ISO speed latitude zzz }
  EXIFTAG_OFFSETTIME                    = 36880;   { offset from UTC of the time of DateTime tag. }
  EXIFTAG_OFFSETTIMEORIGINAL            = 36881;   { offset from UTC of the time of DateTimeOriginal tag. }
  EXIFTAG_OFFSETTIMEDIGITIZED           = 36882;   { offset from UTC of the time of DateTimeDigitized tag. }
  EXIFTAG_TEMPERATURE                   = 37888;   { Temperature as the ambient situation at the shot in dergee Celsius }
  EXIFTAG_HUMIDITY                      = 37889;   { Humidity as the ambient situation at the shot in percent }
  EXIFTAG_PRESSURE                      = 37890;   { Pressure as the ambient situation at the shot hecto-Pascal (hPa) }
  EXIFTAG_WATERDEPTH                    = 37891;   { WaterDepth as the ambient situation at the shot in meter (m) }
  EXIFTAG_ACCELERATION                  = 37892;   { Acceleration (a scalar regardless of direction) as the ambientsituation at the shot in units of mGal (10-5 m/s^2) }

  { EXIFTAG_CAMERAELEVATIONANGLE: Elevation/depression. angle of the orientation of the  camera(imaging optical axis) }
  {                               as the ambient situation at the shot in degree from -180deg to +180deg. }
  EXIFTAG_CAMERAELEVATIONANGLE          = 37893;
  EXIFTAG_CAMERAOWNERNAME               = 42032;   { owner of a camera }
  EXIFTAG_BODYSERIALNUMBER              = 42033;   { serial number of the body of the camera }
  
  { EXIFTAG_LENSSPECIFICATION: minimum focal length (in mm), maximum focal length (in mm),minimum F number in the minimum focal length, }
  {                            and minimum F number in the maximum focal length, }
  EXIFTAG_LENSSPECIFICATION             = 42034;
  EXIFTAG_LENSMAKE                      = 42035;   { the lens manufacturer }
  EXIFTAG_LENSMODEL                     = 42036;   { the lens model name and model number }
  EXIFTAG_LENSSERIALNUMBER              = 42037;   { the serial number of the interchangeable lens }
  EXIFTAG_GAMMA                         = 42240;   { value of coefficient gamma }
  EXIFTAG_COMPOSITEIMAGE                = 42080;   { composite image }
  EXIFTAG_SOURCEIMAGENUMBEROFCOMPOSITEIMAGE = 42081;   { source image number of composite image }
  EXIFTAG_SOURCEEXPOSURETIMESOFCOMPOSITEIMAGE = 42082; { source exposure times of composite image }  

{ EXIF-GPS tags (Version 2.31, July 2016) }
  GPSTAG_VERSIONID                      = 0;       { Indicates the version of GPSInfoIFD. }
  GPSTAG_LATITUDEREF                    = 1;       { Indicates whether the latitude is north or south latitude. }
  GPSTAG_LATITUDE                       = 2;       { Indicates the latitude. }
  GPSTAG_LONGITUDEREF                   = 3;       { Indicates whether the longitude is east or west longitude. }
  GPSTAG_LONGITUDE                      = 4;       { Indicates the longitude. }
  GPSTAG_ALTITUDEREF                    = 5;       { Indicates the altitude used as the reference altitude. }
  GPSTAG_ALTITUDE                       = 6;       { Indicates the altitude based on the reference in GPSAltitudeRef. }
  GPSTAG_TIMESTAMP                      = 7;       {Indicates the time as UTC (Coordinated Universal Time). }
  GPSTAG_SATELLITES                     = 8;       {Indicates the GPS satellites used for measurements. }
  GPSTAG_STATUS                         = 9;       { Indicates the status of the GPS receiver when the image is  recorded. }
  GPSTAG_MEASUREMODE                    = 10;      { Indicates the GPS measurement mode. }
  GPSTAG_DOP                            = 11;      { Indicates the GPS DOP (data degree of precision). }
  GPSTAG_SPEEDREF                       = 12;      { Indicates the unit used to express the GPS receiver speed of movement. }
  GPSTAG_SPEED                          = 13;      { Indicates the speed of GPS receiver movement. }
  GPSTAG_TRACKREF                       = 14;      { Indicates the reference for giving the direction of GPS receiver movement. }
  GPSTAG_TRACK                          = 15;      { Indicates the direction of GPS receiver movement. }
  GPSTAG_IMGDIRECTIONREF                = 16;      { Indicates the reference for giving the direction of the image when it is captured. }
  GPSTAG_IMGDIRECTION                   = 17;      { Indicates the direction of the image when it was captured. }
  GPSTAG_MAPDATUM                       = 18;      { Indicates the geodetic survey data used by the GPS receiver. (e.g. WGS-84) }
  GPSTAG_DESTLATITUDEREF                = 19;      { Indicates whether the latitude of the destination point is north or south latitude. }
  GPSTAG_DESTLATITUDE                   = 20;      { Indicates the latitude of the destination point. }
  GPSTAG_DESTLONGITUDEREF               = 21;      { Indicates whether the longitude of the destination point is east or west longitude. }
  GPSTAG_DESTLONGITUDE                  = 22;      { Indicates the longitude of the destination point. }
  GPSTAG_DESTBEARINGREF                 = 23;      { Indicates the reference used for giving the bearing to the destination point. }
  GPSTAG_DESTBEARING                    = 24;      { Indicates the bearing to the destination point. }
  GPSTAG_DESTDISTANCEREF                = 25;      { Indicates the unit used to express the distance to the destination point. }
  GPSTAG_DESTDISTANCE                   = 26;      { Indicates the distance to the destination point. }
  GPSTAG_PROCESSINGMETHOD               = 27;      { A character string recording the name of the method used for location finding. }
  GPSTAG_AREAINFORMATION                = 28;      { A character string recording the name of the GPS area. }
  GPSTAG_DATESTAMP                      = 29;      { A character string recording date and time information relative to UTC (Coordinated Universal Time). }
  GPSTAG_DIFFERENTIAL                   = 30;      { Indicates whether differential correction is applied to the GPS receiver. }
  GPSTAG_GPSHPOSITIONINGERROR           = 31;      { Indicates horizontal positioning errors in meters. }

type
  PTIFF = Pointer;
  PTIFFRGBAImage = Pointer;

  TIFFErrorHandler = procedure(a: Pointer; b: Pointer; c: Pointer); cdecl;
  LibTiffDelphiErrorHandler = procedure(const a,b: AnsiString);
  
  // 64-bit updates: Fd changed to THandle. Size changed to NativeInt. Off and Size/Seek return values updated to UInt64
  TIFFReadWriteProc = function(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl;
  TIFFSeekProc = function(Fd: THandle; Off: UInt64; Whence: Integer): UInt64; cdecl;
  TIFFCloseProc = function(Fd: THandle): Integer; cdecl;
  TIFFSizeProc = function(Fd: THandle): UInt64; cdecl;
  TIFFMapFileProc = function(Fd: THandle; PBase: PPointer; PSize: PUInt64): Integer; cdecl;
  TIFFUnmapFileProc = procedure(Fd: THandle; Base: Pointer; Size: UInt64); cdecl;
  TIFFExtendProc = procedure(Handle: PTIFF); cdecl;

  TIFFInitMethod = function(Handle: PTIFF; Scheme: Integer): Integer; cdecl;

  PTIFFCodec = ^TIFFCodec;
  TIFFCodec = record
    Name: PAnsiChar;
    Scheme: Word;
    Init: TIFFInitMethod;
  end;

  PTIFFFieldInfo = ^TIFFFieldInfo;
  TIFFFieldInfo = record
    FieldTag: Cardinal;              { field's tag }
    FieldReadCount: Smallint;        { read count/TIFF_VARIABLE/TIFF_SPP }
    FieldWriteCount: Smallint;       { write count/TIFF_VARIABLE }
    FieldType: Integer;              { type of associated data }
    FieldBit: Word;                  { bit in fieldsset bit vector }
    FieldOkToChange: Byte;           { if true, can change while writing }
    FieldPassCount: Byte;            { if true, pass dir count on set }
    FieldName: PAnsiChar;            { ASCII name }
  end;

  PTIFFTagValue = ^TIFFTagValue;
  TIFFTagValue = record
    Info: PTIFFFieldInfo;
    Count: Integer;
    Value: Pointer;
  end;

function  LibTiffDelphiVersion: AnsiString;

function  TIFFOpen(const Name: PAnsiChar; const Mode: PAnsiChar): PTIFF; cdecl; external libtiff6dll name 'TIFFOpen';
function  TIFFOpenFile(const Name: PAnsiChar; const Mode: PAnsiChar): PTIFF;
function  TIFFGetVersion: PAnsiChar; cdecl; external libtiff6dll name 'TIFFGetVersion';
function  TIFFFindCODEC(Scheme: Word): PTIFFCodec; cdecl; external libtiff6dll name 'TIFFFindCODEC';
function  TIFFRegisterCODEC(Scheme: Word; Name: PAnsiChar; InitMethod: TIFFInitMethod): PTIFFCodec; cdecl; external libtiff6dll name 'TIFFRegisterCODEC';
procedure TIFFUnRegisterCODEC(c: PTIFFCodec); cdecl; external libtiff6dll name 'TIFFUnRegisterCODEC';
function  TIFFIsCODECConfigured(Scheme: Word): Integer; cdecl; external libtiff6dll name 'TIFFIsCODECConfigured';
function  TIFFGetConfiguredCODECs: PTIFFCodec; cdecl; external libtiff6dll name 'TIFFGetConfiguredCODECs';
function  TIFFOpenStream(const Stream: TStream; const Mode: PAnsiChar): PTIFF;
function  TIFFClientOpen(Name: PAnsiChar; Mode: PAnsiChar; ClientData: THandle;
          ReadProc: TIFFReadWriteProc;
          WriteProc: TIFFReadWriteProc;
          SeekProc: TIFFSeekProc;
          CloseProc: TIFFCloseProc;
          SizeProc: TIFFSizeProc;
          MapProc: TIFFMapFileProc;
          UnmapProc: TIFFUnmapFileProc): PTIFF; cdecl; external libtiff6dll name 'TIFFClientOpen';
procedure TIFFCleanup(Handle: PTIFF); cdecl; external libtiff6dll name 'TIFFCleanup';
procedure TIFFClose(Handle: PTIFF); cdecl; external libtiff6dll name 'TIFFClose';
function  TIFFFileno(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFFileno';
function  TIFFSetFileno(Handle: PTIFF; Newvalue: Integer): Integer; cdecl; external libtiff6dll name 'TIFFSetFileno';
function  TIFFClientdata(Handle: PTIFF): THandle; cdecl; external libtiff6dll name 'TIFFClientdata';
function  TIFFSetClientdata(Handle: PTIFF; Newvalue: THandle): THandle; cdecl; external libtiff6dll name 'TIFFSetClientdata';
function  TIFFGetMode(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFGetMode';
function  TIFFSetMode(Handle: PTIFF; Mode: Integer): Integer; cdecl; external libtiff6dll name 'TIFFSetMode';
function  TIFFFileName(Handle: PTIFF): PAnsiChar; cdecl; external libtiff6dll name 'TIFFFileName';
function  TIFFSetFileName(Handle: PTIFF; Name: PAnsiChar): PAnsiChar; cdecl; external libtiff6dll name 'TIFFSetFileName';
function  TIFFGetReadProc(Handle: PTIFF): TIFFReadWriteProc; cdecl; external libtiff6dll name 'TIFFGetReadProc';
function  TIFFGetWriteProc(Handle: PTIFF): TIFFReadWriteProc; cdecl; external libtiff6dll name 'TIFFGetWriteProc';
function  TIFFGetSeekProc(Handle: PTIFF): TIFFSeekProc; cdecl; external libtiff6dll name 'TIFFGetSeekProc';
function  TIFFGetCloseProc(Handle: PTIFF): TIFFCloseProc; cdecl; external libtiff6dll name 'TIFFGetCloseProc';
function  TIFFGetSizeProc(Handle: PTIFF): TIFFSizeProc; cdecl; external libtiff6dll name 'TIFFGetSizeProc';
procedure TIFFError(Module: Pointer; Fmt: Pointer); cdecl; external libtiff6dll name 'TIFFError'; varargs;
function  TIFFSetErrorHandler(Handler: TIFFErrorHandler): TIFFErrorHandler; cdecl; external libtiff6dll name 'TIFFSetErrorHandler';
function  LibTiffDelphiGetErrorHandler: LibTiffDelphiErrorHandler;
function  LibTiffDelphiSetErrorHandler(Handler: LibTiffDelphiErrorHandler): LibTiffDelphiErrorHandler;
procedure TIFFWarning(Module: Pointer; Fmt: Pointer); cdecl; external libtiff6dll name 'TIFFWarning'; varargs;
function  TIFFSetWarningHandler(Handler: TIFFErrorHandler): TIFFErrorHandler; cdecl; external libtiff6dll name 'TIFFSetWarningHandler';
function  LibTiffDelphiGetWarningHandler: LibTiffDelphiErrorHandler;
function  LibTiffDelphiSetWarningHandler(Handler: LibTiffDelphiErrorHandler): LibTiffDelphiErrorHandler;
function  TIFFSetTagExtender(Extender: TIFFExtendProc): TIFFExtendProc; cdecl; external libtiff6dll name 'TIFFSetTagExtender';

function  TIFFFlush(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFFlush';
function  TIFFFlushData(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFFlushData';

{added for LibTiff 3.9.4 by Alex (leontyyy@gmail.com) Dec.2011}
function  TIFFReadEXIFDirectory(Handle: PTIFF; Diroff: UInt64): Integer; cdecl; external libtiff6dll name 'TIFFReadEXIFDirectory';

function  TIFFReadDirectory(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFReadDirectory';
function  TIFFCurrentDirectory(Handle: PTIFF): Cardinal; cdecl; external libtiff6dll name 'TIFFCurrentDirectory';
function  TIFFCurrentDirOffset(Handle: PTIFF): UInt64; cdecl; external libtiff6dll name 'TIFFCurrentDirOffset';
function  TIFFLastDirectory(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFLastDirectory';
function  TIFFNumberOfDirectories(Handle: PTIFF): Cardinal; cdecl; external libtiff6dll name 'TIFFNumberOfDirectories';
function  TIFFSetDirectory(Handle: PTIFF; Dirn: Cardinal): Integer; cdecl; external libtiff6dll name 'TIFFSetDirectory';
function  TIFFSetSubDirectory(Handle: PTIFF; Diroff: UInt64): Integer; cdecl; external libtiff6dll name 'TIFFSetSubDirectory';
function  TIFFCreateDirectory(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFCreateDirectory';
function  TIFFWriteDirectory(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFWriteDirectory';
function  TIFFUnlinkDirectory(handle: PTIFF; Dirn: Cardinal): Integer; cdecl; external libtiff6dll name 'TIFFUnlinkDirectory';
procedure TIFFPrintDirectory(Handle: PTIFF; Fd: Pointer; Flags: Integer); cdecl; external libtiff6dll name 'TIFFPrintDirectory';

function  TIFFGetField(Handle: PTIFF; Tag: Cardinal): Integer; cdecl; external libtiff6dll name 'TIFFGetField'; varargs;
function  TIFFGetFieldDefaulted(Handle: PTIFF; Tag: Cardinal): Integer; cdecl; external libtiff6dll name 'TIFFGetFieldDefaulted'; varargs;
function  TIFFVGetField(Handle: PTIFF; Tag: Cardinal; Ap: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFVGetField';
function  TIFFSetField(Handle: PTIFF; Tag: Cardinal): Integer; cdecl; external libtiff6dll name 'TIFFSetField'; varargs;
function  TIFFVSetField(Handle: PTIFF; Tag: Cardinal; Ap: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFVSetField';
function  TIFFIsBigEndian(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFIsBigEndian';
function  TIFFIsTiled(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFIsTiled';
function  TIFFIsByteSwapped(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFIsByteSwapped';
function  TIFFIsUpSampled(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFIsUpSampled';
function  TIFFIsMSB2LSB(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFIsMSB2LSB';

function  TIFFGetTagListCount(Handle: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFGetTagListCount';
function  TIFFGetTagListEntry(Handle: PTIFF; TagIndex: Integer): Cardinal; cdecl; external libtiff6dll name 'TIFFGetTagListEntry';
function  TIFFMergeFieldInfo(Handle: PTIFF; Info: PTIFFFieldInfo; N: Cardinal): Integer; cdecl; external libtiff6dll name 'TIFFMergeFieldInfo';
function  TIFFFindFieldInfo(Handle: PTIFF; Tag: Cardinal; Dt: Integer): PTIFFFieldInfo; cdecl; external libtiff6dll name 'TIFFFindFieldInfo';
function  TIFFFindFieldInfoByName(Handle: PTIFF; FIeldName: PAnsiChar; Dt: Integer): PTIFFFieldInfo; cdecl; external libtiff6dll name 'TIFFFindFieldInfoByName';
function  TIFFFieldWithTag(Handle: PTIFF; Tag: Cardinal): PTIFFFieldInfo; cdecl; external libtiff6dll name 'TIFFFieldWithTag';
function  TIFFFieldWithName(Handle: PTIFF; FieldName: PAnsiChar): PTIFFFieldInfo; cdecl; external libtiff6dll name 'TIFFFieldWithName';
function  TIFFDataWidth(DataType: Integer): Integer; cdecl; external libtiff6dll name 'TIFFDataWidth';

function  TIFFReadRGBAImage(Handle: PTIFF; RWidth,RHeight: Cardinal; Raster: Pointer; Stop: Integer): Integer; cdecl; external libtiff6dll name 'TIFFReadRGBAImage';
function  TIFFReadRGBAImageOriented(Handle: PTIFF; RWidth,RHeight: Cardinal; Raster: Pointer; Orientation: Integer; Stop: Integer): Integer; cdecl; external libtiff6dll name 'TIFFReadRGBAImageOriented';
function  TIFFReadRGBAStrip(Handle: PTIFF; Row: Cardinal; Raster: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFReadRGBAStrip';
function  TIFFReadRGBATile(Handle: PTIFF; Col,Row: Cardinal; Raster: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFReadRGBATile';
function  TIFFRGBAImageOk(Handle: PTIFF; Emsg: PAnsiChar): Integer; cdecl; external libtiff6dll name 'TIFFRGBAImageOk';
function  TIFFRGBAImageBegin(Img: PTIFFRGBAImage; Handle: PTIFF; Stop: Integer; Emsg: PAnsiChar): Integer; cdecl; external libtiff6dll name 'TIFFRGBAImageBegin';
function  TIFFRGBAImageGet(Img: PTIFFRGBAImage; Raster: Pointer; W,H: Cardinal): Integer; cdecl; external libtiff6dll name 'TIFFRGBAImageGet';
procedure TIFFRGBAImageEnd(Img: PTIFFRGBAImage); cdecl; external libtiff6dll name 'TIFFRGBAImageEnd';

function  TIFFCurrentRow(Handle: PTIFF): Cardinal; cdecl; external libtiff6dll name 'TIFFCurrentRow';

function  TIFFStripSize(Handle: PTIFF): NativeInt; cdecl; external libtiff6dll name 'TIFFStripSize';
function  TIFFRawStripSize(Handle: PTIFF; Strip: Cardinal): NativeInt; cdecl; external libtiff6dll name 'TIFFRawStripSize';
function  TIFFVStripSize(Handle: PTIFF; NRows: Cardinal): NativeInt; cdecl; external libtiff6dll name 'TIFFVStripSize';
function  TIFFDefaultStripSize(Handle: PTIFF; Request: Cardinal): Cardinal; cdecl; external libtiff6dll name 'TIFFDefaultStripSize';
function  TIFFNumberOfStrips(Handle: PTIFF): Cardinal; cdecl; external libtiff6dll name 'TIFFNumberOfStrips';
function  TIFFComputeStrip(Handle: PTIFF; Row: Cardinal; Sample: Word): Cardinal; cdecl; external libtiff6dll name 'TIFFComputeStrip';
function  TIFFReadRawStrip(Handle: PTIFF; Strip: Cardinal; Buf: Pointer; Size: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFReadRawStrip';
function  TIFFReadEncodedStrip(Handle: PTIFF; Strip: Cardinal; Buf: Pointer; Size: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFReadEncodedStrip';
function  TIFFWriteRawStrip(Handle: PTIFF; Strip: Cardinal; Data: Pointer; Cc: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFWriteRawStrip';
function  TIFFWriteEncodedStrip(Handle: PTIFF; Strip: Cardinal; Data: Pointer; Cc: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFWriteEncodedStrip';
function  TIFFCurrentStrip(Handle: PTIFF): Cardinal; cdecl; external libtiff6dll name 'TIFFCurrentStrip';

function  TIFFTileSize(Handle: PTIFF): NativeInt; cdecl; external libtiff6dll name 'TIFFTileSize';
function  TIFFTileRowSize(Handle: PTIFF): NativeInt; cdecl; external libtiff6dll name 'TIFFTileRowSize';
function  TIFFVTileSize(Handle: PTIFF; NRows: Cardinal): NativeInt; cdecl; external libtiff6dll name 'TIFFVTileSize';
procedure TIFFDefaultTileSize(Handle: PTIFF; Tw: PCardinal; Th: PCardinal); cdecl; external libtiff6dll name 'TIFFDefaultTileSize';
function  TIFFNumberOfTiles(Handle: PTIFF): Cardinal; cdecl; external libtiff6dll name 'TIFFNumberOfTiles';
function  TIFFComputeTile(Handle: PTIFF; X,Y,Z: Cardinal; S: Word): Cardinal; cdecl; external libtiff6dll name 'TIFFComputeTile';

// Low-level I/O (compressed or raw buffers)
function  TIFFReadRawTile(Handle: PTIFF; Tile: Cardinal; Buf: Pointer; Size: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFReadRawTile';
function  TIFFReadEncodedTile(Handle: PTIFF; Tile: Cardinal; Buf: Pointer; Size: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFReadEncodedTile';
function  TIFFWriteRawTile(Handle: PTIFF; Tile: Cardinal; Data: Pointer; Cc: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFWriteRawTile';
function  TIFFWriteEncodedTile(Handle: PTIFF; Tile: Cardinal; Data: Pointer; Cc: NativeInt): NativeInt; cdecl; external libtiff6dll name 'TIFFWriteEncodedTile';
function  TIFFCurrentTile(Handle: PTIFF): Cardinal; cdecl; external libtiff6dll name 'TIFFCurrentTile';

//High-level image access (using X, Y pixel coordinates)
function  TIFFReadTile(tif: PTIFF; buf: Pointer; x, y, z: Cardinal; s: Word): NativeInt; cdecl; external libtiff6dll name 'TIFFReadTile';
function  TIFFWriteTile(tif: PTIFF; buf: Pointer; x, y, z: Cardinal; s: Word): NativeInt; cdecl; external libtiff6dll name 'TIFFWriteTile';

function  TIFFScanlineSize(Handle: PTIFF): NativeInt; cdecl; external libtiff6dll name 'TIFFScanlineSize';
function  TIFFRasterScanlineSize(Handle: PTIFF): NAtiveInt; cdecl; external libtiff6dll name 'TIFFRasterScanlineSize';
function  TIFFReadScanline(Handle: PTIFF; Buf: Pointer; Row: Cardinal; Sample: Word): Integer; cdecl; external libtiff6dll name 'TIFFReadScanline';
function  TIFFWriteScanline(Handle: PTIFF; Buf: Pointer; Row: Cardinal; Sample: Word): Integer; cdecl; external libtiff6dll name 'TIFFWriteScanline';

procedure TIFFSetWriteOffset(Handle: PTIFF; Off: UInt64); cdecl; external libtiff6dll name 'TIFFSetWriteOffset';

procedure TIFFSwabShort(Wp: PWord); cdecl; external libtiff6dll name 'TIFFSwabShort';
procedure TIFFSwabLong(Lp: PCardinal); cdecl; external libtiff6dll name 'TIFFSwabLong';
procedure TIFFSwabDouble(Dp: PDouble); cdecl; external libtiff6dll name 'TIFFSwabDouble';
procedure TIFFSwabArrayOfShort(Wp: PWord; N: NativeInt); cdecl; external libtiff6dll name 'TIFFSwabArrayOfShort';
procedure TIFFSwabArrayOfLong(Lp: PCardinal; N: NativeInt); cdecl; external libtiff6dll name 'TIFFSwabArrayOfLong';
procedure TIFFSwabArrayOfDouble(Dp: PDouble; N: NativeInt); cdecl; external libtiff6dll name 'TIFFSwabArrayOfDouble';
procedure TIFFReverseBits(Cp: Pointer; N: NativeInt); cdecl; external libtiff6dll name 'TIFFReverseBits';
function  TIFFGetBitRevTable(Reversed: Integer): Pointer; cdecl; external libtiff6dll name 'TIFFGetBitRevTable';

implementation

var
  FLibTiffDelphiWarningHandler: LibTiffDelphiErrorHandler;
  FLibTiffDelphiErrorHandler: LibTiffDelphiErrorHandler;

function  LibTiffDelphiVersion: AnsiString;
var
  m: AnsiString;
  na,nb: Integer;
begin
  Result:='';
  m:=TIFFGetVersion;
  na:=1;
  while True do
  begin
    nb:=na;
    while nb<=Length(m) do
    begin
      if m[nb]=#10 then break;
      Inc(nb);
    end;
    Result:=Result+System.Copy(m,na,nb-na);
    if nb>Length(m) then break;
    Result:=Result+#13#10;
    na:=nb+1;
  end;
  Result:=Result+#13#10+LibTiffDelphiVersionString;
end;

function sprintfsec(buffer: Pointer; format: Pointer; arguments: Pointer): Integer;
var
  Modifier: Integer;
  Width: Integer;
  m,ma: PByte;
  mb: Boolean;
  n: PByte;
  o: PByte;
  r: PByte;

  procedure Append(const p: AnsiString);
  var
    q: Integer;
  begin
    if Width>Length(p) then
    begin
      if buffer<>nil then
      begin
        for q:=0 to Width-Length(p)-1 do
        begin
          o^:=Ord('0');
          Inc(o);
        end;
      end
      else
        Inc(o,Width-Length(p));
    end;
    if buffer<>nil then CopyMemory(o,PAnsiChar(p),Length(p));
    Inc(o,Length(p));
  end;

begin
  m:=format;
  n:=arguments;
  o:=buffer;
  while True do
  begin
    if m^=0 then break;
    if m^=Ord('%') then
    begin
      ma:=m;
      mb:=True;
      Inc(m);
      Width:=-1;
      Modifier:=0;
      {flags}
      case m^ of
        Ord('-'): mb:=False;
        Ord('+'): mb:=False;
        Ord(' '): mb:=False;
        Ord('#'): mb:=False;
      end;
      if mb then
      begin
        {width}
        case m^ of
          Ord('1')..Ord('9'):
          begin
            Width:=0;
            while True do
            begin
              if (m^<Ord('0')) or (Ord('9')<m^) then break;
              Width:=Width*10+m^-Ord('0');
              Inc(m);
            end;
          end;
          Ord('0'): mb:=False;
          Ord('*'): mb:=False;
        end;
      end;
      if mb then
      begin
        {prec}
        case m^ of
          Ord('.'): mb:=False;
        end;
      end;
      if mb then
      begin
        {modifier}
        case m^ of
          Ord('F'): mb:=False;
          Ord('N'): mb:=False;
          Ord('h'): mb:=False;
          Ord('l'):
          begin
            Modifier:=4;
            Inc(m);
          end;
          Ord('L'): mb:=False;
        end;
      end;
      if mb then
      begin
        {type}
        case m^ of
          Ord('d'):
          begin
            case Modifier of
              0:
              begin
                Append(IntToStr(PInteger(n)^));
                Inc(m);
                Inc(n,SizeOf(Integer));
              end;
            else
              mb:=False;
            end;
          end;
          Ord('i'): mb:=False;
          Ord('o'): mb:=False;
          Ord('u'):
          begin
            case Modifier of
              0,4:
              begin
                Append(IntToStr(PCardinal(n)^));
                Inc(m);
                Inc(n,SizeOf(Cardinal));
              end;
            else
              mb:=False;
            end;
          end;
          Ord('x'):
          begin
            case Modifier of
              0,4:
              begin
                Append(IntToHex(PCardinal(n)^,8));
                Inc(m);
                Inc(n,SizeOf(Cardinal));
              end;
            else
              mb:=False;
            end;
          end;
          Ord('X'): mb:=False;
          Ord('f'): mb:=False;
          Ord('e'): mb:=False;
          Ord('g'):
          begin
            case Modifier of
              0:
              begin
                Append(FloatToStr(PSingle(n)^));
                Inc(m);
                Inc(n,SizeOf(Single));
              end;
            else
              mb:=False;
            end;
          end;
          Ord('E'): mb:=False;
          Ord('G'): mb:=False;
          Ord('c'): mb:=False;
          Ord('s'):
          begin
            r:=PPointer(n)^;
            while r^<>0 do
            begin
              if buffer<>nil then o^:=r^;
              Inc(o);
              Inc(r);
            end;
            Inc(n,SizeOf(Pointer));
            Inc(m);
          end;
          Ord('%'): mb:=False;
          Ord('n'): mb:=False;
          Ord('p'): mb:=False;
        else
          raise Exception.Create('LibDelphi');
        end;
      end;
      if mb=False then
      begin
        m:=ma;
        if buffer<>nil then o^:=m^;
        Inc(o);
        Inc(m);
      end;
    end
    else if m^=10 then
    begin
      if buffer<>nil then o^:=13;
      Inc(o);
      if buffer<>nil then o^:=10;
      Inc(o);
      Inc(m);
    end
    else
    begin
      if buffer<>nil then o^:=m^;
      Inc(o);
      Inc(m);
    end;
  end;
  if buffer<>nil then o^:=0;
  Inc(o);
  Result:=(Cardinal(o)-Cardinal(buffer));
end;

procedure LibTiffDelphiWarningThrp(a: Pointer; b: Pointer; c: Pointer); cdecl;
var
  m: Integer;
  n: AnsiString;
begin
  if @FLibTiffDelphiWarningHandler<>nil then
  begin
    m:=sprintfsec(nil,b,@c);
    SetLength(n,m);
    sprintfsec(Pointer(n),b,@c);
    FLibTiffDelphiWarningHandler(PAnsiChar(a),n);
  end;
end;

procedure LibTiffDelphiErrorThrp(a: Pointer; b: Pointer; c: Pointer); cdecl;
var
  m: Integer;
  n: AnsiString;
begin
  if @FLibTiffDelphiErrorHandler<>nil then
  begin
    m:=sprintfsec(nil,b,@c);
    SetLength(n,m);
    sprintfsec(Pointer(n),b,@c);
    FLibTiffDelphiErrorHandler(PAnsiChar(a),n);
  end;
end;

function LibTiffDelphiGetWarningHandler: LibTiffDelphiErrorHandler;
begin
  Result:=FLibTiffDelphiWarningHandler;
end;

function LibTiffDelphiSetWarningHandler(Handler: LibTiffDelphiErrorHandler): LibTiffDelphiErrorHandler;
begin
  Result:=FLibTiffDelphiWarningHandler;
  FLibTiffDelphiWarningHandler:=Handler;
end;

function LibTiffDelphiGetErrorHandler: LibTiffDelphiErrorHandler;
begin
  Result:=FLibTiffDelphiErrorHandler;
end;

function LibTiffDelphiSetErrorHandler(Handler: LibTiffDelphiErrorHandler): LibTiffDelphiErrorHandler;
begin
  Result:=FLibTiffDelphiErrorHandler;
  FLibTiffDelphiErrorHandler:=Handler;
end;

procedure _TIFFSwab16BitData(tif: Pointer; buf: Pointer; cc: NativeInt); cdecl; external libtiff6dll name '_TIFFSwab16BitData';
procedure _TIFFSwab24BitData(tif: pointer; buf: pointer; cc: NativeInt); cdecl; external libtiff6dll name '_TIFFSwab24BitData'; //DW 3.8.2
procedure _TIFFSwab32BitData(tif: Pointer; buf: Pointer; cc: NativeInt); cdecl; external libtiff6dll name '_TIFFSwab32BitData';
procedure _TIFFSwab64BitData(tif: Pointer; buf: Pointer; cc: NativeInt); cdecl; external libtiff6dll name '_TIFFSwab64BitData';
procedure _TIFFNoPostDecode(tif: Pointer; buf: Pointer; cc: NativeInt); cdecl; external libtiff6dll name '_TIFFNoPostDecode';
function TIFFFillTile(tif: Pointer; tile: longword):integer; cdecl; external libtiff6dll name 'TIFFFillTile'; //DW 3.8.2
function  _TIFFSampleToTagType(tif: Pointer): Integer; cdecl; external libtiff6dll name '_TIFFSampleToTagType';
procedure _TIFFSetupFieldInfo(tif: Pointer); cdecl; external libtiff6dll name '_TIFFSetupFieldInfo';
function  _TIFFCreateAnonFieldInfo(tif: Pointer; tag: Cardinal; field_type: Integer): Pointer; cdecl; external libtiff6dll name '_TIFFCreateAnonFieldInfo';
function _TIFFGetExifFieldInfo(size : plongint):pointer; cdecl; external libtiff6dll name '_TIFFGetExifFieldInfo'; //DW 3.8.2
function _TIFFDataSize(TIFFDataType : longint):longint; cdecl; external libtiff6dll name '_TIFFDataSize'; //DW 3.8.2
function _TIFFGetFieldInfo(size : plongint):pointer; cdecl; external libtiff6dll name '_TIFFGetFieldInfo'; //DW 3.8.2
function _TIFFMergeFieldInfo(tif: Pointer; fieldinfo : Pointer; n : Integer):Integer; cdecl; external libtiff6dll name '_TIFFMergeFieldInfo'; //DW 3.9.1
function  TIFFFlushData1(tif: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFFlushData1';
function  TIFFSetupStrips(tif: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFSetupStrips';
function  TIFFInitDumpMode(tif: Pointer; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitDumpMode';
function  TIFFSetCompressionScheme(tif: Pointer; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFSetCompressionScheme';
procedure _TIFFSetDefaultCompressionState(tif: Pointer); cdecl; external libtiff6dll name '_TIFFSetDefaultCompressionState';
procedure TIFFFreeDirectory(tif: Pointer); cdecl; external libtiff6dll name 'TIFFFreeDirectory';
function  TIFFDefaultDirectory(tif: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFDefaultDirectory';
function  TIFFReassignTagToIgnore(task: Integer; TIFFtagID: Integer): Integer; cdecl; external libtiff6dll name 'TIFFReassignTagToIgnore';
procedure _TIFFsetString(cpp: Pointer; cp: Pointer); cdecl; external libtiff6dll name '_TIFFsetString';
procedure _TIFFsetByteArray(vpp: Pointer; vp: Pointer; n: Integer); cdecl; external libtiff6dll name '_TIFFsetByteArray';
function  TIFFVGetFieldDefaulted(tif: Pointer; tag: Cardinal; ap: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFVGetFieldDefaulted';
procedure TIFFCIELabToXYZ(cielab: Pointer; l: Cardinal; a: Integer; b: Integer; X: Pointer; Y: Pointer; Z: Pointer); cdecl; external libtiff6dll name 'TIFFCIELabToXYZ';
procedure TIFFXYZToRGB(cielab: Pointer; X: Single; Y: Single; Z: Single; r: Pointer; g: Pointer; b: Pointer); cdecl; external libtiff6dll name 'TIFFXYZToRGB';
procedure TIFFYCbCrtoRGB(ycbcr: Pointer; Y: Cardinal; Cb: Integer; Cr: Integer; r: Pointer; g: Pointer; b: Pointer); cdecl; external libtiff6dll name 'TIFFYCbCrtoRGB';
function  TIFFYCbCrToRGBInit(ycbcr: Pointer; luma: Pointer; refBlackWhite: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFYCbCrToRGBInit';
function  TIFFCIELabToRGBInit(cielab: Pointer; display: Pointer; refWhite: Pointer): Integer; cdecl; external libtiff6dll name 'TIFFCIELabToRGBInit';
function  _TIFFgetMode(mode: PAnsiChar; module: PAnsiChar): Integer; cdecl; external libtiff6dll name '_TIFFgetMode';
function  TIFFPredictorInit(tif: PTIFF): Integer; cdecl; external libtiff6dll name 'TIFFPredictorInit';
function  TIFFPredictorCleanup(tif: PTIFF):integer; cdecl; external libtiff6dll name 'TIFFPredictorCleanup'; //DW 3.8.2
function  _TIFFDefaultStripSize(tif: Pointer; s: Cardinal): Cardinal; cdecl; external libtiff6dll name '_TIFFDefaultStripSize';
function  TIFFOldScanlineSize(tif: Pointer):Cardinal; cdecl; external libtiff6dll name 'TIFFOldScanlineSize'; //DW 3.9.1
function  TIFFCheckTile(tif: Pointer; x: Cardinal; y: Cardinal; z: Cardinal; s: Word): Integer; cdecl; external libtiff6dll name 'TIFFCheckTile';
procedure _TIFFDefaultTileSize(tif: Pointer; tw: Pointer; th: Pointer); cdecl; external libtiff6dll name '_TIFFDefaultTileSize';
function  TIFFInitCCITTRLE(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitCCITTRLE';
function  TIFFInitCCITTRLEW(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitCCITTRLEW';
function  TIFFInitCCITTFax3(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitCCITTFax3';
function  TIFFInitCCITTFax4(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitCCITTFax4';
function  TIFFInitJPEG(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitJPEG';
function  TIFFFillStrip(tif : PTIFF; Len : longword): integer; cdecl; external libtiff6dll name 'TIFFFillStrip'; //DW 3.8.2
function  TIFFInitSGILog(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitSGILog';
function  TIFFInitLZW(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitLZW';
function  TIFFInitNeXT(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitNeXT';
function  TIFFInitPackBits(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitPackBits';
function  TIFFInitPixarLog(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitPixarLog';
function  TIFFInitThunderScan(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitThunderScan';
function  TIFFInitZIP(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'TIFFInitZIP';
function NotConfigured(tif: PTIFF; scheme: Integer): Integer; cdecl; external libtiff6dll name 'NotConfigured';

const

  _TIFFBuiltinCODECS: array[0..17] of TIFFCodec = (
       (name:'None'; scheme: COMPRESSION_NONE; init: TIFFInitDumpMode),
       (name:'LZW'; scheme: COMPRESSION_LZW; init: TIFFInitLZW),
       (name:'PackBits'; scheme: COMPRESSION_PACKBITS; init: TIFFInitPackBits),
       (name:'ThunderScan'; scheme: COMPRESSION_THUNDERSCAN; init: TIFFInitThunderScan),
       (name:'NeXT'; scheme: COMPRESSION_NEXT; init: TIFFInitNeXT),
       (name:'JPEG'; scheme: COMPRESSION_JPEG; init: TIFFInitJPEG),
       (name:'Old-style JPEG'; scheme: COMPRESSION_OJPEG; init: NotConfigured),
       (name:'CCITT RLE'; scheme: COMPRESSION_CCITTRLE; init: TIFFInitCCITTRLE),
       (name:'CCITT RLE/W'; scheme: COMPRESSION_CCITTRLEW; init: TIFFInitCCITTRLEW),
       (name:'CCITT Group 3'; scheme: COMPRESSION_CCITTFAX3; init: TIFFInitCCITTFax3),
       (name:'CCITT Group 4'; scheme: COMPRESSION_CCITTFAX4; init: TIFFInitCCITTFax4),
       (name:'ISO JBIG'; scheme: COMPRESSION_JBIG; init: NotConfigured),
       (name:'Deflate'; scheme: COMPRESSION_DEFLATE; init: TIFFInitZIP),
       (name:'AdobeDeflate'; scheme: COMPRESSION_ADOBE_DEFLATE; init: TIFFInitZIP),
       (name:'PixarLog'; scheme: COMPRESSION_PIXARLOG; init: TIFFInitPixarLog),
       (name:'SGILog'; scheme: COMPRESSION_SGILOG; init: TIFFInitSGILog),
       (name:'SGILog24'; scheme: COMPRESSION_SGILOG24; init: TIFFInitSGILog),
       (name:nil; scheme:0; init:nil));

function  TIFFFileReadProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl; forward;
function  TIFFFileWriteProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl; forward;
function  TIFFFileSizeProc(Fd: THandle): UInt64; cdecl; forward;
function  TIFFFileSeekProc(Fd: THandle; Off: UInt64; Whence: Integer): UInt64; cdecl; forward;
function  TIFFFileCloseProc(Fd: THandle): Integer; cdecl; forward;
function  TIFFStreamReadProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl; forward;
function  TIFFStreamWriteProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl; forward;
function  TIFFStreamSizeProc(Fd: THandle): UInt64; cdecl; forward;
function  TIFFStreamSeekProc(Fd: THandle; Off: UInt64; Whence: Integer): UInt64; cdecl; forward;
function  TIFFStreamCloseProc(Fd: THandle): Integer; cdecl; forward;
function TIFFNoMapProc(Fd: THandle; PBase: PPointer; PSize: PUInt64): Integer; cdecl; forward;
procedure TIFFNoUnmapProc(Fd: THandle; Base: Pointer; Size: UInt64); cdecl; forward;

function TIFFFileCloseProc(Fd: THandle): Integer; cdecl;
begin
  if CloseHandle(Fd)=True then
    Result:=0
  else
    Result:=-1;
end;

function TIFFFileSizeProc(Fd: THandle): UInt64; cdecl;
begin
  Result:=GetFileSize(Fd,nil);
end;

function TIFFFileSeekProc(Fd: THandle; Off: UInt64; Whence: Integer): UInt64; cdecl;
const
  SEEK_SET = 0;
  SEEK_CUR = 1;
  SEEK_END = 2;
var
  MoveMethod: Cardinal;
  NewOffset: Int64; // SetFilePointerEx requires a signed Int64 for internal offset calculations
begin
  case Whence of
    SEEK_SET: MoveMethod := FILE_BEGIN;
    SEEK_CUR: MoveMethod := FILE_CURRENT;
    SEEK_END: MoveMethod := FILE_END;
  else
    MoveMethod := FILE_BEGIN;
  end;

// Using SetFilePointerEx for full 64-bit range.
// Off cast to Int64 for Windows API compatibility.
  if SetFilePointerEx(Fd, Int64(Off), @NewOffset, MoveMethod) then
    Result := UInt64(NewOffset)
  else
    Result := UInt64($FFFFFFFFFFFFFFFF); // Standard (toff_t)-1 error
end;

function TIFFFileReadProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl;
// WARNING: Size is 64-bit, but Windows ReadFile uses a 32-bit DWORD (max 4GB). Added check to prevent overflow
var
  m: Cardinal;
begin
  // If size is > 4GB, returns with error
  if (Size > $FFFFFFFF) then
  begin
    Result := -1; 
    Exit;
  end;  

  if ReadFile(Fd,Buffer^,Cardinal(Size),m,nil)=False then
    Result:=-1
  else
    Result:=m;
end;

function TIFFFileWriteProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl;
// WARNING: Size is 64-bit, but WriteFile uses a 32-bit DWORD (max 4GB). Added check to prevent overflow.
var
  m: Cardinal;
begin
  if (Size > $FFFFFFFF) then
  begin
    Result := -1; 
    Exit;
  end;  

  if WriteFile(Fd,Buffer^,Cardinal(Size),m,nil)=False then
    Result:=-1
  else
    Result:=m;
end;

function TIFFStreamCloseProc(Fd: THandle): Integer; cdecl;
begin
  Result:=0;
end;

function TIFFStreamSizeProc(Fd: THandle): UInt64; cdecl;
begin
  try
    Result:=TStream(Fd).Size;
  except
    Result:=0;
  end;
end;

function TIFFStreamSeekProc(Fd: THandle; Off: UInt64; Whence: Integer): UInt64; cdecl;
const
  SEEK_SET = 0;
  SEEK_CUR = 1;
  SEEK_END = 2;
  TIFF_INVALID_OFF = UInt64(-1);  // Standard (toff_t)-1 error
var
  MoveMethod: Word;
begin
  if Off = TIFF_INVALID_OFF then
  begin
    Result := TIFF_INVALID_OFF;
    exit;
  end;

  case Whence of
    SEEK_SET: MoveMethod := soFromBeginning;
    SEEK_CUR: MoveMethod := soFromCurrent;
    SEEK_END: MoveMethod := soFromEnd;
  else
    MoveMethod := soFromBeginning;
  end;

  try
    // In 64-bit Delphi, TStream.Seek accepts Int64; UInt64 is handled via implicit casting.
    Result := UInt64(TStream(Fd).Seek(Int64(Off), MoveMethod));
  except
    Result := TIFF_INVALID_OFF;
  end;
end;

function TIFFStreamReadProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl;
begin
  try
    Result:=TStream(Fd).Read(Buffer^,Size);
  except
    Result:=0;
  end;
end;

function TIFFStreamWriteProc(Fd: THandle; Buffer: Pointer; Size: NativeInt): NativeInt; cdecl;
begin
  try
    Result:=TStream(Fd).Write(Buffer^,Size);
  except
    Result:=0;
  end;
end;

function TIFFNoMapProc(Fd: THandle; PBase: PPointer; PSize: PUInt64): Integer; cdecl;
begin
  Result := 0;
end;

procedure TIFFNoUnmapProc(Fd: THandle; Base: Pointer; Size: UInt64); cdecl;
begin
end;

function TIFFOpenFile(const Name: PAnsiChar; const Mode: PAnsiChar): PTIFF;
const
  Module: AnsiString = 'TIFFOpen';
  O_RDONLY = 0;
  O_WRONLY = 1;
  O_RDWR = 2;
  O_CREAT = $0100;
  O_TRUNC = $0200;
var
  m: Integer;
  DesiredAccess: Cardinal;
  CreateDisposition: Cardinal;
  FlagsAndAttributes: Cardinal;
  fd: THandle;
begin
  m:=_TIFFgetMode(PAnsiChar(Mode),PAnsiChar(Module));
  if m=o_RDONLY then
    DesiredAccess:=GENERIC_READ
  else
    DesiredAccess:=(GENERIC_READ or GENERIC_WRITE);
  case m of
    O_RDONLY: CreateDisposition:=OPEN_EXISTING;
    O_RDWR: CreateDisposition:=OPEN_ALWAYS;
    (O_RDWR or O_CREAT): CreateDisposition:=OPEN_ALWAYS;
    (O_RDWR or O_TRUNC): CreateDisposition:=CREATE_ALWAYS;
    (O_RDWR or O_CREAT or O_TRUNC): CreateDisposition:=CREATE_ALWAYS;
  else
    Result:=nil;
    exit;
  end;
  if m=O_RDONLY then
    FlagsAndAttributes:=FILE_ATTRIBUTE_READONLY
  else
    FlagsAndAttributes:=FILE_ATTRIBUTE_NORMAL;
  fd:=CreateFileA(PAnsiChar(Name),DesiredAccess,FILE_SHARE_READ,nil,CreateDisposition,FlagsAndAttributes,0);
  if fd=INVALID_HANDLE_VALUE then
  begin
    TiffError(PAnsiChar(Module),PAnsiChar('%s: Cannot open'),PAnsiChar(Name));
    Result:=nil;
    exit;
  end;
  Result:=TIFFClientOpen(PAnsiChar(Name),PAnsiChar(Mode),fd,@TIFFFileReadProc,@TIFFFileWriteProc,@TIFFFileSeekProc,@TIFFFileCloseProc,
              @TIFFFileSizeProc,@TIFFNoMapProc,@TIFFNoUnmapProc);
  if Result<>nil then
    TIFFSetFileno(Result,fd)
  else
    CloseHandle(fd);
end;

function TIFFOpenStream(const Stream: TStream; const Mode: PAnsiChar): PTIFF;
var
  m: AnsiString;
begin
  m:='Stream';
  Result:=TIFFClientOpen(PAnsiChar(m),PAnsiChar(Mode),Cardinal(Stream),@TIFFStreamReadProc,@TIFFStreamWriteProc,@TIFFStreamSeekProc,@TIFFStreamCloseProc,
              @TIFFStreamSizeProc,@TIFFNoMapProc,@TIFFNoUnmapProc);
  if Result<>nil then TIFFSetFileno(Result,Cardinal(Stream));
end;

initialization
  TIFFSetWarningHandler(LibTiffDelphiWarningThrp);
  TIFFSetErrorHandler(LibTiffDelphiErrorThrp);
end.
