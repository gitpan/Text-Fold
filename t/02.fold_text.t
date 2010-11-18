use Test::More tests => 13;

BEGIN {
use_ok( 'Text::Fold' );
}

diag( "Testing Text::Fold $Text::Fold::VERSION" );

ok( fold_text('Hello World') eq 'Hello World', 'Simple string, no modification' );

my $nine_x = 'X' x 9;
my $eighty_x = 'X' x 80;
my $seventy_seven_x = 'X' x 77;
my $one_hundred_x = 'X' x 100;

ok( fold_text($eighty_x) eq "$seventy_seven_x\-\nXXX", 'Default width and default EOL' );
ok( fold_text("X$one_hundred_x",10) eq ("$nine_x\-\n" x 11) . "XX", 'Specified width and default EOL' );
ok( fold_text("X$one_hundred_x",10,"Y") eq ("${nine_x}\-Y" x 11) . "XX", 'Specified width and specified EOL' );
ok( fold_text("X$eighty_x",undef,"Z") eq "${seventy_seven_x}\-ZXXXX", 'default width and specified EOL' );

ok( 
    fold_text( "disparate\ndispara-te", 8 )
    eq
    "dispara-\nte\ndispara-\n-te",
    'Proper hyphenating'
);

ok(fold_text("\n\na b cd",3) eq "\n\na b\n cd", 'Beginning newlines preserved');
ok(fold_text("a b cd\n\n",3) eq "a b\n cd\n\n", 'Trailing newlines preserved');
ok(fold_text("\n\n\na b cd\n\n\n\n",3) eq "\n\n\na b\n cd\n\n\n\n", 'Beginning and Trailing newlines preserved');

# TODO break these out into more specific tests instead of multi things via one giant blob

ok(
fold_text('abcdefgh10XYZ
1234567
12345678
123456789
1234567890
12345678901

i am ten a
i am ten an
i am ten a z
i am tenab
i am tenabn
i am tenab z


123456“abcdef
1234567“abcdef
12345678“abcdef
123456789“abcdef
1234567890“abcdef',10)
eq 
'abcdefgh1-
0XYZ
1234567
12345678
123456789
1234567890
123456789-
01

i am ten a
i am ten  
an
i am ten a
 z
i am tenab
i am tena-
bn
i am tenab
 z


123456“ab-
cdef
1234567“a-
bcdef
12345678“-
abcdef
123456789-
“abcdef
123456789-
0“abcdef',
'Byte string (via char)'
);

ok(
fold_text("abcdefgh10XYZ
1234567
12345678
123456789
1234567890
12345678901

i am ten a
i am ten an
i am ten a z
i am tenab
i am tenabn
i am tenab z


123456\xE2\x80\x9Cabcdef
1234567\xE2\x80\x9Cabcdef
12345678\xE2\x80\x9Cabcdef
123456789\xE2\x80\x9Cabcdef
1234567890\xE2\x80\x9Cabcdef",10)
eq 
"abcdefgh1-
0XYZ
1234567
12345678
123456789
1234567890
123456789-
01

i am ten a
i am ten  
an
i am ten a
 z
i am tenab
i am tena-
bn
i am tenab
 z


123456\xE2\x80\x9Cab-
cdef
1234567\xE2\x80\x9Ca-
bcdef
12345678\xE2\x80\x9C-
abcdef
123456789-
\xE2\x80\x9Cabcdef
123456789-
0\xE2\x80\x9Cabcdef",
'Byte string (via grapheme cluster)'
);

ok(
fold_text("abcdefgh10XYZ
1234567
12345678
123456789
1234567890
12345678901

i am ten a
i am ten an
i am ten a z
i am tenab
i am tenabn
i am tenab z


123456\x{201c}abcdef
1234567\x{201c}abcdef
12345678\x{201c}abcdef
123456789\x{201c}abcdef
1234567890\x{201c}abcdef",10)
eq 
"abcdefgh1-
0XYZ
1234567
12345678
123456789
1234567890
123456789-
01

i am ten a
i am ten  
an
i am ten a
 z
i am tenab
i am tena-
bn
i am tenab
 z


123456\x{201c}ab-
cdef
1234567\x{201c}a-
bcdef
12345678\x{201c}-
abcdef
123456789-
\x{201c}abcdef
123456789-
0\x{201c}abcdef",
'Unicode string'
);