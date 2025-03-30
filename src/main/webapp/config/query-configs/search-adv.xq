import module namespace c = "common.xq" at "common.xq";

declare function local:lang-name($lang as element()) as xs:string {
    if ($lang/@id = 'q') then (
        concat('Поздний ', $lang/@name/string(), ' (1950-73)')
    ) else if ($lang/@id = ('s', 'p')) then (
        concat($lang/@name/string(), ' (1950-73)')
    ) else if ($lang/@id = ('mq', 'n')) then (
        concat($lang/@name/string(), ' (1930-50)')
    ) else if ($lang/@id = 'mp') then (
        'Средний пра-эльфийский (1930-50)'
    ) else if ($lang/@id = 'eq') then (
        concat($lang/@name/string(), ' (1910-30)')
    ) else if ($lang/@id = 'g') then (
        concat($lang/@name/string(), ' (1910-20)')
    ) else if ($lang/@id = 'en') then (
        concat($lang/@name/string(), ' (1920-30)')
    ) else if ($lang/@id = 'ep') then (
        'Ранний пра-эльфийский (1910-30)'
    ) else (
        $lang/@name/string()
    )
};

declare function local:lang-order($lang as xs:string) as xs:string {
    if ($lang = 'q') then (
       '0'
    ) else if ($lang = 's') then (
       '1'
    ) else if ($lang = 'p') then (
       '2'
    ) else if ($lang = 'mq') then (
       '3'
    ) else if ($lang = 'n') then (
       '4'
    ) else if ($lang = 'mp') then (
       '5'
    ) else if ($lang = 'eq') then (
       '6'
    ) else if ($lang = 'en') then (
       '7'
    ) else if ($lang = 'g') then (
       '8'
    ) else if ($lang = 'ep') then (
       '9'
    ) else (
       $lang
    )
    
};

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
    <meta http-equiv="Content-Style-Type" content="text/css"></meta>
    <title>Eldamo : Продвинутый поиск</title>
    <link rel="stylesheet" type="text/css" href="../../css/global.css"></link>
    <style>

span.label-holder {{ float: left; padding-right: 0.5em; }}
span.button-holder {{ float: right; display: block }}
span.search-holder {{ overflow: hidden; display: block; padding-right: 0.5em; }}
input.searchBox {{ width: 100%; }}
.search-selectors {{ margin-top: 0.25em; display: none; text-align: center; }}
.neo-warning-div {{ margin-top: 0.25em; padding-top: 0.25em; display: none; }}
.help-div {{ margin-top: 0.25em; display: block; }}
input[type="text"], select, button {{ font-size: 16px; }}
button {{ border-radius: 4px; background-color: #EEE; border: 1px solid #444 }}
.label-holder {{ display: none; }}
@media only screen and (min-width: 920px) {{
    .search-selectors {{ text-align: left; }}
}}
@media only screen and (min-width: 400px) and (min-height: 400px) {{
    .label-holder {{ display: block; }}
    .search-selectors {{ display: block; }}
}}

    </style>
</head>
<script src="search-adv-index.js"></script>
<script src="../../js/search-adv.js"></script>
<body onload="initSearch()">
<div class="search-header">
    <span class="label-holder">
        <big>[<a href="../../index.html">На главную страницу</a>]</big>
    </span>
    <span class="button-holder">
        <button id="advancedButton" class="advancedButton" onclick="advanced()">...</button>
    </span>
    <span class="search-holder">
        <input type="text" id="searchBox" class="searchBox" value="" onfocus="hideHelp()" onkeyup="doSearchTyping()" placeholder="Поиск..." />
    </span>
</div>
<div class="search-selectors" id="search-selectors">
    <button id="helpButton" class="helpButton" onclick="help()">?</button> &#160;
    <select id="langSelect" class="langSelect" onfocus="hideHelp()" onchange="doSearch()">
        <option value="">Все языки</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="eq|mq|q|nq">Ранний/Средний/Поздний квэнья</option>
        <option value="g|n|en|s|ns">Синдарин/Нолдорин/Номский</option>
        <option value="p|mp|ep|np">Ранний/Средний/Поздний пра-эльфийский</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="mq|q|nq">Поздний квэнья (1930+)</option>
        <option value="n|s|ns">Синдарин/Нолдорин (1930+)</option>
        <option value="mp|p|np">Поздний пра-эльфийский (1930+)</option>
        <option value="" disabled="disabled">─────────────</option>
        <option value="q|aq|van|s|os|p|t|at|nan|norths|av">Все поздние эльфийские языки (1950-73)</option>
        <option value="mq|maq|lin|n|on|mp|mt|ilk|dan|lem">Все средние эльфийские языки (1930-50)</option>
        <option value="eq|en|g|et|ep">Все ранние эльфийские языки (1910-30)</option>
        <option value="" disabled="disabled">─────────────</option> {
            for $lang in //language[@id][not(@id=('np', 'ns', 'nq'))]
            order by local:lang-order($lang/@id)
            return (
                <option value="{$lang/@id/string()}">{local:lang-name($lang)}</option>,
                if ($lang/@id = 'ep') then  <option value="" disabled="disabled">─────────────</option>
                else if ($lang/@id = 'mp') then  <option value="" disabled="disabled">─────────────</option>
                else if ($lang/@id = 'p') then  <option value="" disabled="disabled">─────────────</option>
                else ()
            )
       }
    </select> &#160;
    <select id="partsOfSpeechSelect" onfocus="hideHelp()" onchange="doSearch()">
        <option value="">части речи</option>
        <option value="" disabled="disabled">──────</option>
        <option value="no-names">исключая имена</option>
        <option value="only-names">только имена</option>
        <option value="" disabled="disabled">──────</option>
        <option value="n">существительное</option>
        <option value="vb">глагол</option>
        <option value="adj">прилагательное</option>
        <option value="adv">наречие</option>
        <option value="pron">местоимение</option>
        <option value="prep">предлог</option>
        <option value="conj">союз</option>
        <option value="interj">междометие</option>
        <option value="pref">приставка</option>
        <option value="suf">суффикс</option>
        <option value="root">корень</option>
    </select> &#160;
    <select id="diacriticSelect" onfocus="hideHelp()" onchange="doSearch()">
        <option value="ignore">игнорировать диакритику</option>
        <option value="match">учитывать диакритику</option>
    </select> &#160;
    <button id="resetButton" onclick="reset()">Обнулить</button>
</div>
<div class="help-div" id="help-div">
<p><b>Help:</b> This help section is replaced by the search results when you first begin searching. You can use the
“...” button to show/hide the search filters and the “?” button to show/hide help text during a search.</p>
<p>This advanced search allow you to search for raw references of Elvish words (and other languages) as they appeared
in Tolkien’s original texts. You can only search the Elvish (or other language) words, not English glosses. The same
result may appear multiple times if there are multiple references matching it. Where a given reference appears many
times in a particular work, however, sometimes only notable or initial references are included or a reference to the
index.</p>
<p><b>Match Diacritics:</b> By default this advanced search is by exact match (c matches only c and k matches only k),
but ignores diacritics (u matches ū, ŭ, ū). For exact matches on diacritics as well, choose “match diacritics”.</p>
<p><b>Regular Expressions:</b> This search supports regular expressions, allowing you to specify more advanced
matching criteria. For example “^t” matches words that begin with t, “t$” matches words that end with t, and
“.t.” matches t preceded and followed by at least one more character (in other words, in the interior of the word).
Quite complex searches are possible, such as “rd[aeiouy]” which matches “rd” followed by any (Sindarin) vowel, which
would exclude “rdh”. An internet search can be used to find documentation on “JavaScript Regular Expressions”,
which is what this search engine uses. A good regex summary can be found at
<a href="https://www.rexegg.com/regex-quickstart.html" target="_blank">https://www.rexegg.com/regex-quickstart.html</a>
and here is a good tutorial: <a href="https://regexone.com" target="_blank">https://regexone.com</a>.</p>
<p><b>Inflection Search:</b> TBD - A future version of the advanced search will allow searches for inflected forms
(e.g. past tenses).</p>
</div>
<hr />
<dl id="resultList"></dl>
</body>
</html>
