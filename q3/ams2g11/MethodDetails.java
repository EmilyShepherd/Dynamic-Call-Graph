package q3.ams2g11;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import org.aspectj.lang.Signature;

class MethodDetails
{
    private static HashMap methods = new HashMap();

    public static MethodDetails getInstance(Signature signature)
    {
        if (!methods.containsKey(signature))
        {
            methods.put(signature, new MethodDetails(signature));
        }

        return (MethodDetails)methods.get(signature);
    }

    public static HashMap getAll()
    {
        return methods;
    }

    private HashMap inFreqs    = new HashMap();
    private HashMap outFreqs   = new HashMap();
    private ArrayList runtimes = new ArrayList();
    private int failures       = 0;
    private double mean;
    private double sd;
    private Signature signature;
    private PrintWriter file;

    private MethodDetails(Signature signature)
    {
        this.signature = signature;
    }

    public void addFailure()
    {
        failures++;
    }

    public double getFailFreq()
    {
        return (double)failures / (double)runtimes.size() * 100;
    }

    public void addIn(int in)
    {
        add(in, inFreqs);
    }

    public void addOut(int out)
    {
        add(out, outFreqs);
    }

    public void addRuntime(Long time)
    {
        runtimes.add(time);
    }

    private void add(int val, HashMap freqs)
    {
        Integer key = Integer.valueOf(val);
        int freq    = 1;

        if (freqs.containsKey(key))
        {
            freq = 1 + ((Integer)freqs.get(key)).intValue();
        }

        freqs.put(key, Integer.valueOf(freq));
    }

    public void calculate()
    {
        Iterator it  = runtimes.iterator();
        long sumX     = 0;
        long sumXSqrd = 0;

        while (it.hasNext())
        {
            long x     = ((Long)it.next()).longValue();

            sumX     += x;
            sumXSqrd += x * x;
        }

        mean = sumX / runtimes.size();
        sd   = Math.sqrt((sumXSqrd - mean * sumX) / (runtimes.size() - 1));

    }

    public double getMean()
    {
        return mean;
    }

    public double getStandardDeviation()
    {
        return sd;
    }

    public void save()
    {
        try
        {
            file = new PrintWriter(signature + "-hist.csv", "UTF-8");

            saveFreqs(inFreqs,  "param");
            saveFreqs(outFreqs, "return");

            file.close();
        }
        catch (FileNotFoundException e)
        {
            throw new RuntimeException("File not writable");
        }
        catch (UnsupportedEncodingException e)
        {
            throw new RuntimeException("UTF8 not supported");
        }
    }

    private void saveFreqs(HashMap freqs, String type)
    {
        Iterator it = freqs.entrySet().iterator();

        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry)it.next();

            file.println(type + "," + entry.getKey() + "," + entry.getValue());
        }
    }
}