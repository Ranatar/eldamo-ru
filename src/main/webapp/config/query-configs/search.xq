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
    <title>Eldamo : Поиск</title>
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
<script src="search-index.js"></script>
<script src="../../js/search.js"></script>
<body onload="initSearch()">
<div class="search-header">
    <span class="label-holder">
        <big>[<a href="../../index.html"> На главную страницу</a>]</big>
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
    <select id="targetSelect" onfocus="hideHelp()" onchange="doSearch()">
        <option value="word-and-gloss">слово &amp; толкование</option>
        <option value="word-only">только слово</option>
        <option value="gloss-only">только толкование</option>
    </select> &#160;
    <select id="positionSelect" onfocus="hideHelp()" onchange="doSearch()">
        <option value="anywhere">любая позиция</option>
        <option value="start">только в начале</option>
        <option value="end">только в конце</option>
        <option value="interior">только в середине</option>
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
    <button id="resetButton" onclick="reset()">Обнулить</button>
</div>
<div class="neo-warning-div" id="neo-warning-div">
This search mixes words from various periods of Tolkien’s life, as well as
neologisms invented by fans. The search results use the ⚠️  symbol to recommend against using particular words, but this is a
reflection only of the author’s (Paul Strack’s) opinions. Furthermore, the analysis of the corpus remains incomplete,
and these recommendations may change in the future. For more information about neologisms in Eldamo, see the neologism
lists for <a href="../neologism-indexes/neologisms-nq.html?neo">Neo-Quenya</a> and
<a href="../neologism-indexes/neologisms-ns.html?neo">Neo-Sindarin</a>. For a search limited to Tolkien’s own words
excluding any neologisms or recommendations, see the <a href="search.html">Academic Search</a>.
</div>
<div class="help-div" id="help-div">
<p><b>Help:</b> This help section is replaced by the search results when you first begin searching. You can use the
“...” button to show/hide the search filters and the “?” button to show/hide help text during a search.</p>
<p>To search, enter the word or translation in the text box to see matching results. By default, the search matches
against both the word and its glosses (translations) but you can further restrict this by using the search filters,
which can also be used to filter results by language or parts of speech. Note that English translations, like Tolkien,
mostly use British spellings: “colour” not “color”. There are a few additional advanced search options:</p>
<p><i>Wildcards</i> (*): This can be used as match placeholder. The normal search for “re” matches text ending
containing the text “re” anywhere. The search “*re” matches text ending with “re”; “re*” matches text beginning “re”;
“*re*” matches text with “re” in the interior; “r*e” matches text that starts with an “r” and ends with an “e”.</p>
<p><i>Multi-match</i> (,): A comma “,” can be used for optional multi-match criteria. The search “dream, sleep”
will find any word that matches either “dream” or “sleep”.</p>
<p><i>Multi-match</i> (+): A plus “+” can be used for required multi-match criteria. The search “dream+sleep”
will find any word that matches both “dream” and “sleep”.</p>
<p><i>Word-only or Gloss-only:</i> The prefix “word=” means a multi-match criteria applies only to words. The prefix
“gloss=” means a multi-match criteria applies only to glosses (translations). For example, “word=lor+gloss=dream” will
match any word containing “lor” whose gloss also contains “dream”.</p>
<p>All these advanced search options (including wildcards) may be combined. If you use both “,” and “+” then the search
breaks down across the “+” first, then the “,”. For example, “word=lor+gloss=dream,sleep” matches words containing
“lor” whose glosses contain either “dream” or “sleep”.</p>
</div>
<hr />
<dl id="resultList"></dl>
</body>
</html>
