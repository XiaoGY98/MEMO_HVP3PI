% besart.cls
% Template class for BESIII notes
% 2011-12-25 Haiping Peng <Penghp@ustc.edu.cn>

% --- Class structure: identification part
% ---
\ProvidesClass{besnote}[2011/12/25 version 3.0 BESIII Memo]
\NeedsTeXFormat{LaTeX2e}

% --- Class structure: initial code part
% ---

% Defaults for title page
\newdimen\AN@skipbeforetitle
\AN@skipbeforetitle=60\p@
\newcommand\skipbeforetitle[1]{
  \AN@skipbeforetitle=#1
}

\def\@title{Title goes here}
\def\@author{The BESIII collaboration}
\def\@date{\today}
%
% Author(s)
%

%\def\@makefnmark{\hbox{$^{\@thefnmark)}$}}
%\def\author#1{%% Treat the list of authors
%\setcounter{footnote}{0}\def\@currentlabel{}%
%\begingroup\def\thefootnote{\arabic{footnote}}
%\global\@topnum\z@ \large\begin{center}{\lineskip.5em
%\begin{tabular}[t]{c}#1\end{tabular}\par}
%\end{center}\par\vskip1.5em\@thanks\endgroup}
%\newenvironment{Authlist}{\begin{center}}{\end{center}}

% memo version
\def\@besmemoversion{}
\newcommand{\besmemoversion}[1]%
{
  \def\@besmemoversion{#1}
}

% BES memo ID
\def\@besmemoid{}
\newcommand{\besmemoid}[1]{\def\@besmemoid{#1}}

% Draft heading code
\newcommand{\draftheading}%
{
  %
  % compute the time in hours and minutes
  % make new variables \timehh and \timemm
  %
  \newcount\timehh\newcount\timemm
  \timehh=\time
  \divide\timehh by 60 \timemm=\time
  \count255=\timehh\multiply\count255 by -60 \advance\timemm by \count255
  % put in header
  \markboth%
  % --- Left mark
  {\hspace*{\fill}{\protect\small\bf \fbox{BES DRAFT}}
    \hspace*{\fill}
    \protect\makebox[0pt][r]{\protect\small\sl\today\ --
      \ifnum\timehh<10 0\fi\number\timehh\,:\,\ifnum\timemm<10 0\fi\number\timemm}
  }%--- right mark
  {\protect\makebox[0pt][l]{\protect\small\sl\today\ --
      \ifnum\timehh<10 0\fi\number\timehh\,:\,\ifnum\timemm<10 0\fi\number\timemm}
    \hspace*{\fill}
    {\protect\small\bf \fbox{BES MEMO}}
    \hspace*{\fill}}
  %
  \pagestyle{myheadings}
}

% Submission details
\def\@subprepend{To be submitted to }
\newcommand{\subprepend}[1]{\def\@subprepend{#1}}
\def\@journal{}
\newcommand{\journal}[1]{\def\@journal{#1}}

% Abstract text
\def\@abstracttext{}
\newcommand{\abstracttext}[1]{\def\@abstracttext{#1}}

% Shortcut to add submission text
\newcommand{\submitted}%
{
  \ifx\@journal\@empty\mbox{}%
  \else
  \vskip 0.8in plus 2in%
  \begin{center}%
    \@subprepend\space {\it \@journal}%
    \vskip 1.5em%
  \end{center}%
  \vskip 0.5in
  \fi
}

% --- Class structure: declaration of options part
% ---
\let\if@CoverPage\iffalse
\DeclareOption{coverpage}{\let\if@CoverPage\iftrue}
\let\if@usetikz\iffalse
\DeclareOption{usetikz}{\let\if@usetikz\iftrue}

% This class extends the article class
% Read all the besnote options, pass them to article
%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
% --- Class structure: execution of options part
% ---
\ProcessOptions \relax

% --- Class structure: declaration of options part
% ---
\LoadClass[titlepage,a4paper,11pt]{article}

% --- Class structure: main code part
% ---

% BESIII Cover Page
\if@CoverPage \RequirePackage[clearpage,besnote]{bescover}[2011/12/25] \fi

% Redefine the page size
\RequirePackage{geometry}
\geometry{
  a4paper,%
  textwidth=16cm,%
  textheight=23.2cm,%
  marginparsep=7pt,%
  marginparwidth=2.5cm%
}

% Remove the numbers from all the headings (\section, \subsection, etc.)
%\setcounter{secnumdepth}{-1}


%
% Title page design
%

\RequirePackage{graphicx}
\RequirePackage{amsmath}
\RequirePackage[varg]{txfonts}
\RequirePackage{color}
\RequirePackage{lineno}   % This is provided with the package
%\RequirePackage[colorlinks,linkcolor=blue,anchorcolor=blue,citecolor=blue,urlcolor=blue,dvipdfm]{hyperref}
\RequirePackage[colorlinks,linkcolor=blue,anchorcolor=blue,citecolor=blue,urlcolor=blue]{hyperref}
%\RequirePackage[colorlinks,linkcolor=black,urlcolor=blue]{hyperref}



\newcommand{\maketitlepage}{%
  \null
  \thispagestyle{empty}
  \pagestyle{plain}
  \pagenumbering{arabic}
  \vskip -1.5cm
  \parbox{0.25\linewidth}{%
    \includegraphics[height=35mm,angle=90]{AT_bes3logo}
  }
  \parbox{0.70\linewidth}{%
    \ifx\@besmemotversion\@empty\mbox{}%
    \else \flushright {\bf \large Memo version \@besmemoversion} \\
    \fi
  }
  \vskip 0.0cm
  \begin{center}
    \hfill
    \begin{minipage}[b]{15cm}
      \vfill
      \begin{center}
        {\huge \bf \textsf{BESIII Analysis Memo}}%
        % Besnote number
        \vskip -0.4mm%
        \ifx\@besmemoid\@empty \mbox{}%
        \else \vskip 6mm {\bf \Large \textsf{BAM-\@besmemoid}} \vskip 1mm%
        \fi
        % Date, if any
        \ifx\@date\@empty\mbox{}%	
        \else \vskip 1mm {\bf \textsf{\@date}}%
        \fi
      \end{center}
    \end{minipage}
    \hfill
  \end{center}
  % Add line numebrs to front page content
 {%
  \ifx\@draftversion\@empty%
  \else\linenumbers
  \fi
  % Title, author(s)
  %\vskip 60\p@
  %\vskip \AN@skipbeforetitle
  \begin{center}%
    \vskip 0.1em%
    {\LARGE \bf \@title \par}%
     \vskip 0.8em%
    {\large
     \lineskip .70em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
     \vskip 0.6em%
     {\LARGE \bf Referee Committee \par}
      \vskip 0.8em%
     {\large
       \lineskip .70em%
       \begin{tabular}[t]{c}%
         \@refmember
       \end{tabular}\par
     }%

     

     \vskip 0.6em%
     {\LARGE \bf Pubcomm Editors \par}
      \vskip 0.8em%
     {\large
       \lineskip .70em%
       \begin{tabular}[t]{c}%
         \@refeditor
       \end{tabular}\par
     }%


     \vskip -1.2em%
     \ifx\@besmemoid\@empty \mbox{}%
        \else \vskip 6mm {\textsf{HN~:\it~\url{http://hnbes3.ihep.ac.cn/HyperNews/get/paper835.html}}} \vskip 1mm%
     \fi
  \end{center}\par
  %\vfill
  % Abstract
  \vskip 2em%
  \if\@abstracttext\@empty\mbox{}%
  \else%
  \begin{center}
    {\bfseries \Large \abstractname}
    \quotation
    \@abstracttext
    \endquotation
  \end{center}
  \fi
  \vfill
  % Submission details
  \submitted
  % Thanks
  \@thanks
  }%
  %\vfil\null%
}

% This some before-and-after code that surrounds the title page. It
% shouldn't need to be modified. I've pulled out the part the actually
% typesets the title page and placed it in the \maketitlepage command
% above.
\renewcommand\maketitle{%
  \begin{titlepage}%
    \let\footnotesize\small%
    \let\footnoterule\relax%
    \let \footnote \thanks%
    \maketitlepage%
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \setcounter{page}{1}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@refchair\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
  \global\let\refchair\relax
}

% Use \icaption instead of \caption in tables and figures to get a
% caption that is indented. Note that the label should be included
% inside \icaption for it to work properly.
\newlength{\capindent}
\setlength{\capindent}{0.5cm}
\newlength{\capwidth}
\setlength{\capwidth}{\textwidth}
\addtolength{\capwidth}{-2\capindent}
\newlength{\figwidth}
\setlength{\figwidth}{\textwidth}
\addtolength{\figwidth}{-2.0cm}
\newcommand{\icaption}[2][!*!,!]{\hspace*{\capindent}%
  \begin{minipage}{\capwidth}
    \ifthenelse{\equal{#1}{!*!,!}}%
      {\caption{#2}}%
      {\caption[#1]{#2}}
      \vspace*{3mm}
  \end{minipage}}

\AtBeginDocument{
  % If selected, generate BES Cover Page
  \if@CoverPage
  \AC@PrintAtlasCover
  \fi
  % Automatically generate title page
  \maketitle
  % Add draft heading and line numbers
  \ifx\@draftversion\@empty%
%  \else \pagewiselinenumbers \draftheading
\else \linenumbers \draftheading
\fi
  % Hack for tikz (must be loaded here in order to avoid conflicts with graphicx user in \maketitle}
  \if@usetikz \RequirePackage{tikz} \fi
  %\pagenumbering{arabic} % reset page numbering after title page
}

% That's all, folks!
\endinput
