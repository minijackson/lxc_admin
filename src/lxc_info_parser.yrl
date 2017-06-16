Nonterminals
	name state
	pid cpu blkio memory kmem
	link ip tx rx total
	unknown
	output.

Terminals
	nameLabel stateLabel pidLabel cpuLabel blkIOLabel memoryLabel kMemLabel
	linkLabel ipLabel txLabel rxLabel totalLabel
	unknownLabel
	running stopped
	string number.

Rootsymbol
	output.

output -> name output : ['$1' | '$2'].
output -> state output : ['$1' | '$2'].
output -> pid output : ['$1' | '$2'].
output -> ip output : ['$1' | '$2'].
output -> cpu output : ['$1' | '$2'].
output -> blkio output : ['$1' | '$2'].
output -> memory output : ['$1' | '$2'].
output -> kmem output : ['$1' | '$2'].
output -> link output : ['$1' | '$2'].
output -> tx output : ['$1' | '$2'].
output -> rx output : ['$1' | '$2'].
output -> total output : ['$1' | '$2'].
output -> unknown output : '$2'.
output -> '$empty' : [].

name -> nameLabel string : {name, unpack('$2')}.

state -> stateLabel running : {state, running}.
state -> stateLabel stopped : {state, stopped}.

pid -> pidLabel number : {pid, unpack('$2')}.
ip -> ipLabel string : {ip, unpack('$2')}.
cpu -> cpuLabel number : {cpu, unpack('$2')}.
blkio -> blkIOLabel number : {blkIO, unpack('$2')}.
memory -> memoryLabel number : {memory, unpack('$2')}.
kmem -> kMemLabel number : {kMem, unpack('$2')}.
link -> linkLabel string : {link, unpack('$2')}.
tx -> txLabel number : {tx, unpack('$2')}.
rx -> rxLabel number : {rx, unpack('$2')}.
total -> totalLabel number : {total, unpack('$2')}.

unknown -> unknownLabel string.
unknown -> unknownLabel number.

Erlang code.

unpack({number, Num}) ->
	Num;

unpack({string, Str}) ->
	list_to_binary(Str).
