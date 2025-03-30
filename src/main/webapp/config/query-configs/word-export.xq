import module namespace c = "common.xq" at "common.xq";

declare function local:get-status($word as element()) as xs:string {
    if (contains($word/@mark, '-')) then 'Удалено'
    else if (contains($word/@mark, '|')) then 'Удалено'
    else if ($word/combine) then 'Составное'
    else if ($word/deprecated) then 'Не рекомендовано'
    else 'OK'
};

concat(concat('"Версия экспорта Eldamo ', /word-data/@version, '"&#10;'),
'"Page ID","Lang","Word","Speech","Gloss","Status","Cat #","Category"&#10;',
string-join(for $word in //word
    [not(starts-with(c:get-speech(.), 'phon'))]
    [not(ends-with(c:get-speech(.), 'name'))]
    [not(c:get-speech(.) = 'phrase')]
    [not(c:get-speech(.) = 'text')]
    [not(c:get-speech(.) = 'grammar')]
let $cat := xdb:key(., 'cat-def', $word/@cat)
order by $word/@l, $word/@v
return
    concat('"',
        xdb:hashcode($word), '","',
        normalize-space(c:convert-lang(c:get-lang($word))), '","',
        $word/@v, '","',
        c:get-speech($word), '","',
        c:get-gloss($word), '","',
        local:get-status($word), '","',
        $cat/@num, '","',
        $cat/@label, '"'
    ),
"&#10;"))