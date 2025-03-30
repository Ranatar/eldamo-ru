import module namespace c = "common.xq" at "common.xq";

declare variable $id external;
declare variable $lang := /*//language[@id=$id];
declare variable $lang-name := $lang/@name/string();
declare variable $is-neo-lang := $id = ('nq', 'ns', 'np');

declare function local:get-speech($word as element()?) as xs:string? {
    $word/ancestor-or-self::*[@speech][1]/@speech/string()
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Eldamo : {$lang-name}</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<div id="nav-block" class="nav-block">
    [<a href="../../index.html">На главную страницу</a>] »
    <a href="../languages/index.html">Языки</a> »&#160;
</div>
<hr/>
<h1>{$lang-name}</h1>
{
let $all := c:lang-words(/*, $id)
let $roots := $all[local:get-speech(.)='root']
let $words := $all
    [not(ends-with(local:get-speech(.), '-name'))]
    [not(local:get-speech(.)='phrase' or local:get-speech(.)='text')]
    [not(starts-with(local:get-speech(.), 'phone'))]
    [not(local:get-speech(.)='grammar')]
    [not(local:get-speech(.)='root')]
let $names := $all[ends-with(local:get-speech(.), '-name')][not($is-neo-lang)]
let $phrases := $all[local:get-speech(.)='phrase' or local:get-speech(.)='text']
let $phonetics := $all[starts-with(local:get-speech(.), 'phone')][not($is-neo-lang)]
let $grammar := $all[local:get-speech(.)='grammar'][not($is-neo-lang)]
let $categories := ($words | $roots)[ancestor-or-self::*[@cat and not(@cat='?')]]
return (
<ul> { (
    if ($is-neo-lang) then <li><a href="../vocabulary-indexes/vocabulary-words-{$id}.html">Словарь</a></li> else (),
    if (not($is-neo-lang) and $roots) then <li><a href="../root-indexes/roots-{$id}.html">Корнм</a> ({count($roots)})</li> else (),
    if (not($is-neo-lang) and $words) then <li><a href="../word-indexes/words-{$id}.html">Слова</a> ({count($words)})</li> else (),
    if ($names) then <li><a href="../name-indexes/names-{$id}.html">Имена</a> ({count($names)})</li> else (),
    if (not($is-neo-lang) and $phrases) then <li><a href="../phrase-indexes/phrases-{$id}.html">Фразы</a> ({count($phrases)})</li> else (),
    if ($grammar) then <li><a href="../grammar-indexes/grammars-{$id}.html">Грамматика</a> ({count($grammar)})</li> else (),
    if ($phonetics) then <li><a href="../phonetic-indexes/phonetics-{$id}.html">Фонетика</a> ({count($phonetics)})</li> else (),
    if (not($is-neo-lang) and $categories) then <li><a href="../category-indexes/categories-{$id}.html">Семантические категории</a> ({count($categories)})</li> else ()
) }</ul>,
xdb:html($lang/notes/string()),
if (not($is-neo-lang)) then () else
<p>Для более детальной информации о том, как был составлен данный словарный список, см.:</p>,
<ul> { (
    if ($is-neo-lang and $roots) then <li><a href="../root-indexes/roots-{$id}.html">Полный список корней</a></li> else (),
    if ($is-neo-lang and $words) then <li><a href="../word-indexes/words-{$id}.html">Полный список слов</a></li> else (),
    if ($is-neo-lang and $categories) then <li><a href="../category-indexes/categories-{$id}.html">Семантические категории</a></li> else (),
    if ($is-neo-lang) then <li><a href="../neologism-indexes/neologisms-{$id}.html">Неологизмы</a></li> else (),
    if ($is-neo-lang and $phrases[@l = ('nq', 'ns')]) then <li><a href="../phrase-indexes/phrases-{$id}.html">Фразы</a></li> else (),
    if ($is-neo-lang) then <li><a href="../deprecation-indexes/deprecations-{$id}.html">Нерекомендуемые слова</a></li> else ()
) }</ul>
) }
</body>
{if (not($is-neo-lang)) then () else (
<script>
var anchors = document.getElementsByTagName('a');
for (var i = 0; i &lt; anchors.length; i++) {{
    var a = anchors[i];
    if (a.href.indexOf('-{$id}') > 0) a.href = a.href + "?neo";
}}
</script>
)} 
</html>
