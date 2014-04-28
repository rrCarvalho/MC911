%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.h"
%}

WORD		(\\.|[^' \[\]\|\t\r\n=":#\*])*
STRING		[a-zA-Z0-9à-úÀ-Ú;()\-\S][a-zA-Z0-9à-úÀ-Ú;()\-\S.:]*
INTEGER		[0-9]+
NAME		[a-zA-Z][a-zA-Z0-9_]*
WHITESPACE	[ \t\r\n]+
ANY_CHAR	.

%option case-insensitive

%x comment lstring

%%



"//" {
	BEGIN(comment);
}
<comment>.*
<comment>[\r\n|\n|\r] {
	BEGIN(INITIAL);
}



\" {
	BEGIN(lstring);
	return T_LSTR;
}


<lstring>[ \t] {
	yylval.sval = strdup(" ");
	return T_WORD;
}
<lstring>[\r\n] {
	yylval.sval = strdup("\n");
	return T_WORD;
}


<lstring>\* {
	return T_ULIST;
}
<lstring># {
	return T_OLIST;
}


<lstring>\[\[\[ {
	return T_YT_0;
}
<lstring>\]\]\] {
	return T_YT_1;
}
<lstring>\[\[ {
	return T_IMG_0;
}
<lstring>\]\] {
	return T_IMG_1;
}
<lstring>\[ {
	return T_LINK_0;
}
<lstring>\] {
	return T_LINK_1;
}
<lstring>\| {
	return '|';
}


<lstring>==== {
	return T_H1;
}
<lstring>=== {
	return T_H2;
}
<lstring>== {
	return T_H3;
}
<lstring>= {
	yylval.sval = strdup("=");
	return T_WORD;
}


<lstring>: {
	return T_NBSP;
}
<lstring>{STRING}: {
	yylval.sval = (char*)strdup(yytext);
	return T_WORD;
}


<lstring>'''' {
	return T_BOLDITALIC;
}
<lstring>''' {
	return T_BOLD;
}
<lstring>'' {
	return T_ITALIC;
}
<lstring>' {
	yylval.sval = (char*)strdup(yytext);
	return T_WORD;
}


<lstring>{WORD} {
	yylval.sval = (char*)strdup(yytext);
	return T_WORD;
}


<lstring>\" {
	BEGIN(INITIAL);
	return T_LSTR;
}



"newspaper"		{return T_NEWSPAPER;}
"title"			{return T_TITLE;}
"date"			{return T_DATE;}
"abstract"		{return T_ABSTRACT;}
"text"			{return T_TEXT;}
"source"		{return T_SOURCE;}
"image"			{return T_IMAGE;}
"author"		{return T_AUTHOR;}
"structure"		{return T_STRUCTURE;}
"show"			{return T_SHOW;}
"col"			{return T_COL;}

"{"		{return '{';}
"}"		{return '}';}
"="		{return '=';}
","		{return ',';}



{WHITESPACE}		



{INTEGER} {
	yylval.ival = atoi(yytext);
	return T_INTEGER;
}
{NAME} {
	yylval.sval = (char*)strdup(yytext);
	return T_NAME;
}


{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}
