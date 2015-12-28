grammar FacebookGraph;


tokens
{
    CURLY_BRACE_START = '{';
    CURLY_BRACE_END   = '}';
    COMMA             = ',';
    COLON             = ':';
    QUOTES            = '"';
}

@header
{
package com.kk.facebook.webClient;

import com.kk.facebook.IFacebookData;
import com.kk.facebook.StringFacebookData;
import com.kk.facebook.FacebookObject;
import com.kk.facebook.FacebookObjectList;

import java.util.TreeMap;
}

@lexer::header
{
package com.kk.facebook.webClient;
}

start returns [FacebookObject value]
    :   fbGraphData=facebookGraphObject
        {
            $value = $fbGraphData.value;
        }
    ;

facebookGraphObject returns [FacebookObject value]
    :  CURLY_BRACE_START mainList=keyValuePairList CURLY_BRACE_END
       {
           $value = new FacebookObject($mainList.value);
       }
    ;

keyValuePairList returns [TreeMap<String, IFacebookData> value]
    :   pairVal = keyValuePair
        {
            $value = $pairVal.value;
        }
    |   pairVal = keyValuePair COMMA pairList = keyValuePairList
        {
            $pairList.value.putAll($pairVal.value);
            $value = $pairList.value;
        }
    ;

keyValuePair returns [TreeMap<String, IFacebookData> value]
    :   key = quotedString COLON val = graphKeyValue
        {
            $value = new TreeMap<String, IFacebookData>();
            $value.put($key.value, $val.value);
        }
    |
        {
            $value = null;
        }
    ;

quotedString returns [String value]
    :   str=STRING
        {
            $value = $str.text.substring(1, $str.text.length() - 1);
        }
    ;

graphKeyValue returns [IFacebookData value]
    :   strVal = quotedString
        {
            $value = new StringFacebookData($strVal.value);
        }
    ;


WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

STRING
    :  QUOTES (options {greedy=false;} : . )* QUOTES
    ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;
