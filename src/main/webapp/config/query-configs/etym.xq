import module namespace c = "common.xq" at "common.xq";

declare function local:derive-css($word as element()?) as xs:string {
    if (contains($word/@mark, '-')) then 'deleted'
    else if (contains($word/@mark, '|')) then 'deleted'
    else ''
};

declare function local:find-derivatives($refs as element()*) as element()* {
    let $deriv-to-refs := $refs/xdb:key($refs[1], 'deriv-to-ref', @source)
    let $element-in-refs := $refs/xdb:key($refs[1], 'element-in-ref', @source)
    return ($deriv-to-refs | $element-in-refs)
        [not(contains(c:get-speech(.), 'name'))][not(c:get-speech(.)='root')][not(c:get-speech(.)='phrase')]
};

declare function local:skip-deriv($ref as element()?, $cognate-refs as element()*) {
    let $lang := c:get-lang($ref)
    return
    if (contains($ref/@mark, '*')) then true()
    else if ($lang = 'mp' or $lang = 'on') then
        if ($ref/xdb:key($ref[1], 'deriv-to-ref', @source)) then true() else false()
    else if ($lang = 'mq') then
        if ($cognate-refs[not(c:get-lang(.) = ('mq'))]) then true() else false()
    else if ($lang = 'n') then
        if ($cognate-refs[not(c:get-lang(.) = ('mq', 'n'))]) then true() else false()
    else if ($lang = 'mt') then
        if ($cognate-refs[not(c:get-lang(.) = ('mq', 'n', 'mt'))]) then true() else false()
    else if ($lang = ('ilk', 'dor')) then
        if ($cognate-refs[not(c:get-lang(.) = ('mq', 'n', 'mt', 'ilk', 'dor'))]) then true() else false()
    else false()
};

declare function local:show-speech($ref as element()?) {
    let $speech := $ref/c:get-speech($ref)
    return 
    if ($speech='masc-name') then ' м.'
        else if ($speech='fem-name') then ' ж.'
        else if ($speech='place-name') then ' геогр.'
        else if ($speech='collective-name') then ' собир.'
        else if ($speech='collective-noun') then ' собир.'
        else if ($speech='proper-name') then ' им.'
        else if ($speech='cardinal') then ' к. числ'
        else if ($speech='ordinal') then ' п. числ.'
        else if ($speech='vb') then ' гл.'
        else if ($speech='n') then ' сущ.'
        else if ($speech='adj') then ' прил.'
        else if ($speech='adv') then ' нар.'
        else if ($speech='pron') then ' мест.'
        else if ($speech='conj') then ' c.'
        else if ($speech='interj') then ' межд.'
        else if ($speech='suf') then ' суф.'
        else if ($speech='pref') then ' прист.'
        else if ($speech='prep') then ' пред.'
        else if ($speech='root') then ' кор.'
        else if ($speech='adv adj') then 'нар. и прил.'
        else if ($speech='adj adv') then 'прил. и нар.'
        else if ($speech='adj n') then 'прил. и сущ.'
        else if ($speech='adv n') then 'нар. и сущ.'
        else if ($speech='n adj') then 'сущ. и прил.'
        else if ($speech='prep adv') then 'пред. и нар.'
        else if ($speech='conj adv') then 'с. и нар.'
    else if (contains($speech, ' '))
        then concat($speech, '. ???')
    else concat($speech, '.')
};

declare function local:show-infect($ref as element()?) {
    let $form := $ref/inflect/@form
    return 
    if ($form='vowel-suppression')
        then ''
    else if ($form='plural')
        then 'мн.ч. '
    else if ($form='class-plural')
        then 'кл.мн.ч. '
    else if ($form='dual')
        then 'дв.ч. '
    else if ($form='infinitive')
        then 'инф. '
    else if ($form='present')
        then 'н.в. '
    else if ($form='aorist')
        then 'аор. '
    else if ($form='aorist 1st-sg')
        then 'аор. 1л. ед.ч. '
    else if ($form='present 1st-sg')
        then 'н.в. 1л. ед.ч. '
    else if ($form='present 3rd-sg')
        then 'н.в. 3л. ед.ч. '
    else if ($form='past 1st-sg')
        then 'пр.в. 1л. ед.ч. '
    else if ($form='imperative')
        then 'повел. '
    else if ($form='soft-mutation')
        then 'мяг.пер. '
    else if ($form='soft-mutation plural')
        then 'мяг.пер. мн.ч. '
    else if ($form='soft-mutation class-plural')
        then 'мяг.пер. кл.мн.ч. '
    else if ($form='soft-mutation present plural')
        then 'мяг.пер. н.в. мн.ч. '
    else if ($form='soft-mutation gerund')
        then 'мяг.пер. н.в. гер. '
    else if ($form='nasal-mutation plural')
        then 'нос.пер. мн.ч. '
    else if ($form='past')
        then 'пр.в. '
    else if ($form='strong-past') (: FIXME - Make strong-past a variant :)
        then 'пр.в. '
    else if ($form='genitive')
        then 'р.п. ед.ч. '
    else if ($form='genitive plural')
        then 'р.п. мн.ч. '
    else if ($form='genitive dual')
        then 'р.п. дв.ч. '
    else if ($form='prefix')
        then 'прист. '
    else if ($form='suffix')
        then 'суф. '
    else if ($form='stem')
        then 'осн. '
    else if ($form='possessive')
        then 'п.п. '
    else if ($form='gerund')
        then 'гер. '
    else if ($form='intensive')
        then ''
    else if ($form='ablative')
        then 'ис.п '
    else if ($form='locative')
        then 'м.п. '
    else if ($form='passive-participle')
        then 'стр.прич. '
    else concat($form, ' ??? ')
};

declare function local:is-root($word as element()) {
    if (c:get-speech($word)='root') then true()
    else if ($word/ref/@v='AIWĒ') then true()
    else false()
};


declare function local:show-refs($lang as xs:string*, $refs as element()*) {
    let $ref := $refs[c:get-lang(.)=$lang]
    return
    if (local:derive-css($ref[1]) = 'deleted') then
    <strike> {
        local:show-ref($lang, $refs)
    } </strike>
    else <span>{local:show-ref($lang, $refs)}</span>
};

declare function local:show-ref($lang as xs:string*, $refs as element()*) {
    let $ref := $refs[c:get-lang(.)=$lang]
    let $inflections := $ref/xdb:key($refs[1], 'inflect-to-ref', @source)[not(contains(@mark, '*'))]
    return (
        concat(
            if ($ref[1]/c:get-lang(.) = 'dor') then 'Dor. ' else '',
            if ($ref[1]/c:get-lang(.) = 'oss') then 'Oss. ' else '',
            if ($ref[1]/inflect[not(@form='infinitive')]) then local:show-infect($ref[1]) else (),
            if ($lang = 'mp' and $ref) then '*' else '',
            $ref/@mark/translate(., '-|', '')
        ),
        <i>
            {if ($ref/deriv/@i1) then concat($ref/deriv/@i1/string(), ', ') else ''}
            {if ($ref/deriv/@i2) then concat($ref/deriv/@i2/string(), ', ') else ''}
            {if ($ref/deriv/@i3) then concat($ref/deriv/@i3/string(), ', ') else ''}
            {$ref/@v/replace(., '/', ', ')}
        </i>,
        for $inflect in $inflections
        return (', ', 
            local:show-infect($inflect), 
            $ref/@mark/translate(., '-|', ''),
            <i>{$inflect/@v/replace(., '/', ', ')}</i>
        )
    )
};

<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1"></meta>
<title>Экспорт этимологий</title>
<link type="text/css" rel="stylesheet" href="../../css/global.css" />
<body>
<table>
<tr><th>Источник</th><th>Корень</th><th>Часть речи</th><th>PQ</th><th>Q</th><th>ON</th><th>N</th><th>T</th><th>Ilk</th><th>Dan</th><th>Fal</th></tr>
 {
for $word in //word[local:is-root(.)][ref[contains(@source, 'Ety')]]
let $refs := $word/ref[contains(@source, 'Ety')][not(correction)]
for $ref in $refs[xdb:key($word, 'deriv-to-ref', @source)]
let $derivs := local:find-derivatives($ref)
let $derivs2 := local:find-derivatives($derivs)
let $derivs3 := local:find-derivatives($derivs2)
let $derivs4 := local:find-derivatives($derivs3)
let $derivs5 := local:find-derivatives($derivs4)
let $all-derivs := ($derivs, $derivs2, $derivs3, $derivs4, $derivs5)
order by c:normalize-for-sort(substring-after(substring-before($ref/@source/string(), '.'), '/'))
return
for $deriv in $all-derivs
let $cognate-refs := $deriv/xdb:allReferenceCognates(.)
let $deriv-of-refs := $deriv/deriv/c:get-ref(.)[not(c:get-speech(.)='root')]
let $deriv-of-refs2 := $deriv-of-refs/deriv/c:get-ref(.)[not(c:get-speech(.)='root')]
let $all-deriv-ofs := ($deriv-of-refs, $deriv-of-refs2)
let $show-refs := $deriv | $cognate-refs | $all-deriv-ofs
return
if (local:skip-deriv($deriv, $cognate-refs)) then () else
<tr>
<td>{substring-before($ref/@source/string(), '.')}</td>
<td><span class="{local:derive-css($ref[1])}">{$ref/@v/string()}</span></td>
<td>{local:show-speech($deriv)}</td>
<td>{local:show-refs('mp', $show-refs)}</td>
<td>{local:show-refs('mq', $show-refs)}</td>
<td>{local:show-refs('on', $show-refs)}</td>
<td>{local:show-refs('n', $show-refs)}</td>
<td>{local:show-refs('mt', $show-refs)}</td>
<td>{local:show-refs(('ilk', 'dor'), $show-refs)}</td>
<td>{local:show-refs(('dan', 'oss'), $show-refs)}</td>
<td>{local:show-refs('fal', $show-refs)}</td>
</tr>
} </table>

</body>
</html>
