Introduction:
    My Pigzj implementation closely imitates pigz's compression in performance speed and compression ratio (number of compressed bytes /
number of bytes of original file), and far surpasses gzip's compression in both performance time and having a better compression ratio, 
especially for large files. For smaller files, Pigzj does not match pigz's compression as well (but is still much closer to pigz's compression
than it is to gzip's compression except for very small files) due to the large overhead of creating and running parallel threads each with
their own data structures, which I will get into. 
    To test the individual performances of gzip, pigz, and my Pigzj, I ran tests running gzip, pigz, and Pigzj on seven different files 
(an empty file, tiny file, small file, small-medium, medium file, large file, and larger file), and for each file, I ran pigz and Pigzj with
a single process (command -p 1), 2 processes (command -p 2), 4 processes (command -p 4, which is the default number of processes), and 8 
processes (command -p 8). For each individual test (for the gzip, pigz, pigz/Pigzj 2 processes, pigz/Pigzj default processes, pigz/Pigzj 8 
processes, and Pigzj single process), I ran 3 trials each to get a better gauge of the perforamnce and effiicency. When analzying the results
of the tests (which are taken using the time command), I mainly consider the results of real time (not user, or sys), even though the results
of user for Pigzj compared to pigz and gzip are interesting. For each of the files and combinations of different process numbers, I ran 3 trials 
each. Below are the results of the average real, user, and sys time. The compression ratio for each file is the same for pigz, Pigzj, and gzip
(the number of compressed bytes is deterministic, so for each file the compression ratio is the same, regardless of the number of processes). The 
compression ratio for Pigzj is much closer to the compression ratio for pigz than it is to gzip.

Results of trials:
All reported times are averages over 3 trials. 
The compressed bytes as reported by ls -l are always the same for each of Pigzj, pigz, and gzip.

Empty (0 B) file test
gzip:
real    0m0.0026667s
user    0m0.0006667s
sys     0m0.0006667s

Single Pigzj (1 process):
real    0m0.055s
user    0m0.0286667s
sys     0m0.023s

pigz default:
real    0m0.0026667s
user    0m0.0006667s
sys     0m0.0006667s

Parallel Pigzj default (4 processes):
real    0m0.055s
user    0m0.0283333s
sys     0m0.022s

pigz 8 processes:
real    0m0.003s
user    0m0.0006667s
sys     0m0.0006667s

Parallel Pigzj 8 processes:
real    0m0.0553333s
user    0m0.0286667s
sys     0m0.022s

gzip, pigz, and Pigzj all have 20 bytes (the header, trailer, and 2 bytes signifying it is empty)
The compression ratio is compressed/original = 20 B/0 B = infinity

Tiny (0.91 KB) file test: /usr/local/cs/bin/setupg31
gzip:
real    0m0.0026667s
user    0m0.000s
sys     0m0.001s

Single Pigzj (1 process):
real    0m0.0553333s
user    0m0.0266667s
sys     0m0.0243333s

pigz default:
real    0m0.003s
user    0m0.0003333s
sys     0m0.0016667s

Parallel Pigzj default (4 processes):
real    0m0.062s
user    0m0.039s
sys     0m0.0246667s

pigz 2 processes:
real    0m0.003s
user    0m0.0006667s
sys     0m0.0013333s

Parallel Pigzj 2 processes:
real    0m0.059s
user    0m0.0346667s
sys     0m0.024s

pigz 8 processes:
real    0m0.003s
user    0m0.0003333s
sys     0m0.0013333s

Parallel Pigzj 8 processes:
real    0m0.0663333s
user    0m0.0436667s
sys     0m0.023s

gzip, pigz, and Pigzj all have 518 bytes.
The original file has 910 B.
The compression ratio is compressed/original = 518 B/910 B = 0.569231 = 56.9%

Small (~11 KB, 11403 B) file test: ~/.bash_history
gzip:
real    0m0.003s
user    0m0.0003333s
sys     0m0.0006667s

Single Pigzj (1 process):
real    0m0.056s
user    0m0.028s
sys     0m0.021s

pigz default:
real    0m0.004s
user    0m0.0003333s
sys     0m0.0016667s

Parallel Pigzj default (4 processes):
real    0m0.0643333s
user    0m0.038s
sys     0m0.0256667s

pigz 2 processes:
real    0m0.004s
user    0m0.001s
sys     0m0.001s

Parallel Pigzj 2 processes:
real    0m0.0633333s
user    0m0.0383333s
sys     0m0.0266667s

pigz 8 processes:
real    0m0.0036667s
user    0m0.001s
sys     0m0.001s

Parallel Pigzj 8 processes:
real    0m0.0613333s
user    0m0.040s
sys     0m0.023s

gzip, pigz, and Pigzj all have 1577 bytes.
The original file has 11403 B.
The compression ratio is compressed/original = 1577 B/11403 B = 0.1382969 = 13.8%

Small-medium (~22.9 MB, 22906544 B) file test:
    /u/cs/ugrad/rossmang/.vscode-server/data/User/globalStorage/tabnine.tabnine-vscode/binaries/3.3.130/x86_64-unknown-linux-musl/TabNine
gzip:
real    0m1.786s
user    0m1.737s
sys     0m0.024s

Single Pigzj (1 process):
real    0m1.782s
user    0m1.714s
sys     0m0.049s

pigz default:
real    0m0.494s
user    0m1.705s
sys     0m0.039s

Parallel Pigzj default (4 processes):
real    0m0.781s
user    0m2.395s
sys     0m0.135s

pigz 2 processes:
real    0m0.870s
user    0m1.702s
sys     0m0.033s

Parallel Pigzj 2 processes:
real    0m1.008s
user    0m2.654s
sys     0m0.163s

pigz 8 processes:
real    0m0.502s
user    0m1.704s
sys     0m0.048s

Parallel Pigzj 8 processes:
real    0m0.854s
user    0m2.339s
sys     0m0.148s
ls -l reports 12288535 B for gzip.
ls -l reports 12284478 B for Pigzj.
ls -l reports 12284124 B for pigz.
The original file has 22906544 B.
The compression ratio is compressed/original:
    For gzip: 0.5364639 = 53.65%
    For Pigzj: 0.5362868 = 53.63%
    For pigz: 0.5362713 = 53.63%
As you can see, Pigzj compresses input much more closely to how pigz compresses input in the compression ratio.
As for the performance of Pigzj, for small files, there is way more overhead in Pigzj's implementation, which will be explained in more detail.

Medium (~125 MB, 125942959 B) file test: /usr/local/cs/jdk-16.0.1/lib/modules
gzip:
real    0m7.526s
user    0m7.290s
sys     0m0.152s

Single Pigzj (1 process):
real    0m7.151s
user    0m6.968s
sys     0m0.142s

pigz default:
real    0m1.995s
user    0m7.009s
sys     0m0.141s

Parallel Pigzj default (4 processes):
real    0m2.799s
user    0m8.932s
sys     0m0.539s

pigz 2 processes:
real    0m3.587s
user    0m7.188s
sys     0m0.103s

Parallel Pigzj 2 processes:
real    0m3.842s
user    0m10.416s
sys     0m0.494s

pigz 8 processes:
real    0m2.073s
user    0m7.034s
sys     0m0.175s

Parallel Pigzj 8 processes:
real    0m3.099s
user    0m9.223s
sys     0m0.445s

ls -l reports 43261332 B for gzip.
ls -l reports 43136276 B for Pigzj.
ls -l reports 43134815 B for pigz.
The original file has 125942959 B.
The compression ratio is compressed/original:
    For gzip: 34.35%
    For Pigzj: 34.251%
    For pigz: 34.249%
As you can see, Pigzj compresses input much more closely to how pigz compresses input in the compression ratio.
Additionally, we are now starting to see as the file length increases, Pigzj with multiple processes is nearly as fast as pigz with the same number of processses (it is
much closer to pigz's efficiency than it is to gzip's efficiency), while Pigzj with single process is as slow as gzip (which is expected since gzip does not have
parallel processes).

Large (~228 MB, 228253696 B) file test: /var/lib/rpm/Packages
gzip:
real    0m10.407s
user    0m10.239s
sys     0m0.109s

Single Pigzj (1 process):
real    0m10.279s
user    0m10.017s
sys     0m0.198s

pigz default:
real    0m2.997s
user    0m10.109s
sys     0m0.200s

Parallel Pigzj default (4 processes):
real    0m3.899s
user    0m12.706s
sys     0m0.609s

pigz 2 processes:
real    0m5.199s
user    0m10.062s
sys     0m0.273s

Parallel Pigzj 2 processes:
real    0m5.495s
user    0m14.956s
sys     0m0.608s

pigz 8 processes:
real    0m3.137s
user    0m10.119s
sys     0m0.245s

Parallel Pigzj 8 processes:
real    0m4.485s
user    0m12.696s
sys     0m0.638s

ls -l reports 63253414 B for gzip.
ls -l reports 63191875 B for Pigzj.
ls -l reports 63189272 B for pigz.
The original file has 228253696 B.
The compression ratio is compressed/original:
    For gzip: 27.71%
    For Pigzj: 27.685%
    For pigz: 27.684%
As you can see, Pigzj compresses input much more closely to how pigz compresses input in the compression ratio.
As the file length increases, Pigzj with multiple processes is nearly as fast as pigz with the same number of processses (it is
much closer to pigz's efficiency than it is to gzip's efficiency), while Pigzj with single process is as slow as gzip (which is expected since gzip does not have
parallel processes). However, it seems that 8 processes for my Pigzj implementation is unnecessary and in fact, makes it run slower. Pigzj with 2 processes 
is close to pigz with 2 processes, but Pigzj with 8 processes is not as close as pigz with 8 processes.

Larger (~312 MB, 311545642 B) file test: 
    /u/cs/ugrad/rossmang/cs97/assign4/emacs/.git/objects/pack/pack-4cd86561dd7392340f4e2dc012a0bc686a425102.pack
gzip:
real    0m14.142s
user    0m13.567s
sys     0m0.394s

Single Pigzj (1 process):
real    0m12.845s
user    0m11.996s
sys     0m0.568s

pigz default:
real    0m5.184s
user    0m12.229s
sys     0m0.551s

Parallel Pigzj default (4 processes):
real    0m5.110s
user    0m13.696s
sys     0m0.987s

pigz 2 processes:
real    0m6.552s
user    0m11.993s
sys     0m0.823s

Parallel Pigzj 2 processes:
real    0m6.857s
user    0m16.112s
sys     0m1.121s

pigz 8 processes:
real    0m4.832s
user    0m12.210s
sys     0m0.619s

Parallel Pigzj 8 processes:
real    0m5.298s
user    0m14.254s
sys     0m1.236s

ls -l reports 297615287 B for gzip.
ls -l reports 297784205 B for Pigzj.
ls -l reports 297776955 B for pigz.
The original file has 311545642 B.
The compression ratio is compressed/original:
    For gzip: 95.53%
    For Pigzj: 95.583%
    For pigz: 95.581%
As you can see, Pigzj compresses input much more closely to how pigz compresses input in the compression ratio.
As the file length increases, Pigzj with multiple processes is nearly as fast as pigz with the same number of processses (it is
much closer to pigz's efficiency than it is to gzip's efficiency), while Pigzj with single process is as slow as gzip (which is expected since gzip does not have
parallel processes). Now, it seems that for very large files, 8 processes for my Pigzj implementation is much closer to 8 processes for pigz.
This makes sense: it is unnecessary to go through a lot of overhead of creating 8 processes for smaller files, as only the default 4 processes are needed.
However, when the file sizes get really large, 8 processes Pigzj performs nearly as well as 4 processes Pigzj, and with larger files it is likely that
8 processes Pigzj will exceed 4 processes Pigzj in efficiency. 
Additionally, we see that my default Pigzj overtakes the pigz implementation in efficiency, so for smaller files, Pigzj and pigz are not extremely
close, but Pigzj is much closer to pigz's performance than it is to gzip's performance. However, when the size of the file increases, Pigzj gets much
more competitive with pigz. Even Single process Pigzj begins to overtake gzip's performance when the files get large.
Note: This is a packfile that no longer exists at the time I write this report; I do not know exactly why the compression ratio for this file 
and the other files are so different, and I cannot test this file under these trials again. I simply chose this packfile because it was very large.

Analysis of results:
    My implementation of Pigzj mainly makes use of 2 objects: SinglePigzj and ParallelPigzj. SinglePigzj is almost exactly the same as 
the starter code, and Pigzj uses the compressInput method of SinglePigzj when the inputted processes is 1. This is why Pigzj runs just as fast as 
gzip does for most files (since gzip is also a single process compressor). 
    Pigzj uses the ParallelPigzj object and methods when the inputted processes is not 1 (or default, which gets the processes number from the available
processes method in the Runtime object). ParallelPigzj creates one thread per each block (which has 131072 size), so if the inputted processes number
is greater than the amount of processes that is needed, then ParallelPigzj only creates the number of threads needed. For example, if the inputted processes
number is 8, but the input is very small (so only, say, 2 threads are needed), then only 2 threads are created. To concurrently write to the outstream, 
ParallelPigzj uses a ConcurrentWrite object that compresses and writes the bytes to each block for each thread. Most importantly, the reason why the
overhead for creating threads and executing them is so large is because 3 ConcurrentHashMaps are created for each thread: a map for the compressed bytes, 
uncompressed bytes, and the dictionaries. These hash maps are used as follows: threads write deflated bytes to a compressed stream, which then is
written to the compressed bytes map. Likewise, threads write uncompressed bytes to the uncompressed map because threads must know about the dictionaries
of each block before they begin writing to the compressed stream. Then, while threads are still writing their own data to the maps, the main thread 
writes the data from the compressed and uncompressed maps to the outstream. Then, if the last block is reached, then the thread pool is shut down.
    This large overhead of creating 3 concurrent hash maps for each thread explains why ParallelPigzj is not nearly as fast as pigz and gzip for 
very small files (files that are less than a KB), but are nearly as fast or as fast as pigz (and much much faster than gzip) for larger files (in the
MB range, >= 20 MB). The large overhead of the hash maps and threads severely slows down the performance of Pigzj for small files, since the actual 
time needed for compressing and writing for a very small file is very little (a single process works better for small files).
    As the input size of the files increases, ParallelPigzj nearly matches pigz for 2 processes, 4 processes, and 8 processes. It makes sense why 
8 processes is overkill for medium-sized files (as we can see in the results for these files); just like why multiple processes is overkill for 
very small files, 8 processes is overkill for medium files. We can see the difference when the file size increases. For the largest file tested,
ParallelPigzj 8 processes matched pigz 8 processes and nearly matched ParallelPigzj 4 processes.
    It is interesting to see that 2 processes for both Pigzj and pigz is not as fast as 4 processes. This is because having 4 threads compressing
and writing is more important than not having to go through the overhead of making 4 threads and hash maps for each.
    Additionally, while we mainly prioritize the real time in comparing the performances, it is interesting to note the user time and sys time.
Excluding the very small files (since for both pigz and Pigzj, the user time is less than the real time) and the SinglePigzj trials (for obvious 
reasons), the user time is much higher than the real time; this is because the threads hardly ever wait, not executing anything. Instead, threads
are always compressing, writing to the hash maps, and writing from the hash maps to the out stream, and this is why I used ConcurrentHashMaps 
to make sure threads never wait too long to execute. If real time were much higher than than user time, then that means the threads are spending
a lot of time waiting and not executing anything, but this is clearly not the case from the data from the trials.
    For the sys time, Pigzj has higher sys time than pigz does; this must be because I use more system calls than pigz does. I suspect it is due to 
the hasMoreInput method, which calls read and unread on the input stream to check if there is more input, and this method is called over and over 
again to see if there is more input to be read, as I use a PushbackInputStream as opposed to a regular InputStream.

In short:
    For very small files, pigz and gzip's performance are similar in speed, whereas Pigzj falls behind due to the massive overhead that is needed
in my implemntation. The compression ratio is the same for all 3 programs.
    For medium-large files, Pigzj and pigz are nearly the same in both efficiency and compression ratio, and both far surpass gzip's performance. 
SinglePigzj much more closely matches gzip. We can see why 4 processes is the default number for both pigz and Pigzj; 2 processes is too slow, 
and the overhead of maintaining 8 processes is too high for files that are not extremely large. 4 processes is the perfect balance; not too little
threads compressing and writing, and not too much overhead to create the threads. 
    For very large files, Pigzj and pigz are very nearly the same in both performance and compression ratio, and both far surpass gzip's performance.
Once again, SinglePigzj much more closely matches gzip and even exceeds it. However, with very large files, we can start to see why 8 processes is 
preferred; it is okay to go through the large overhead of creating 8 processes, and now it is much faster to have 8 processes compressing and writing
the bytes instead of just 4.
    In general, I would use pigz over gzip or Pigzj, since pigz is the best at very small and medium-large files. For the largest file I tested, 
ParallelPigzj and pigz finally match each other for defualt processes, but in general I would still use pigz, since it is much more robust when 
handling errors and is much faster for small files.
    For very small files, I would either choose pigz or gzip; either one gets the job done quickly and with the same compression ratio.
While Pigzj has the same compression ratio, it is much slower for very small files.
    For larger files, I would choose pigz because it compresses slightly better and faster, but I would not be disappointed to use my ParallelPigzj.
I would definitely not use gzip or SinglePigzj. ParallelPigzj default processes seems to even surpass default pigz for the largest file, so it is
definitely possible that I might use ParallelPigzj for very large files, but additionally, pigz has a better compression ratio, so I might always
just use pigz.

straces of gzip, pigz, and Pigzj:
    The straces of gzip, pigz, and Pigzj differ in that pigz and Pigzj make syscalls to futex, which is a kernel system call for basic locking 
and a building block for higher-level locking like mutexes and semaphores, whereas gzip makes no calls to any locking system calls. 
    Pigzj, gzip, and pigz make many calls to read, close, lseek, mmap, and mprotect, as they deal with memory mappings to continuously write bytes
and data to new memory. pigz and Pigzj call clone to make a child process, while gzip does not.
    A large difference between Pigzj and pigz and gzip is that Pigzj makes a bunch of calls to openat and stat to open many jdk files and libraries, 
whereas pigz does not. Finally, when Pigzj succeeds in opening them (by not getting a No such file or directory error), it is able to begin reading
writing, and so on. (This strange process happens for multiple different input files, not just one).

    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/haswell/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls/haswell/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/haswell/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls/haswell/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/haswell/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls/haswell/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/haswell/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls/haswell", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/tls/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/tls", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/haswell/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/haswell/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/haswell/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/haswell/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/haswell/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/haswell/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/haswell/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/haswell", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls/haswell", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/tls/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/tls", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/haswell/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/haswell/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/haswell/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/haswell/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/haswell/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/haswell/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/haswell/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/haswell", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/avx512_1/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/avx512_1/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/avx512_1/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/avx512_1", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/x86_64/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib/x86_64", 0x7ffecc93b510) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/usr/local/cs/jdk-16.0.1/bin/../lib/libz.so.1", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
    stat("/usr/local/cs/jdk-16.0.1/bin/../lib", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
    openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
    fstat(3, {st_mode=S_IFREG|0644, st_size=110790, ...}) = 0
    ...
    These sys calls do not happen in pigz in such a manner; pigz, like Pigzj, make sys calls like these to JDK libraries dispersed throughout the 
strace, but pigz does not repeatedly try and fail to open directories/files like Pigzj does initially.

    These differences obviously explain why pigz and Pigzj do better than gzip does for large files (they make use of parallel processing).
The slight performance difference between Pigzj and pigz can be explained by this strange process where Pigzj repeatedly tries to open 
multiple JDK files and fails to do so. Without these failed system calls, then the straces for Pigzj and pigz look much more similar.
If the performance difference is not explained by that, then the difference between Pigzj and pigz can be explained by the fact that it seems 
that pigz makes more calls the futex than Pigzj does - this might imply that pigz possibly begins parallel processing earlier in its runtime. 
Other than that, it seems that pigz and Pigzj are much more similar in how they use mmap, mprotect, read, close, etc.