#require "lwt_react";;
#require "lambda-term";;

open LTerm_text;;
open LTerm_style;;

UTop.prompt := Lwt_react.S.const (eval [B_fg(red); S"➜ "; E_fg])