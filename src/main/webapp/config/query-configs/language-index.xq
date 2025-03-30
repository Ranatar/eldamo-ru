import module namespace c = "common.xq" at "common.xq";

declare variable $pubmode external;
declare variable $lang-cats := /*/language-cat;

declare function local:show-language($lang as element()) as element() {
    <li> { (
        if ($lang/@id) then (
            <a href="../language-pages/lang-{$lang/@id}.html"><b>{$lang/@name/string()}</b></a>,
            concat(' (', normalize-space(c:convert-lang(string($lang/@id))), ')')
        ) else (
            <b><i>{$lang/@name/string()}</i></b>
        ),
        if (not($lang/language)) then () else
        <ul> {
            for $child in $lang/language return local:show-language($child)
        } </ul>
    ) } </li>
};

declare function local:has-lang($lang as xs:string?) as xs:boolean {
    if ($lang-cats//language[@id = $lang]) then (true()) else false()
};

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Eldamo : Указатель языков</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
</head>
<body>
<p>[<a href="../../index.html">На главную страницу</a>]</p>
<hr/>
<h1>Указатель языков</h1>
<ul> {
for $lang-cat in /*/language-cat
return
<li><b><a href="#{$lang-cat/@id/string()}">{$lang-cat/@name/string()}</a></b></li>
} </ul>
<p>Эта страница содержит перечень языков, включённых в данный лексикон, распределённых по различнным временн<i>ы</i>м периодам. В рамках каждого периода языки иерархически отсортированы по своему происхождению: младшие языки, которые произошли от более древних языков.</p>
<p>“Составные” или “нео” языки объединяют слова из различных временн<i>ы</i>х периодов, включая фанатиские привнесения (неологизмы). Эти “составные” списки наиболее часто используются для современных сочинений на эльфийских языках. Следует однако же быть осторожным при пользовании этими словарными списками, так как в них смешаны слова из различных периодов. Временной период каждого слова обозначается соответствующим языковым обозначанием, а кроме того имеются различные “<a href="../../general/terminology-and-notations.html#reliability-markers">обозначения надёжности</a>”, по которым можно узнать уровень добротности каждого слова.</p>
<p>Прочие языки представлены в том виде, в котором Толкин их описывал в различные периоды своей жизни: ранний (1910-1930), средний
(1930-1950) и поздний (1950-1973). В них имеются только те формы, которые Толкин приводил в каждом конкретном периоде. Следует однако же иметь в виду, что Толкин часто употреблял ранние формы в своих поздних работах. Даже если какая-либо ранняя форма не встречается позднее, из этого не следует, что Толкин больше не считал её верной. В данном лексиконе, насколько это возможно, отслеживается история разработки каждого отдельного слова в работах Толкина.</p>
<div> {
for $lang-cat in /*/language-cat
return (
<p><b><u><a name="{$lang-cat/@id/string()}"></a>{$lang-cat/@name/string()}</u></b></p>,
<ul> {
for $lang in $lang-cat/language|$lang-cat/language-cat
return
    local:show-language($lang)
} </ul>
) } </div>

<div> {
let $unex-langs := distinct-values(//word/@l)
let $lang-list := (
<ul> {
for $unex-lang in $unex-langs[not(local:has-lang(.))][$pubmode != 'true']
return (
    <li>{ $unex-lang }</li>
) } </ul>
)
return if (normalize-space($lang-list) = '') then () else (
    <p><b>Unexplained Languages</b></p>,
    $lang-list
) } </div>
</body>
</html>
