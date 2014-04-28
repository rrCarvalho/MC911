%{
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


#define MAX_ARTICLES 1024
#define FRAME_WIDTH 1024



// === type definitions ======================================================

typedef struct article_item {
	char *name;
	int cols;
	int show[7];
	char *title;	// 0
	char *author;	// 1
	char *date;		// 2
	char *source;	// 3
	char *image;	// 4
	char *abstract;	// 5
	char *text;		// 6
} article_t;



// === global variables ======================================================

static char *title;
static char *date;
static int columns;

static char *articles_names;
static int article_counter = 0;

static article_t articles[MAX_ARTICLES];
static article_t article_tmp;

static int ulist_flag = 0;
static int ulist_curr = 0;
static int olist_flag = 0;
static int olist_curr = 0;

static int i_tmp = 0;



// === function's pragmas ====================================================

char *concat(int count, ...);

void readStructure(int quantity, char *list);
void clearArticleTmp();
void setupArticle(char *name);

char *replaceQuot(char *in);

char *listLine(int type);
char *listCloser(char * input);

char *imageCode(char *address, char *caption);
char *videoCode(char *vnum);

char *generateTextPage(int pos);
void generateHeader(FILE *fd);
void generateFooter(FILE *fd);
void generateAbsField(FILE *fd, int pos, int field);
void generateAbstract(FILE *fd, int pos, char *filename);
void generateMainPage();

int findArticlePos(char *listed_name);
int isArticleValid(int pos);

void testPrintAll();
void testPrintTmp();


%}
 
%union{
	int  ival;
	char *sval;
}

%token T_INTEGER
%token T_WORD
%token T_NAME

%token T_NEWSPAPER
%token T_TITLE
%token T_DATE
%token T_ABSTRACT
%token T_TEXT
%token T_SOURCE
%token T_IMAGE
%token T_AUTHOR
%token T_STRUCTURE
%token T_SHOW
%token T_COL

%token T_LSTR
%token T_CRNF
%token T_ITALIC
%token T_BOLD
%token T_BOLDITALIC
%token T_H1
%token T_H2
%token T_H3
%token T_LINK_0
%token T_LINK_1
%token T_IMG_0
%token T_IMG_1
%token T_YT_0
%token T_YT_1

%token T_ULIST
%token T_OLIST

%token T_NBSP

%type <ival> T_INTEGER
%type <sval> T_WORD T_NAME

%type <sval> newspaper_required title date articles_shown
%type <sval> articles_list article_params article_item
%type <ival> tolkien

%type <sval> author source image abstract text
%type <sval> phrases sphrase fphrase nphrase nbsp
%type <ival> ulist olist

%start newspaper
%initial-action {clearArticleTmp();}

%error-verbose
 
%%

newspaper
	: T_NEWSPAPER '{' newspaper_required articles_list '}'	{generateMainPage();}
	;

newspaper_required
	: title date structure	{title = strdup($1);date = strdup($2);}
	| title structure date	{title = strdup($1);date = strdup($3);}
	| date title structure	{title = strdup($2);date = strdup($1);}
	| date structure title	{title = strdup($3);date = strdup($1);}
	| structure title date	{title = strdup($2);date = strdup($3);}
	| structure date title	{title = strdup($3);date = strdup($2);}
	;

structure
	: T_STRUCTURE '{' T_COL '=' T_INTEGER T_SHOW '=' articles_shown '}'	{readStructure($5, $8);}
	| T_STRUCTURE '{' T_SHOW '=' articles_shown T_COL '=' T_INTEGER '}'	{readStructure($8, $5);}
	;

 articles_shown
	: 							{$$ = NULL;}
	| T_NAME					{$$ = $1;}
	| articles_shown ',' T_NAME	{$$ = concat(3, $1, ",", $3);}
	;

articles_list
	: article_item
	| articles_list article_item
	;

article_item
	: T_NAME '{' article_params_list article_structure '}'	{setupArticle($1);clearArticleTmp();}
	;

article_params_list
	: article_params
	| article_params_list article_params
	;

article_params
	: title			{article_tmp.title = strdup($1);}
	| author		{article_tmp.author = strdup($1);}
	| date			{article_tmp.date = strdup($1);}
	| source		{article_tmp.source = strdup($1);}
	| image			{article_tmp.image = strdup($1);}
	| abstract		{article_tmp.abstract = strdup($1);}
	| text			{article_tmp.text = strdup($1);article_tmp.show[6] = 6;}
	;

article_structure
	: T_STRUCTURE '{' T_COL '=' T_INTEGER T_SHOW '=' fields_shown '}'	{article_tmp.cols = $5; i_tmp = 0;}
	;

fields_shown
	: tolkien						{article_tmp.show[$1] = i_tmp++;}
	| fields_shown ',' tolkien		{article_tmp.show[$3] = i_tmp++;}
	;

tolkien
	: T_TITLE		{$$ = 0;}
	| T_AUTHOR		{$$ = 1;}
	| T_DATE		{$$ = 2;}
	| T_SOURCE		{$$ = 3;}
	| T_IMAGE		{$$ = 4;}
	| T_ABSTRACT	{$$ = 5;}
	;

title
	: T_TITLE '=' T_LSTR phrases T_LSTR			{$$ = $4;}
	;

date
	: T_DATE '=' T_LSTR phrases T_LSTR			{$$ = $4;}
	;

author
	: T_AUTHOR '=' T_LSTR phrases T_LSTR		{$$ = $4;}
	;

source
	: T_SOURCE '=' T_LSTR phrases T_LSTR		{$$ = $4;}
	;

image
	: T_IMAGE '=' T_LSTR nphrase T_LSTR			{$$ = $4;}
	;

abstract
	: T_ABSTRACT '=' T_LSTR phrases T_LSTR		{$$ = $4;}
	;

text
	: T_TEXT '=' T_LSTR phrases T_LSTR			{$$ = $4;}
	;

phrases
	: sphrase phrases		{$$ = concat(2, $1, $2);}
	| fphrase phrases		{$$ = concat(2, $1, $2);}
	| T_WORD				{$$ = concat(2, listCloser($1), replaceQuot($1));}
	;

sphrase
	: T_WORD				{$$ = concat(2, listCloser($1), replaceQuot($1));}
	| nbsp					{$$ = concat(2, "</p><p>", $1);}
	| ulist					{$$ = listLine(0);}
	| olist					{$$ = listLine(1);}
	;

ulist
	: T_ULIST ulist 		{ulist_curr++;}
	| T_ULIST				{ulist_curr = 1;}
	;


olist
	: T_OLIST olist 		{olist_curr++;}
	| T_OLIST				{olist_curr = 1;}
	;

nbsp
	: T_NBSP nbsp			{$$ = concat(2, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", $2);}
	| T_NBSP				{$$ = concat(1, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");}
	;

fphrase
	: T_ITALIC nphrase T_ITALIC				{$$ = concat(3, "<i>", $2, "</i>");}
	| T_BOLD nphrase T_BOLD					{$$ = concat(3, "<b>", $2, "</b>");}
	| T_BOLDITALIC nphrase T_BOLDITALIC		{$$ = concat(3, "<b><i>", $2, "</i></b>");}
	| T_H1 nphrase T_H1						{$$ = concat(3, "</p><h1>", $2, "</h1><p>");}
	| T_H2 nphrase T_H2						{$$ = concat(3, "</p><h2>", $2, "</h2><p>");}
	| T_H3 nphrase T_H3						{$$ = concat(3, "</p><h3>", $2, "</h3><p>");}
	| T_LINK_0 nphrase '|' nphrase T_LINK_1	{$$ = concat(5, "<a href=\"", $2, "\">", $4, "</a>");}
	| T_LINK_0 nphrase T_LINK_1				{$$ = concat(5, "<a href=\"", $2, "\">", $2, "</a>");}
	| T_IMG_0 nphrase '|' nphrase T_IMG_1	{$$ = imageCode($2, $4);}
	| T_YT_0 nphrase T_YT_1					{$$ = videoCode($2);}
	;

nphrase
	: T_WORD nphrase	{$$ = concat(2, replaceQuot($1), $2);}
	| T_WORD			{$$ = replaceQuot($1);}
	;

%%

char* concat(int count, ...)
{
    va_list ap;
    int len = 1, i;

    va_start(ap, count);
    for(i=0 ; i<count ; i++)
        len += strlen(va_arg(ap, char*));
    va_end(ap);

    char *result = (char*) calloc(sizeof(char),len);
    int pos = 0;

    // Actually concatenate strings
    va_start(ap, count);
    for(i=0 ; i<count ; i++)
    {
        char *s = va_arg(ap, char*);
        strcpy(result+pos, s);
        pos += strlen(s);
    }
    va_end(ap);

    return result;
}



int yyerror(const char* errmsg)
{
	printf("\n*** Erro: %s\n", errmsg);
}
 
int yywrap(void) { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}



// === input collection functions ============================================

void readStructure(int quantity, char *list)
/* desc		:	Setup the information onthe newspaper structure.
 *
 * params	:	1.	An integer with the quantity of columns per page.
 *				2.	A string with the articles that will be listed.
 *
 * output	:	None. (Set values to global variables.)
 */
{
	columns = quantity;
	articles_names = (char*)malloc(1);
	if (list) {
		articles_names = concat(2, articles_names, list);
	}
}



void clearArticleTmp()
/* desc		:	Clear the temporary data structure used to store articles'
 *				information.
 *
 * params	:	None.
 *
 * output	:	None.
 */
{
	int i;

	article_tmp.name		= NULL;
	article_tmp.cols		= 0;
	for (i = 0; i < 7; i++) {
		article_tmp.show[i] = -1;
	}
	article_tmp.title		= NULL;
	article_tmp.author		= NULL;
	article_tmp.date		= NULL;
	article_tmp.source		= NULL;
	article_tmp.image		= NULL;
	article_tmp.abstract	= NULL;
	article_tmp.text		= NULL;
}



void setupArticle(char *name)
/* desc		:	Setup the temporary data on the article being parsed into the
 *				permanent articles' vector.
 *
 * params	:	1.	A string with the name of the article.
 *
 * output	:	None. (Set values to global variables.)
 */
{
	char *name_lc;
	int i, len;

	name_lc = strdup(name);
	len = strlen(name);
	for (i = 0; i < len; i++) {
		name_lc[i] = (char)tolower(name_lc[i]);
	}

	article_tmp.name = strdup(name_lc);
	articles[article_counter] = article_tmp;
	article_counter++;

	free(name_lc);
}



// === on-the-fly character replacement functions ============================

char *replaceQuot(char *in)
/* desc		:	Searches the input string for an escaped double quote and
 * 				replaces it with &quot;.
 *
 * params	:	1.	A string with one T_WORD or a collection of T_WORDs.
 *
 * output	:	A string with the replacement executed, if necessary.
 */
{
	char *out, *tmp, *quot;
	int c, i;
	size_t len;

	quot = strdup("&quot;");

	len = strlen(in);

	i = 0;
	c = 0;
	while (i < len) {
		if (in[i] == '\\' && in[i+1] == '\"') {
			c++;
		}
		i++;
	}

	if (c > 0) {
		if (in[0] == '\\' && in[1] == '\"') {
			tmp = strtok(in, "\\\"");
			if (tmp != NULL) {
				out = concat(2, quot, tmp);
			}
			else {
				out = concat(1, quot);
			}
			c--;
			while (c > 0) {
				tmp = strtok(NULL, "\\\"");
				if (tmp != NULL) {
					out = concat(3, out, quot, tmp);
				}
				else {
					out = concat(2, out, quot);
				}
				c--;
			}
		}
		else {
			tmp = strtok(in, "\\\"");
			if (tmp != NULL) {
				out = concat(2, tmp, quot);
			}
			else {
				out = concat(1, quot);
			}
			c--;
			while (c > 0) {
				tmp = strtok(NULL, "\\\"");
				out = concat(3, out, tmp, quot);
				c--;
			}
			tmp = strtok(NULL, "\\\"");
			if (tmp != NULL) {
				out = concat(2, out, tmp);
			}
		}
	}
	else {
		out = strdup(in);
	}

	return out;
}



// === (un)ordered lists' functions ==========================================

char *listLine(int type)
/* desc		:	Outputs html code for each line in a list, either open tags or
 * 				close tags for closing levels, and updates the global state of
 * 				the lists flags.
 *
 * params	:	1.	An integer with the type of list: 0 for an unordered list
 * 					and 1 for an ordered list.
 *
 * output	:	A string with the html code for lists.
 */
{
	char *out;
	int i, dif;

	out = concat(1, "");

	// unordered lists
	if (type == 0) {
		// calculates how many levels were opened or closed
		dif = ulist_flag - ulist_curr;
		// opens as many levels as necessary
		if (dif < 0) {
			for (i = 0; i < abs(dif); i++) {
				out = concat(2, out, "<ul>");
			}
			ulist_flag += abs(dif);
		}
		// closes as many levels as necessary
		else if (dif > 0) {
			for (i = 0; i < abs(dif); i++) {
				out = concat(2, out, "</ul>");
			}
			ulist_flag -= dif;
		}
	}
	else if (type == 1) {
		// calculates how many levels were opened or closed
		dif = olist_flag - olist_curr;
		// opens as many levels as necessary
		if (dif < 0) {
			for (i = 0; i < abs(dif); i++) {
				out = concat(2, out, "<ol>");
			}
			olist_flag += abs(dif);
		}
		// closes as many levels as necessary
		else if (dif > 0) {
			for (i = 0; i < abs(dif); i++) {
				out = concat(2, out, "</ol>");
			}
			olist_flag -= dif;
		}
	}
	// opens a list item
	out = concat(2, out, "<li>");

	return out;
}



char *listCloser(char *input)
/* desc		:	Looks for newline characters in order to close lists and its
 * 				items, testing the state of global flags.
 * 
 * params	:	1.	The most-recently parsed T_WORD.
 * 
 * output	:	Either just the unmodified T_WORD, if there's nothing to
 * 				close, or a concatenation of html tags and the T_WORD.
 */
{
	char *out;
	int i, nl;
	size_t len;

	// checks input for a newline
	nl = 0;
	for (len = strlen(input); len > 0; len--) {
		if (input[len - 1] == '\n') {
			nl = 1;
		}
	}

	out = concat(1, "");

	if (nl) {
		// for unordered lists
		if (ulist_flag != 0) {
			// if there is an list item opened, closes it
			if (ulist_curr == ulist_flag) {
				out = concat(2, out, "</li>");
			}
			// if there are still list levels opened, closes them
			else if(ulist_curr == 0 ) {
				for (i = 0; i < ulist_flag; i++) {
					out = concat(2, out, "</ul>");
				}
				ulist_flag = 0;
			}
		}
		// for ordered lists
		else if (olist_flag != 0) { 
			// if there is an list item opened, closes it
			if (olist_curr == olist_flag) { 
				out = concat(2, out, "</li>");
			}
			// if there are still list levels opened, closes them
			else if(olist_curr == 0 ) { 
				for (i = 0; i < olist_flag; i++) {
					out = concat(2, out, "</ol>");
				}
				olist_flag = 0;
			}
		}

		ulist_curr = 0;
		olist_curr = 0;
	}

	return out;
}



// === code formatting functions =============================================

char *imageCode(char *address, char *caption)
/* desc		:	Composes the html code for images.
 *
 * params	:	1.	A string containing the image's URL.
 *				2.	A string with the image's caption text.
 *
 * output	:	The composed html code.
 */
{
	char *out;

	char *line1 = "<div class=\"image-inset-div\"><img class=\"image-inset-img\" src=\"";
	char *line2 = "\" /><p class=\"image-caption\">";
	char *line3 = "</p></div>";

	out = concat(5, line1, address, line2, caption, line3);

	return out;
}



char *videoCode(char *vnum)
/* desc		:	Composes the html code for embedded YouTube videos.
 *
 * params	:	1.	A string containing the index code of the video.
 *
 * output	:	The composed html code.
 */
{
	char *out;
	char *line1 = "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/";
	char *line2 = "\" frameborder=\"0\" allowfullscreen></iframe>";

	out = concat(5, "</p><div class=\"video\">", line1, vnum, line2, "</div><p>");

	return out;
}



// === html generation functions =============================================

char *generateTextPage(int pos)
/* desc		:	Generates html pages for articles with long text.
 *
 * params	:	1.	An integer with the position of the article in the data
 * 					structure.
 *
 * output	:	The filename of the generated page, or a pointer to NULL, if
 * 				no page was generated.
 */
 {
 	char *out;
 	char *filename;
 	FILE *fd;

 	out = NULL;

 	if (articles[pos].show[6] == 6) {
	 	
	 	filename = concat(2, articles[pos].name, ".html");
	 	
	 	fd = fopen(filename, "w");
	 	if (fd == NULL) {
	 		perror("parsernpl: error creating text page");
	 		exit(EXIT_FAILURE);
	 	}
	 	
	 	setbuf(fd, NULL);
	 	fputs("<html><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">", fd);
	 	fputs("<link rel=\"stylesheet\" type=\"text/css\" href=\"./basic.css\">", fd);
	 	fputs("<head><title>", fd);
	 	fputs(articles[pos].title, fd);
	 	fputs("</title></head><body><center><div id=\"frame\"><div class=\"long-text-div\"><h1 class=\"text-title\">", fd);
	 	fputs(articles[pos].title, fd);
	 	fputs("</h1><p>", fd);
	 	fputs(articles[pos].text, fd);
	 	fputs("</p></div></div></center></body></html>", fd);
	 	
	 	fclose(fd);
	 	
	 	out = filename;
	 }

	 return out;
 }



void generateHeader(FILE *fd)
/* desc		:	Writes the html header of main page into a file.
 *
 * params	:	1.	A file descriptor to the newspaper main page.
 *
 * output	:	None. (Writes to a file.)
 */
{
	setbuf(fd, NULL);
	fputs("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"><title>", fd);
	fputs(title, fd);
	fputs("</title><link rel=\"stylesheet\" type=\"text/css\" href=\"./basic.css\">", fd);
	fputs("</head><body><center><div id=\"frame\"><div id=\"main-header\"><div id=\"main-title\">", fd);
	fputs(title, fd);
	fputs("</div><div id=\"main-date\">", fd);
	fputs(date, fd);
	fputs("</div><div id=\"main-hbar\"><img id=\"main-hbar-img\" src=\"hbar.png\" /></div></div>", fd);
	fputs("<table id=\"main-table\" width=\"", fd);
	fprintf(fd, "%d", FRAME_WIDTH);
	fputs("\"><tbody>", fd);
}



void generateFooter(FILE *fd)
/* desc		:	Writes the html footer of main page into a file.
 *
 * params	:	1.	A file descriptor to the newspaper main page.
 *
 * output	:	None. (Writes to a file.)
 */
{
	setbuf(fd, NULL);
	fputs("</tbody></table></div></center></body></html>", fd);
}



void generateAbsField(FILE *fd, int pos, int field)
/* desc		:	Writes the html code for the entries in the main page of each
 *				article field listed for exhibition.
 *
 * params	:	1.	A file descriptor to the newspaper main page.
 *				2.	The position in the articles' vector of the article to be
 *					exhibited.
 *				3.	The field of the article to be exhibited.
 *
 * output	:	None. (Writes to a file.)
 */
{
	setbuf(fd, NULL);
	switch (field) {
		case 1: // author
			fputs("<p class \"abs-author\"><b>Autor: </b><i>", fd);
			fputs(articles[pos].author, fd);
			fputs("</i></p>", fd);
			break;
		case 2: // date
			if (articles[pos].show[field] != -1) {
				fputs("<p class \"abs-date\"><b>Data: </b>", fd);
				fputs(articles[pos].date, fd);
				fputs("</p>", fd);
			}
			break;
		case 3: // source
			if (articles[pos].show[field] != -1) {
				fputs("<p class \"abs-author\"><b><i>Fonte: </i></b>", fd);
				fputs(articles[pos].source, fd);
				fputs("</p>", fd);
			}
			break;
		case 4: // image
			if (articles[pos].show[field] != -1) {
				fputs("<p class \"abs-image\"><img class=\"abs-image-img\" src=\"", fd);
				fputs(articles[pos].image, fd);
				fputs("\"></p>", fd);
			}
			break;
		case 5: // abstract
			fputs("<p class \"abs-abstract\">", fd);
			fputs(articles[pos].abstract, fd);
			fputs("</p>", fd);
			break;
	}
}



void generateAbstract(FILE *fd, int pos, char *filename)
/* desc		:	Writes the html code for the block on the main page of each
 *				article listed for exhibition.
 *
 * params	:	1.	A file descriptor to the newspaper main page.
 *				2.	The position in the articles' vector of the article to be
 *					exhibited.
 *				3.	The filename of the article's long text (NULL if the
 *					article doesn't have a long text).
 *
 * output	:	None. (Writes to a file.)
 */
{
	int i, field;

	setbuf(fd, NULL);
	fputs("<td colspan=\"", fd);
	fprintf(fd, "%d", articles[pos].cols);
	fputs("\" width=\"", fd);
	fprintf(fd, "%d", (FRAME_WIDTH / columns ) * articles[pos].cols);
	fputs("\"><h1 class=\"abs-title\">", fd);
	if (filename != NULL) {
		fputs("<a href=\"", fd);
		fputs(concat(2, "./", filename), fd);
		fputs("\">", fd);
	}
	fputs(articles[pos].title, fd);
	if (filename != NULL) {
		fputs("</a>", fd);
	}
	fputs("</h1>", fd);
	for (i = 0; i < 6; i++) {
		for (field = 1; field < 6; field++) {
			if (articles[pos].show[field] == i) {
				generateAbsField(fd, pos, field);
			}
		}
	}
	fputs("</div>", fd);
}



void generateMainPage()
{
	char *listed_name;
	int art_pos;
	int i, j, len;

	FILE *fd;
	char *filename;

	int icol;
	char *text_fn;

	filename = "index.html";
	fd = fopen(filename, "w");
	if (fd == NULL) {
		perror("parsernpl: error creating main page");
		exit(EXIT_FAILURE);
	}

	generateHeader(fd);

	icol = 0;

	if (article_counter > 0) {

		listed_name = strtok(articles_names, ",");
		if (listed_name != NULL) {
			len = strlen(listed_name);
			art_pos = findArticlePos(listed_name);
		}
		// if the article exists and its fields were filled
		if (isArticleValid(art_pos)) {
			if (icol == 0) {
				fputs("<tr>", fd);
			}
			text_fn = generateTextPage(art_pos);
			generateAbstract(fd, art_pos, text_fn);
			icol += articles[art_pos].cols;
			if (icol >= columns) {
				fputs("</tr>", fd);
				icol = 0;
			}

		}
		
		for (i = 1; i < article_counter; i++) {
			listed_name = strtok(NULL, ",");
			if (listed_name != NULL) {
				len = strlen(listed_name);
				art_pos = findArticlePos(listed_name);
			}
			// if the article exists and its fields were filled
			if (isArticleValid(art_pos)) {
				if (icol == 0) {
					fputs("<tr>", fd);
				}
				text_fn = generateTextPage(art_pos);
				generateAbstract(fd, art_pos, text_fn);
				icol += articles[art_pos].cols;
				if (icol >= columns) {
					fputs("</tr>", fd);
					icol = 0;
				}
			}
		}

	}

	generateFooter(fd);

	close(fd);
}




// === auxiliary functions ===================================================

int findArticlePos(char *listed_name)
/* desc		:	Find the position of the named article in the data structure.
 *
 * params	:	1.	A string with the name of the article to be located.
 *
 * output	:	The position of the article or -1, if the article isn't found.
 */
{
	int out, i, len;
	char *name_tmp;

	out = -1;
	name_tmp = strdup(listed_name);

	len = strlen(name_tmp);
	for (i = 0; i < len; i++) {
		name_tmp[i] = (char)tolower(name_tmp[i]);
	}
	
	for (i = 0; i < article_counter; i++) {
		if (strcmp(articles[i].name, name_tmp) == 0) {
			out = i;
			break;
		}
	}

	free(name_tmp);
	return out;
}

int isArticleValid(int pos)
/* desc		:	Checks if the given article exists and, if it does, if its
 * 				required fields were filled in.
 *
 * params	:	1.	The position of the article whose the existance of itself
 					and its fields are to be checked.
 *
 * output	:	An integer set to 1, if the article is valid, or 0, if not.
 */
{
	int out;

	out = 0;

	if (pos != -1) {
		if (articles[pos].cols > 0 && 
			articles[pos].title != NULL &&
			articles[pos].author != NULL &&
			articles[pos].abstract != NULL) {
			out = 1;
		}
	}

	return out;
}



// === debugging functions ===================================================

void testPrintAll()
{
	int i;

	printf("Titulo do jornal: %s\n", title);
	printf("Data do jornal: %s\n", date);
	printf("Colunas do jornal: %d\n\n", columns);
	
	for (i = 0; i < article_counter; i++) {
		puts(articles[i].name);
		printf("Colunas: %d\n", articles[i].cols);
		if (articles[i].show[0] != -1)
			printf("Titulo: %s\n", articles[i].title);
		if (articles[i].show[1] != -1)
			printf("Autor: %s\n", articles[i].author);
		if (articles[i].show[2] != -1)
			printf("Data: %s\n", articles[i].date);
		if (articles[i].show[3] != -1)
			printf("Fonte: %s\n", articles[i].source);
		if (articles[i].show[4] != -1)
			printf("Imagem: %s\n", articles[i].image);
		if (articles[i].show[5] != -1) {
			puts("Resumo:");
			puts(articles[i].abstract);
		}
		if (articles[i].show[6] != -1) {
			puts("Texto:");
			puts(articles[i].text);
		}
		puts("");
	}
}



void testPrintTmp()
{
	int i;

	puts(article_tmp.name);
	printf("Colunas: %d\n", article_tmp.cols);
	if (article_tmp.show[0] != -1)
		printf("Titulo: %s\n", article_tmp.title);
	if (article_tmp.show[1] != -1)
		printf("Autor: %s\n", article_tmp.author);
	if (article_tmp.show[2] != -1)
		printf("Data: %s\n", article_tmp.date);
	if (article_tmp.show[3] != -1)
		printf("Fonte: %s\n", article_tmp.source);
	if (article_tmp.show[4] != -1)
		printf("Imagem: %s\n", article_tmp.image);
	if (article_tmp.show[5] != -1) {
		puts("Resumo:");
		puts(article_tmp.abstract);
	}
	if (article_tmp.show[6] != -1) {
		puts("Texto:");
		puts(article_tmp.text);
	}
	puts("");
}
