import java.nio.*;
import java.io.*;
import java.util.zip.*;
import java.util.concurrent.*;
import java.util.ArrayList;
import java.util.Objects;

class Attributes {
    public static final int BLOCK_SIZE = 131072;
    public static final int DICT_SIZE = 32768;
    public Config config;
    public CRC32 crc = new CRC32();
    public PushbackInputStream in = new PushbackInputStream(System.in);
    public OutputStream out = System.out;
}

class Config {
    private volatile int proc;
    private volatile int processCount = 0;
    private volatile int lastBlock = 0;
    private Semaphore s = new Semaphore(1, true);

    public int getProcNum() { return this.proc; }
    public void setProcNum(int p) {
        if (p == 2) this.proc = 3;
        else this.proc = p; 
    }
    public synchronized int incProcess() {
        processCount++;
        return processCount;
    }
    public void sem_wait() throws InterruptedException { s.acquire(); }
    public void sem_post() throws InterruptedException { s.release(); }
    public synchronized void setLast(int i) { lastBlock = i; } 
    public synchronized int getLast() { return lastBlock; }
}

class Utils {
    private final static int GZIP_MAGIC = 0x8b1f;
    private final static int TRAILER_SIZE = 8;
    
    public static void printError(Throwable t) {
        System.err.println(t.toString());
        System.exit(1);
    }
    public static void printError(String s) {
        System.err.println(s);
        System.exit(1);
    }
    // Referenced the starter code for writeHeader and writeTrailer
    public static void writeHeader(OutputStream out) throws IOException { 
        out.write(new byte[] {
            (byte) GZIP_MAGIC,
            (byte)(GZIP_MAGIC >> 8),
            Deflater.DEFLATED,
            0,
            0, 0, 0, 0,
            0,
            0});
    }
    public static void writeTrailer(OutputStream out, int crc, int size) throws IOException {
        byte[] trailerBuf = new byte[TRAILER_SIZE];
        writeInt(crc, trailerBuf, 0);
        writeInt(size, trailerBuf, 4);
        out.write(trailerBuf, 0, TRAILER_SIZE);
    }
    private static void writeInt(int i, byte[] buf, int offset) throws IOException {
        writeShort(i & 0xffff, buf, offset);
        writeShort((i >> 16) & 0xffff, buf, offset + 2);
    }
    private static void writeShort(int s, byte[] buf, int offset) throws IOException {
        buf[offset] = (byte)(s & 0xff);
        buf[offset + 1] = (byte)((s >> 8) & 0xff);
    }
    public static boolean hasMoreInput(PushbackInputStream in) {
        try {
            int result;
            if ((result = in.read()) < 0) 
                return false;
            else {
                in.unread(result);
                return true;
            }
        } catch (Throwable t) { return false; }
    }
}

class SinglePigzj extends Attributes {
    public SinglePigzj(Config sconfig) {
        config = sconfig;
    }
    // Referenced the starter code comrpess method (very similar)
    public void compressInput() throws IOException { 
        Utils.writeHeader(out);
        byte[] blockBuf = new byte[BLOCK_SIZE];
        byte[] cmpBlockBuf = new byte[BLOCK_SIZE * 2];
        Deflater compressor = new Deflater(Deflater.DEFAULT_COMPRESSION, true);

        int fileBytes = in.available();
        int nBytes = in.read(blockBuf);
        int totalBytesRead = nBytes;
        int deflatedBytes = 0;
        while (nBytes > 0) {
            crc.update(blockBuf, 0, nBytes);
            compressor.setInput(blockBuf, 0, nBytes);
            if (totalBytesRead == fileBytes) {
                if (!compressor.finished()) {
                    compressor.finish();
                    while (!compressor.finished())
                        deflatedBytes = compressor.deflate(cmpBlockBuf, 0, cmpBlockBuf.length, Deflater.NO_FLUSH);
                }
            } else
                deflatedBytes = compressor.deflate(cmpBlockBuf, 0, cmpBlockBuf.length, Deflater.SYNC_FLUSH);
            if (nBytes >= DICT_SIZE) {
                byte[] dictBuf = new byte[DICT_SIZE];
                System.arraycopy(blockBuf, nBytes - DICT_SIZE, dictBuf, 0, DICT_SIZE);
                compressor.setDictionary(dictBuf);
            }
            nBytes = in.read(blockBuf);
            totalBytesRead += nBytes;
            out.write(cmpBlockBuf, 0, deflatedBytes);
        }
        if (fileBytes == 0)     // Empty file has two bytes besides the header and trailer
            out.write(new byte[] {0x03, 0x00}, 0, 2);
        Utils.writeTrailer(out, (int)crc.getValue(), fileBytes);
    }
} 

class ParallelPigzj extends Attributes { 
    public ParallelPigzj(Config pconfig){
        config = pconfig;
    }
    public void compressInput() throws IOException {
        int nProcesses = config.getProcNum();
        ThreadPoolExecutor threadPool = new ThreadPoolExecutor(nProcesses, nProcesses, 1L, TimeUnit.SECONDS, 
                                                        new ArrayBlockingQueue<Runnable>(nProcesses));
        float lf = 0.7f;
        ConcurrentHashMap<Integer,byte[]> compMap = new ConcurrentHashMap<Integer,byte[]>(nProcesses, lf, nProcesses);
        ConcurrentHashMap<Integer,byte[]> uncompMap = new ConcurrentHashMap<Integer,byte[]>(nProcesses, lf, nProcesses);
        ConcurrentHashMap<Integer,byte[]> dictMap = new ConcurrentHashMap<Integer,byte[]>(nProcesses, lf, nProcesses);
        Utils.writeHeader(out);
        ByteArrayOutputStream uncomp = new ByteArrayOutputStream();
        ArrayList<Runnable> threads = new ArrayList<Runnable>(nProcesses - 1);
        byte[] blockBuf = new byte[BLOCK_SIZE];
        boolean firstBlock = true;
        boolean lastBlock = true;
        int threadNum = 0;
        int nBytes = in.read(blockBuf);
        int totalBytesRead = nBytes;
        while (nBytes > 0 && threadNum < nProcesses - 1) {
            if (totalBytesRead < BLOCK_SIZE && Utils.hasMoreInput(in)){
                nBytes = in.read(blockBuf);
                totalBytesRead += nBytes;
            }
            else {
                uncomp.write(blockBuf, 0, totalBytesRead);
                byte[] readBytes = new byte[totalBytesRead];
                System.arraycopy(blockBuf, 0, readBytes, 0, totalBytesRead);

                lastBlock = !Utils.hasMoreInput(in);
                threadNum = config.incProcess();
                threads.add(new ConcurrentWrite(in, config, totalBytesRead, readBytes, threadNum, 
                                            firstBlock, lastBlock, compMap, uncompMap, dictMap));
                firstBlock = false;     // The first block thread has been added; now the rest of the blocks are not first
                if (totalBytesRead >= BLOCK_SIZE && !lastBlock) {   // Last block does not need a dictionary
                    byte[] dictBuf = new byte[DICT_SIZE];
                    System.arraycopy(blockBuf, BLOCK_SIZE - DICT_SIZE, dictBuf, 0, DICT_SIZE);
                    dictMap.put(threadNum, dictBuf); 
                }
                nBytes = totalBytesRead;
                totalBytesRead = 0;
            }
        }
        while(threads.size() > 0)
            threadPool.execute(threads.remove(threads.size() - 1));
        int compIter = 1;
        int uncompIter = nProcesses;
        boolean noMore = false;
        // Write contents of compressed and uncompressed stream maps to out stream while threads are writing to hash maps
        while ((threadPool.getActiveCount() > 0 || compMap.size() > 0 || uncompMap.size() > 0) && !noMore) {
            if (uncompMap.containsKey(uncompIter)) {
                uncomp.write(uncompMap.get(uncompIter));
                uncompMap.remove(uncompIter);
                uncompIter++;
            }
            if (compMap.containsKey(compIter)) {
                out.write(compMap.get(compIter));
                compMap.remove(compIter);
                if (compIter == config.getLast())
                    noMore = true;
                compIter++;
            }
        }
        threadPool.shutdown();
        byte[] totalBytes = uncomp.toByteArray();
        if (totalBytes.length == 0) // Empty file has two bytes besides the header and trailer
            out.write(new byte[] {0x03, 0x00}, 0, 2);
        crc.update(totalBytes);
        Utils.writeTrailer(out, (int)crc.getValue(), totalBytes.length);
    }
}

class ConcurrentWrite extends Attributes implements Runnable {
    private byte[] buffer;
    private int bufSize;
    private int threadNum;
    private boolean isFirst;
    private boolean isLast;
    private PushbackInputStream in;
    private ConcurrentHashMap<Integer,byte[]> compMap;
    private ConcurrentHashMap<Integer,byte[]> uncompMap;
    private ConcurrentHashMap<Integer,byte[]> dictMap;
    private byte[] compBuffer;
    private ByteArrayOutputStream compStream;

    public ConcurrentWrite(PushbackInputStream in, Config pconfig, int nBytes, byte[] buf, int t, 
                    boolean first, boolean last, ConcurrentHashMap<Integer,byte[]> cMap,
                    ConcurrentHashMap<Integer,byte[]> uMap, ConcurrentHashMap<Integer,byte[]> dMap) {
        this.in = in;
        this.config = pconfig;
        this.buffer = buf;
        this.bufSize = nBytes;
        this.threadNum = t;
        this.isFirst = first;
        this.isLast = last;
        this.compMap = cMap;
        this.uncompMap = uMap;
        this.dictMap = dMap;
        compBuffer = new byte[BLOCK_SIZE * 2];
        compStream = new ByteArrayOutputStream();
    }
    public void run() { // Referenced the starter code (very much like the compress method)
        boolean notEOF = true;
        int deflatedBytes = 0;
        while (notEOF) {
            try {
                if (bufSize == 0) break;
                compStream.reset(); 
                Deflater defl = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
                byte[] dict = dictMap.get(threadNum - 1);
                if (!isFirst && !Objects.isNull(dict))
                    defl.setDictionary(dict);
                defl.setInput(buffer, 0, bufSize);
                if (isLast && !defl.finished()){
                    defl.finish(); 
                    while (!defl.finished())
                        deflatedBytes = defl.deflate(compBuffer, 0, compBuffer.length, Deflater.NO_FLUSH);
                }
                else
                    deflatedBytes = defl.deflate(compBuffer, 0, compBuffer.length, Deflater.SYNC_FLUSH);
                compStream.write(compBuffer, 0, deflatedBytes);
                compMap.put(threadNum, compStream.toByteArray());
            } catch (Throwable t) {
                Utils.printError(t);
            }
            notEOF = readNext();
        }
    }
    private synchronized boolean readNext() {
        if (isLast)
            return false;
        int nBytes = 0;
        int totalBytesRead = 0;

        try { config.sem_wait(); } catch (InterruptedException e) {}
        try {
            nBytes = in.read(buffer, totalBytesRead, BLOCK_SIZE - totalBytesRead);
            totalBytesRead = nBytes;
            while (nBytes > 0){
                if (!Utils.hasMoreInput(in))
                    break;
                nBytes = in.read(buffer, totalBytesRead, BLOCK_SIZE - totalBytesRead);
                totalBytesRead += nBytes;
            }
        } catch (Throwable t) {
            try { config.sem_post(); } catch (InterruptedException e) {}
            Utils.printError(t);
        }
        if (totalBytesRead <= 0) {
            try { config.sem_post(); } catch (InterruptedException e) {}
            return false;
        }
        threadNum = config.incProcess(); 
        bufSize = totalBytesRead;
        byte[] newBuf = new byte[totalBytesRead];
        System.arraycopy(buffer, 0, newBuf, 0, totalBytesRead);
        uncompMap.put(threadNum, newBuf);  

        if (!Utils.hasMoreInput(in)) {
            config.setLast(threadNum);
            isLast = true;
        }
        if (totalBytesRead >= BLOCK_SIZE && !isLast) {
            byte[] dict = new byte[DICT_SIZE];
            System.arraycopy(buffer, BLOCK_SIZE - DICT_SIZE, dict, 0, DICT_SIZE);
            dictMap.put(threadNum, dict);
        }
        isFirst = false;
        try { config.sem_post(); } catch (InterruptedException e) {}
        return true;
    }
}

class Pigzj {
    public Pigzj(Config config) {
        if (config.getProcNum() == 1) {
            SinglePigzj s = new SinglePigzj(config);
            try { s.compressInput(); } catch (IOException e) { Utils.printError(e); }
        }
        else {
            ParallelPigzj p = new ParallelPigzj(config);
            try { p.compressInput(); } catch (IOException e) { Utils.printError(e); }
        }
    }
    public static void main(String[] args) {
        Config config = new Config();
        config.setProcNum(Runtime.getRuntime().availableProcessors());
        int i = 0;
        int len = args.length;
        while(i < len){
            if (args[i].equals("-p")) {
                if (i != len - 1) {
                    try {
                        int processes = Integer.parseInt(args[i + 1]);
                        if (processes >= 1000)
                            Utils.printError("pigz: abort: lack of virtual memory for '" + args[i + 1].toString() + "' processes");
                        config.setProcNum(processes);
                    } catch (NumberFormatException e) {
                        Utils.printError("pigz: abort: invalid numeric parameter: " + args[i].toString());
                    }
                }
                else Utils.printError("pigz: abort: missing parameter after -p");
            }
            i++;
        }
        new Pigzj(config);
    }
}
