if (![].includes) {
  Array.prototype.includes = function(searchElement /*, fromIndex*/ ) {'use strict';
    var O = Object(this);
    var len = parseInt(O.length) || 0;
    if (len === 0) {
      return false;
    }
    var n = parseInt(arguments[1]) || 0;
    var k;
    if (n >= 0) {
      k = n;
    } else {
      k = len + n;
      if (k < 0) {k = 0;}
    }
    var currentElement;
    while (k < len) {
      currentElement = O[k];
      if (searchElement === currentElement ||
         (searchElement !== searchElement && currentElement !== currentElement)) {
        return true;
      }
      k++;
    }
    return false;
  };
}

words = [];
combines = {};
wordLookup = {};
for (var i = 0; i < index.length; i++) {
    var item = index[i];
    var array = item.split('%');
    if (array.length < 7) continue;
    var word = {};
    word.lang = array[0];
    word.value = array[1];
    word.speech = array[2];
    word.gloss = array[3];
    word.mark = array[4];
    word.deletemark = (word.mark.indexOf('-') >= 0) ? '-' : (word.mark.indexOf('|') >= 0) ? '|' : '';
    word.mark = word.mark.replace('-', '').replace('|', '');
    word.key = array[5];
    word.ref = array[6];
    word.match = toMatch(word.value);
    word.matchNoDiacritics = toMatchNoDiacritics(word.value);
    words.push(word);
    wordLookup[word.key] = word;
}

function replaceAll(c1, c2, value) {
	// FIXME: optimize
	var previous = value;
	var result = previous.replace(c1, c2);
	while (result != previous) {
		previous = result;
		result = previous.replace(c1, c2);
	}
	return result;
}

function doReplace(charReplace1, charReplace2, value) {
	var result = value;
	for (var i = 0; i < charReplace1.length; i++) {
		var c = charReplace1[i];
		if (result.indexOf(c) >= 0) {
			if (i < charReplace2.length) {
				result = replaceAll(c, charReplace2[i], result);
			} else {
	            result = replaceAll(c, '', result);
			}
		}
	}
	return result;
}

function charReplace(value) {
    var charReplace1 = '¹²³⁴⁵⁶⁷⁸⁹'; 
    var charReplace2 = '';
    return doReplace(charReplace1, charReplace2, value).trim();
}

function ignoreDiacritic(value) {
    var charReplace1 = 'ḷḹẏýṃṇṛṝñŋáéíóúýäëïöüāēīōūâêîôûŷăĕĭŏŭæǣǭřšё¹²³⁴⁵⁶⁷⁸⁹̆,`¯̯̥́̄̂'; 
    var charReplace2 = 'llyymnrrnnaeiouyaeiouaeiouaeiouyaeiouaeorsе';
    return doReplace(charReplace1, charReplace2, value).trim();
}

function toMatch(value) {
    return charReplace(value.toLowerCase()).trim();
}

function toMatchNoDiacritics(value) {
    return ignoreDiacritic(value.toLowerCase()).trim();
}

function convertLang(lang, speech) {
	var converted = '';
    if (lang === 'p')
        converted = '✶';
    else if (lang === 'mp')
        converted = 'ᴹ✶';
    else if (lang === 'ep')
        converted = 'ᴱ✶';
    else if (lang === 'np')
        converted = 'ᴺ✶';
    else if (lang === 'mq')
        converted = 'ᴹQ. ';
    else if (lang === 'maq')
        converted = 'ᴹAQ. ';
    else if (lang === 'nq')
        converted = 'ᴺQ. ';
    else if (lang === 'et')
        converted = 'ᴱT.';
    else if (lang === 'mt')
        converted = 'ᴹT. ';
    else if (lang === 'ns')
        converted = 'ᴺS. ';
    else if (lang === 'norths')
        converted = 'North S. ';
    else if (lang === 'ln')
        converted = 'ᴸN. ';
    else if (lang === 'en')
        converted = 'ᴱN. ';
    else if (lang === 'eon')
        converted = 'ᴱON. ';
    else if (lang === 'eoq')
        converted = 'ᴱOQ. ';
    else if (lang === 'eilk')
        converted = 'ᴱIlk. ';
    else if (lang === 'eq')
        converted = 'ᴱQ. ';
    else if (lang === 'ad')
        converted = 'Ad. ';
    else if (lang === 'pad')
        converted = '✶Ad. ';
    else if (lang === 'kh')
        converted = 'Kh. ';
    else if (lang === 'ed')
        converted = 'Ed. ';
    else if (lang === 'av')
        converted = 'Av. ';
    else if (lang === 'un')
        converted = 'Un. ';
    else if (lang.length === 1 || lang.length === 2)
        converted = lang.toUpperCase() + '. ';
    else 
        converted = lang.charAt(0).toUpperCase() + lang.substring(1) + '. ';
    if (speech === 'root') {
    	converted = converted.replace('✶', '√');
    }
    return converted;
}

function convertSpeech(speech) {
    //if (speech.indexOf(' ') > 0) {
    //  var a = speech.split(' ');
    //  var result = convertSpeech(a[0]);
    //  for (var i = 1; i < a.length; i++) {
    //      result += " and " + convertSpeech(a[i]);
    //  }
    //  return result;
    //}
    //else if (speech === 'masc-name') speech = 'm.';
    if (speech === 'masc-name') speech = 'м.';
    else if (speech === 'fem-name') speech = 'ж.';
    else if (speech === 'place-name') speech = 'геогр.';
    else if (speech === 'collective-name') speech = 'собир.';
    else if (speech === 'collective-noun') speech = 'собир.';
    else if (speech === 'proper-name') speech = 'им.';
    else if (speech === 'cardinal') then speech = 'к. числ';
    else if (speech === 'ordinal') then speech = 'п. числ.';
    else if (speech === 'vb') speech = 'гл.';
    else if (speech === 'proper-name') speech = 'им.';
    else if (speech === 'n') speech = 'сущ.'; 
    else if (speech === 'adj') speech = 'прил.';      
    else if (speech === 'adv') speech = 'нар.';
    else if (speech === 'pron') speech = 'мест.';
    else if (speech === 'conj') speech = 'с.';
    else if (speech === 'interj') speech = 'межд.';
    else if (speech === 'suf') speech = 'суф.';
    else if (speech === 'pref') speech = 'прист.';
    else if (speech === 'prep') speech = 'пред.';
    else if (speech === 'root') speech = 'кор.';
    else if (speech === 'adv adj') speech = 'нар. и прил.';
    else if (speech === 'adj adv') speech = 'прил. и нар.';
    else if (speech === 'adj n') speech = 'прил. и сущ.';
    else if (speech === 'adv n') speech = 'нар. и сущ.';
    else if (speech === 'n adj') speech = 'сущ. и прил.';
    else if (speech === 'prep adv') speech = 'пред. и нар.'; 
    else if (speech === 'conj adv') speech = 'с. и нар.';

    else speech += '.';
    return speech;
}

function initSearchBox() {
}

function initSearch() {
    var langSelect = document.getElementById('langSelect');
    for (var i = 0; i < langs.length; i++) {
        var item = langs[i];
        var array = item.split('%');
        if (array.length < 2) continue;
        var o = new Option(array[1], array[0]);
        // langSelect.options.add(o);
    }
    doSearch();
}

var BUFFER = 50;
var pos = 0;
var max = 0;

function doSearchTyping() {
	doSearch()
}

function doSearch() {
	setTimeout(asyncSearch, 10);
}

function asyncSearch() {
	searchIt(50);
}

var SEARCH_SET = '';

function searchIt(buffer) {
	BUFFER = buffer;
	pos = 0; // Clear buffer
    var searchBox = document.getElementById('searchBox');
    var searchText = searchBox.value;
    while (searchText.indexOf(' =') > 0) {
    	searchText = searchText.replace(' =', '=');
    }
    var langSelect = document.getElementById('langSelect');
    var lang = langSelect.options[langSelect.selectedIndex].value;
    var target = "word-only";
    var position = 'regex';
    var partsOfSpeechSelect = document.getElementById('partsOfSpeechSelect');
    var partsOfSpeech = partsOfSpeechSelect.options[partsOfSpeechSelect.selectedIndex].value;
    var diacriticSelect = document.getElementById('diacriticSelect');
    var diacriticMatch = diacriticSelect.options[diacriticSelect.selectedIndex].value;
    var currentSearchSet = searchText + '@' + lang + '@' + target + '@' + position + '@' + partsOfSpeech + '@' + diacriticMatch + '@' + BUFFER;
    if (currentSearchSet != SEARCH_SET) {
    	SEARCH_SET = currentSearchSet;
    } else {
    	return; // Skip
    }
    var noNames = (partsOfSpeech == 'no-names');
    var onlyNames = (partsOfSpeech == 'only-names');
    var partsOfSpeech = (partsOfSpeech == 'no-names' || partsOfSpeech == 'only-names') ? '' : partsOfSpeech;
    var langs = [];
    if (lang.length > 0) {
    	langs = lang.split('|');
    }
    var resultList = document.getElementById('resultList');
    var first = [];
    var count = 0;
    for (var i = 0; i < words.length; i++) {
    	var word = words[i];
    	if (isMatch(word, searchText, target, position, partsOfSpeech, diacriticMatch)) {
            if (noNames && word.speech.indexOf('name') > 0) {
                continue;
            }
            if (onlyNames && word.speech.indexOf('name') <= 0) {
                continue;
            }
    		if (langs.length === 0 || langs.includes(word.lang)) {
    			var set = first;
    			set.push(word);
    			if (count >= BUFFER + 1) {
    				break;
    			}
    		}
    	}
    }
    var result = first;
    max = result.length;
    if (pos > maxPos()) pos = maxPos();
    var count = pos;
    var html = wordsToHtml(result, pos);
    if (pos + BUFFER < max) {
    	html += '<dt id="loadingZone">Loading...</dt>';
    }
    resultList.innerHTML = html;
	var loadingZone = document.getElementById('loadingZone');
	if (isInViewport(loadingZone)) {
		searchIt(BUFFER + 50);
	}
}

function wordsToHtml(result, pos) {
    var count = pos;
    var html = '';
    for (; count < result.length && count < pos + BUFFER; count++) {
    	var word = result[count];
    	var markclass = (word.deletemark === '-') ? 'deleted' : (word.deletemark === '|') ? 'deleted-section' : ''; 
        html += '<dt>';
        if (word.altlang && (word.altlang.indexOf('√') > 0 || word.altlang.indexOf('✶') > 0)
        		&& word.mark.indexOf('!') < 0) {
            html += '[' + word.altlang.substring(0, 1) +']';
        }
        var langValue = convertLang(word.lang, word.speech);
        html += langValue;
        html += word.mark;
        var ext = '.html';
        html += '<a href="../words/word-' + word.key + ext + '">';
        var value = word.value;
        html += '<span style="font-weight: bold" class="' + markclass + '">' + value + '</span></a>';
        html += '</a>';
        html += ' <i>' + convertSpeech(word.speech) + '</i> ';
        if (word.gloss) {
        	html += ' “' + word.gloss + '”';
        }
        if (word.ref) {
            html += ' (' + word.ref + ')';
        }
        html += '</dt>';
    }
    return html;
}

function isMatch(word, searchText, target, position, partsOfSpeech, diacriticMatch) {
	var searches = searchText.split('+');
	for (var i = 0; i < searches.length; i++) {
		if (!orMatch(word, searches[i], target, position, partsOfSpeech, diacriticMatch)) return false;
	}
	if ((word.lang == 'np' || word.lang == 'nq' || word.lang == 'ns')) {
		return false;
	}
	return true;
}

function orMatch(word, searchText, target, position, partsOfSpeech, diacriticMatch) {
	if (searchText.startsWith('word=')) {
		target = 'word';
        position = 'contains'
		searchText = searchText.substring(5);
	} else if (searchText.startsWith('regex=')) {
        target = 'word';
        position = 'regex'
        searchText = searchText.substring(6);
    }
	var searches = searchText.split(',');
	for (var i = 0; i < searches.length; i++) {
        var matcher = (diacriticMatch === 'ignore') ? toMatchNoDiacritics : toMatch;
		if (checkMatch(word, matcher(searches[i]), target, position, partsOfSpeech, diacriticMatch)) return true;
	}
	return false;
}

function checkMatch(word, searchText, target, position, partsOfSpeech, diacriticMatch) {
	if (partsOfSpeech != '') {
		if ((' ' + word.speech + ' ').indexOf(' ' + partsOfSpeech + ' ') < 0) {
			return false;
		}
	}
	var matcher = containsMatch;
    if (position == 'regex') {
        matcher = regexMatch;
    }
    var baseMatch = (diacriticMatch === 'ignore') ? word.matchNoDiacritics : word.match;
	if (target.indexOf('word') >= 0 && (matcher(baseMatch, searchText))) {
		return true;
	}
	return false;
}

function containsMatch(text, searchText) {
    return text.indexOf(searchText) >= 0;
}

function regexMatch(text, searchText) {
    var re = new RegExp(searchText);
    return text.match(re);
}

function maxPos() {
	var result = max - 1;
	result = result - (result % BUFFER);
	return result;
}

function reset() {
    var searchBox = document.getElementById('searchBox');
    searchBox.value = '';
    var langSelect = document.getElementById('langSelect');
    langSelect.selectedIndex = 0;
    var partsOfSpeechSelect = document.getElementById('partsOfSpeechSelect');
    partsOfSpeechSelect.selectedIndex = 0;
    var diacriticSelect = document.getElementById('diacriticSelect');
    diacriticSelect.selectedIndex = 0;
	window.stickyhelp = false;
    showHelp();
    doSearch();
}

function advanced() {
    var searchSelectors = document.getElementById('search-selectors');
    display = getComputedStyle(searchSelectors, null).getPropertyValue('display');
    if (display == 'block') {
    	searchSelectors.style.display = 'none';
    } else {
    	searchSelectors.style.display = 'block';
    }
}

function help() {
	window.stickyhelp = !window.stickyhelp;
    var helpDiv = document.getElementById('help-div');
    display = getComputedStyle(helpDiv, null).getPropertyValue('display');
    if (display == 'block') {
    	helpDiv.style.display = 'none';
    } else {
    	helpDiv.style.display = 'block';
    }
}

function hideHelp() {
	if (window.stickyhelp) {
		return;
	}
    var helpDiv = document.getElementById('help-div');
	helpDiv.style.display = 'none';
}

function showHelp() {
    var helpDiv = document.getElementById('help-div');
	helpDiv.style.display = 'block';
}

//-----------------//
// Infinite Scroll //
//-----------------//

function posY(elmt) {
    var test = elmt, top = 0;
    while(!!test && test.tagName.toLowerCase() !== "body") {
        top += test.offsetTop;
        test = test.offsetParent;
    }
    return top;
}

function viewportHeight() {
	var docElmt = document.documentElement;
	if (!!window.innerWidth) {
		return window.innerHeight;
	} else if (docElmt && !isNaN(docElmt.clientHeight)) {
		return docElmt.clientHeight;
	}
	return 0;
}

function scrollY() {
	if (window.pageYOffset) {
		return window.pageYOffset;
	}
	return Math.max(document.documentElement.scrollTop, document.body.scrollTop);
}

function isInViewport(elmt) {
	if (elmt == null) return false;
    return !(posY(elmt) > (viewportHeight() + scrollY()));
}

var scrollLock = false;

function checkLoading() {
	if (scrollLock) return;
	scrollLock = true;
	var loadingZone = document.getElementById('loadingZone');
	if (isInViewport(loadingZone)) {
		searchIt(BUFFER + 50);
	}
	scrollLock = false;
}

window.onscroll = checkLoading;
