" Maintainer:   Lorenz Koehl <lorenz@quub.de>
" Last Changed: 2010 Apr
" Map from US layout to my custom layout

let b:keymap_name = "lo"


loadkeymap
""" Base characters
a       u
A       U
b       z
B       Z
c       ä
C       Ä
d       a
D       A
e       l
E       L
f       e
F       E
g       o
G       O
h       s
H       S
i       g
I       G
j       n
J       N
k       r
K       R
l       t
L       T
" m unchanged
n       b
N       B
o       f
O       F
p       q
P       Q
q       x
Q       X
r       c
R       C
s       i
S       I
t       w
T       W
u       h
U       H
v       p
V       P
w       v
W       V
x       ö
X       Ö
y       k
Y       K
z       ü
Z       Ü
[       ß
'       y
\"      Y
/       j
?       J
;       d
:       D

""" Punctuation
" , . unchanged


"" vim:fdm=expr:fdl=0
"" vim:fde=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='

