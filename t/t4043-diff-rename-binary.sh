#!/bin/sh
#
# Copyright (c) 2010 Jakub Narebski, Christian Couder
#

test_description='Move a binary file'

. ./test-lib.sh


test_expect_success 'prepare repository' '
	git init &&
	echo foo > foo &&
	echo "barQ" | q_to_nul > bar &&
	git add . &&
	git commit -m "Initial commit"
'

test_expect_success 'move the files into a "sub" directory' '
	mkdir sub &&
	git mv bar foo sub/ &&
	git commit -m "Moved to sub/"
'

cat > expected <<\EOF
 bar => sub/bar |  Bin 5 -> 5 bytes
 foo => sub/foo |    0
 2 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/bar b/sub/bar
similarity index 100%
rename from bar
rename to sub/bar
diff --git a/foo b/sub/foo
similarity index 100%
rename from foo
rename to sub/foo
EOF

test_expect_success 'git show -C -C report renames' '
	git show -C -C --raw --binary --stat | tail -n 12 > current &&
	test_cmp expected current
'

test_done
