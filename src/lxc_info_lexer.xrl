Definitions.

Number = ([0-9]+)
String = ([a-zA-Z0-9-_\.]+)

Whsp = ([\s\t\n]+)

Rules.

(Name:)         : {token, {nameLabel, TokenLine}}.
(State:)        : {token, {stateLabel, TokenLine}}.
(PID:)          : {token, {pidLabel, TokenLine}}.
(IP:)           : {token, {ipLabel, TokenLine}}.
(CPU\suse:)     : {token, {cpuLabel, TokenLine}}.
(BlkIO\suse:)   : {token, {blkIOLabel, TokenLine}}.
(Memory\suse:)  : {token, {memoryLabel, TokenLine}}.
(KMem\suse:)    : {token, {kMemLabel, TokenLine}}.
(Link:)         : {token, {linkLabel, TokenLine}}.
(TX\sbytes:)    : {token, {txLabel, TokenLine}}.
(RX\sbytes:)    : {token, {rxLabel, TokenLine}}.
(Total\sbytes:) : {token, {totalLabel, TokenLine}}.

RUNNING         : {token, {running, TokenLine}}.
STOPPED         : {token, {stopped, TokenLine}}.

([a-zA-Z0-9-_\.\s]+:) : {token, {unknownLabel, TokenLine}}.

{Number} : {token, {number, to_integer(TokenChars)}}.
{String} : {token, {string, TokenChars}}.

{Whsp} : skip_token.

Erlang code.

to_integer(Str) ->
	{Num, []} = string:to_integer(Str),
	Num.
