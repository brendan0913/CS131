echo ""
touch em
echo "Empty (0 B) file test"
echo "gzip:"
time gzip <em >gzip_em.gz
echo ""
echo "Single Pigzj (1 process):"
time java Pigzj -p 1 <em >PigzjS_em.gz
pigz -d <PigzjS_em.gz | cmp - em
echo ""
echo "pigz default:"
time pigz <em >pigz_em.gz
echo ""
echo "Parallel Pigzj default (4 processes):"
time java Pigzj <em >PigzjP_em.gz
pigz -d <PigzjP_em.gz | cmp - em
echo ""
echo "pigz 8 processes:"
time pigz -p 8 <em >pigz_em8.gz
echo ""
echo "Parallel Pigzj 8 processes:"
time java Pigzj -p 8 <em >PigzjP_em4.gz
pigz -d <PigzjP_em4.gz | cmp - em
ls -l gzip_em.gz pigz_em.gz pigz_em8.gz PigzjP_em.gz PigzjP_em4.gz PigzjS_em.gz
rm -f *.gz em

echo ""
input=/usr/local/cs/bin/setupg31
echo "Tiny (0.91 KB) file test: /usr/local/cs/bin/setupg31"
echo "gzip:"
time gzip <$input >gzip_s.gz
echo ""
echo "Single Pigzj (1 process):"
time java Pigzj -p 1 <$input >PigzjS_s.gz
pigz -d <PigzjS_s.gz | cmp - $input
echo ""
echo "pigz default:"
time pigz <$input >pigz_s.gz
echo ""
echo "Parallel Pigzj default (4 processes):"
time java Pigzj <$input >PigzjP_s.gz
pigz -d <PigzjP_s.gz | cmp - $input
echo ""
echo "pigz 2 processes:"
time pigz -p 2 <$input >pigz_s2.gz
echo ""
echo "Parallel Pigzj 2 processes:"
time java Pigzj -p 2 <$input >PigzjP_s2.gz
pigz -d <PigzjP_s2.gz | cmp - $input
echo ""
echo "pigz 8 processes:"
time pigz -p 8 <$input >pigz_s8.gz
echo ""
echo "Parallel Pigzj 8 processes:"
time java Pigzj -p 8 <$input >PigzjP_s8.gz
pigz -d <PigzjP_s8.gz | cmp - $input
echo ""
ls -l gzip_s.gz pigz_s.gz pigz_s2.gz pigz_s8.gz PigzjP_s.gz PigzjP_s2.gz PigzjP_s8.gz PigzjS_s.gz
rm -f *.gz em

echo ""
input=~/.bash_history
echo "Small (~11 KB, 11403 B) file test: ~/.bash_history"
echo "gzip:"
time gzip <$input >gzip_s.gz
echo ""
echo "Single Pigzj (1 process):"
time java Pigzj -p 1 <$input >PigzjS_s.gz
pigz -d <PigzjS_s.gz | cmp - $input
echo ""
echo "pigz default:"
time pigz <$input >pigz_s.gz
echo ""
echo "Parallel Pigzj default (4 processes):"
time java Pigzj <$input >PigzjP_s.gz
pigz -d <PigzjP_s.gz | cmp - $input
echo ""
echo "pigz 2 processes:"
time pigz -p 2 <$input >pigz_s2.gz
echo ""
echo "Parallel Pigzj 2 processes:"
time java Pigzj -p 2 <$input >PigzjP_s2.gz
pigz -d <PigzjP_s2.gz | cmp - $input
echo ""
echo "pigz 8 processes:"
time pigz -p 8 <$input >pigz_s8.gz
echo ""
echo "Parallel Pigzj 8 processes:"
time java Pigzj -p 8 <$input >PigzjP_s8.gz
pigz -d <PigzjP_s8.gz | cmp - $input
echo ""
ls -l gzip_s.gz pigz_s.gz pigz_s2.gz pigz_s8.gz PigzjP_s.gz PigzjP_s2.gz PigzjP_s8.gz PigzjS_s.gz
rm -f *.gz em

echo "" 
input=/u/cs/ugrad/rossmang/.vscode-server/data/User/globalStorage/tabnine.tabnine-vscode/binaries/3.3.130/x86_64-unknown-linux-musl/TabNine
echo "Small-medium (~22.9 MB, 22906544 B) file test: /u/cs/ugrad/rossmang/.vscode-server/data/User/globalStorage/tabnine.tabnine-vscode/binaries/3.3.130/x86_64-unknown-linux-musl/TabNine"
echo "gzip:"
time gzip <$input >gzip_m.gz
echo ""
echo "Single Pigzj (1 process):"
time java Pigzj -p 1 <$input >PigzjS_m.gz
pigz -d <PigzjS_m.gz | cmp - $input
echo ""
echo "pigz default:"
time pigz <$input >pigz_m.gz
echo ""
echo "Parallel Pigzj default (4 processes):"
time java Pigzj <$input >PigzjP_m.gz
pigz -d <PigzjP_m.gz | cmp - $input
echo ""
echo "pigz 2 processes:"
time pigz -p 2 <$input >pigz_m2.gz
echo ""
echo "Parallel Pigzj 2 processes:"
time java Pigzj -p 2 <$input >PigzjP_m2.gz
pigz -d <PigzjP_m2.gz | cmp - $input
echo ""
echo "pigz 8 processes:"
time pigz -p 8 <$input >pigz_m8.gz
echo ""
echo "Parallel Pigzj 8 processes:"
time java Pigzj -p 8 <$input >PigzjP_m8.gz
pigz -d <PigzjP_m8.gz | cmp - $input
echo ""
ls -l gzip_m.gz pigz_m.gz pigz_m2.gz pigz_m8.gz PigzjP_m.gz PigzjP_m2.gz PigzjP_m8.gz PigzjS_m.gz
rm -f *.gz em

echo "" 
input=/usr/local/cs/jdk-16.0.1/lib/modules
echo "Medium (~125 MB, 125942959 B) file test: /usr/local/cs/jdk-16.0.1/lib/modules"
echo "gzip:"
time gzip <$input >gzip_m.gz
echo ""
echo "Single Pigzj (1 process):"
time java Pigzj -p 1 <$input >PigzjS_m.gz
pigz -d <PigzjS_m.gz | cmp - $input
echo ""
echo "pigz default:"
time pigz <$input >pigz_m.gz
echo ""
echo "Parallel Pigzj default (4 processes):"
time java Pigzj <$input >PigzjP_m.gz
pigz -d <PigzjP_m.gz | cmp - $input
echo ""
echo "pigz 2 processes:"
time pigz -p 2 <$input >pigz_m2.gz
echo ""
echo "Parallel Pigzj 2 processes:"
time java Pigzj -p 2 <$input >PigzjP_m2.gz
pigz -d <PigzjP_m2.gz | cmp - $input
echo ""
echo "pigz 8 processes:"
time pigz -p 8 <$input >pigz_m8.gz
echo ""
echo "Parallel Pigzj 8 processes:"
time java Pigzj -p 8 <$input >PigzjP_m8.gz
pigz -d <PigzjP_m8.gz | cmp - $input
echo ""
ls -l gzip_m.gz pigz_m.gz pigz_m2.gz pigz_m8.gz PigzjP_m.gz PigzjP_m2.gz PigzjP_m8.gz PigzjS_m.gz
rm -f *.gz em

echo "" 
input=/var/lib/rpm/Packages
echo "Large (~228 MB, 228253696 B) file test: /var/lib/rpm/Packages"
echo "gzip:"
time gzip <$input >gzip_l.gz
echo ""
echo "Single Pigzj (1 process):"
time java Pigzj -p 1 <$input >PigzjS_l.gz
pigz -d <PigzjS_l.gz | cmp - $input
echo ""
echo "pigz default:"
time pigz <$input >pigz_l.gz
echo ""
echo "Parallel Pigzj default (4 processes):"
time java Pigzj <$input >PigzjP_l.gz
pigz -d <PigzjP_l.gz | cmp - $input
echo ""
echo "pigz 2 processes:"
time pigz -p 2 <$input >pigz_l2.gz
echo ""
echo "Parallel Pigzj 2 processes:"
time java Pigzj -p 2 <$input >PigzjP_l2.gz
pigz -d <PigzjP_l2.gz | cmp - $input
echo ""
echo "pigz 8 processes:"
time pigz -p 8 <$input >pigz_l8.gz
echo ""
echo "Parallel Pigzj 8 processes:"
time java Pigzj -p 8 <$input >PigzjP_l8.gz
pigz -d <PigzjP_l8.gz | cmp - $input
echo ""
ls -l gzip_l.gz pigz_l.gz pigz_l2.gz pigz_l8.gz PigzjP_l.gz PigzjP_l2.gz PigzjP_l8.gz PigzjS_l.gz
rm -f *.gz em

echo "" 
input=/u/cs/ugrad/rossmang/cs97/assign4/emacs/.git/objects/pack/pack-4cd86561dd7392340f4e2dc012a0bc686a425102.pack
echo "Larger (~312 MB, 311545642 B) file test: /u/cs/ugrad/rossmang/cs97/assign4/emacs/.git/objects/pack/pack-4cd86561dd7392340f4e2dc012a0bc686a425102.pack"
echo "gzip:"
time gzip <$input >gzip_l.gz
echo ""
echo "Single Pigzj (1 process):"
time java Pigzj -p 1 <$input >PigzjS_l.gz
pigz -d <PigzjS_l.gz | cmp - $input
echo ""
echo "pigz default:"
time pigz <$input >pigz_l.gz
echo ""
echo "Parallel Pigzj default (4 processes):"
time java Pigzj <$input >PigzjP_l.gz
pigz -d <PigzjP_l.gz | cmp - $input
echo ""
echo "pigz 2 processes:"
time pigz -p 2 <$input >pigz_l2.gz
echo ""
echo "Parallel Pigzj 2 processes:"
time java Pigzj -p 2 <$input >PigzjP_l2.gz
pigz -d <PigzjP_l2.gz | cmp - $input
echo ""
echo "pigz 8 processes:"
time pigz -p 8 <$input >pigz_l8.gz
echo ""
echo "Parallel Pigzj 8 processes:"
time java Pigzj -p 8 <$input >PigzjP_l8.gz
pigz -d <PigzjP_l8.gz | cmp - $input
echo ""
ls -l gzip_l.gz pigz_l.gz pigz_l2.gz pigz_l8.gz PigzjP_l.gz PigzjP_l2.gz PigzjP_l8.gz PigzjS_l.gz
rm -f *.gz em


input=~/.bash_history
strace gzip <$input >gzip.gz 2> gzip_strace.txt
strace pigz <$input >pigz.gz 2> pigz_strace.txt
strace java Pigzj <$input >Pigzj.gz 2> Pigzj_strace2.txt
rm -f *.gz 
